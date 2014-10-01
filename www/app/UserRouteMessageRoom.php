<?php  namespace App;

use Illuminate\Database\Eloquent\SoftDeletingTrait;
use Illuminate\Database\Eloquent\Model;

class UserRouteMessageRoom extends Model {

	use SoftDeletingTrait;

	protected $table = 'user_route_message_rooms';

	protected $guarded = [];

	public function route()
	{
		return $this->belongsTo('App\\UserRoute', 'route_id', 'id');
	}

	public function messages()
	{
		return $this->hasMany('App\\UserRouteMessage', 'room_id' ,'id');
	}

	public function creator()
	{
		return $this->belongsTo('App\\User', 'creator_id', 'id');
	}

} 