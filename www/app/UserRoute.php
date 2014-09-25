<?php  namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletingTrait;
use Carbon\Carbon;

class UserRoute extends Model {

	use SoftDeletingTrait;

	protected $table = 'user_routes';

	protected $guarded = [];

	protected $appends = array('seats', 'canRequest', 'canCancel', 'withOnRoad');

	public static $ON_ROAD_MODIFY = '-1 hour';

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
		return $this->belongsToMany('App\\User', 'user_route_companions', 'route_id', 'user_id');
	}

	public function getDates()
	{
		return array('created_at', 'updated_at', 'deleted_at', 'action_time');
	}

	public function getSeatsAttribute()
	{
		$companionsCount = $this->companions()->count();
		return $this->attributes['available_seat'] - $companionsCount;
	}

	public function getCanRequestAttribute()
	{
		$userID = \Sentry::getUser()->id;
		$route = $this->where('id', $this->id)->with(['companions' => function($q) use ($userID) {
			$q->where('user_id', $userID);
		}])->first();

		if(
			$userID == $route->user_id
			||
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

	public function getOnRoadAttribute()
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