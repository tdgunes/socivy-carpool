<?php  namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletingTrait;
use Carbon\Carbon;

class UserRoute extends Model {

	use SoftDeletingTrait;

	protected $table = 'user_routes';

	protected $guarded = [];

	protected $appends = array('seats', 'canRequest', 'canCancel', 'canCreateMessageRoom', 'isOnRoad', 'isOwner');

	protected $dates = ['action_time'];

	public static $ON_ROAD_MODIFY = '-30 minute';

	public function user()
	{
		return $this->belongsTo('App\\User', 'user_id', 'id');
	}

	public function places()
	{
		return $this->hasMany('App\\UserRoutePlace', 'route_id', 'id');
	}

	public function companions()
	{
	//	return $this->hasMany('App\\UserRouteCompanion', 'route_id', 'id');

		return $this->belongsToMany('App\\User', 'user_route_companions', 'route_id', 'user_id')
				->whereNull('deleted_at')
				->withTimestamps();
	}

	public function messageRooms()
	{
		return $this->hasMany('App\\UserRouteMessageRoom', 'route_id', 'id');
	}

	public function getSeatsAttribute()
	{
		$companionsCount = $this->companions()->count();
		return $this->attributes['available_seat'] - $companionsCount;
	}

	/**
	 * @return bool
	 */
	public function getCanCreateMessageRoomAttribute()
	{
		return  ! $this->getIsOwnerAttribute()
				&&
				$this->messageRooms()
					->where('creator_id', \Sentry::getUser()->id)
					->count() == 0;
	}

	public function getIsOwnerAttribute()
	{
		$userID = \Sentry::getUser()->id;

		// If this user isn't owner of this route.
		return $this->attributes['user_id'] == $userID;
	}

	public function getCanRequestAttribute()
	{
		$userID = \Sentry::getUser()->id;
		$route = $this->where('id', $this->id)->with(['companions' => function($q) use ($userID) {
			$q->where('user_id', $userID);
		}])->first();

		if(
			// Eğer Rotada yer yoksa
			$route->seats == 0
			||
			// Eğer rotanın sahibi ise
			$userID == $route->user_id
			||
			// Eğer rotanın katılımcısı ise
			count($route->companions->toArray()) > 0
		)
		{
			return false;
		}

		return true;
	}

	public function getCanCancelAttribute()
	{
		$userID = \Sentry::getUser()->id;
		$route = $this->where('id', $this->id)->with(['companions' => function($q) use ($userID) {
			$q->where('user_id', $userID);
		}])->first();

		if(
			count($route->companions->toArray()) > 0
		)
		{
			return true;
		}

		return false;
	}

	public function getIsOnRoadAttribute()
	{
		$now = Carbon::now();

		if( $this->action_time->diffInMinutes($now, false) > 0 )
		{
			return false;
		}
		else {
			return true;
		}
	}

	public function scopeWithOnRoads($q)
	{
		$time = Carbon::now()->modify(self::$ON_ROAD_MODIFY);
		return $q->where('action_time', '>', $time);
	}
} 