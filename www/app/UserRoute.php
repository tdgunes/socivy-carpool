<?php  namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletingTrait;

class UserRoute extends Model {

	use SoftDeletingTrait;

	protected $table = 'user_routes';

	protected $guarded = [];

	protected $appends = array('seats', 'canRequest', 'canCancel');

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
		$route = Self::where('id', $this->id)->with(['companions' => function($q) use ($userID) {
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
} 