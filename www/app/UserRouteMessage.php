<?php  namespace App;

use Illuminate\Database\Eloquent\SoftDeletingTrait;
use Illuminate\Database\Eloquent\Model;

class UserRouteMessage extends Model {

	use SoftDeletingTrait;

	protected $table = 'user_route_messages';

	protected $guarded = [];

	protected $dates = ['created_time'];

	public function room()
	{
		return $this->belongsTo('App\\UserRouteMessageRoom', 'room_id' ,'id');
	}

	public function user()
	{
		return $this->belongsTo('App\\User', 'user_id', 'id');
	}

} 