<?php  namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletingTrait;

class UserRoute extends Model {

	use SoftDeletingTrait;

	protected $table = 'user_routes';

	public function user()
	{
		return $this->belongsTo('App\\User', 'user_id', 'id');
	}

	public function places()
	{
		return $this->belongsToMany('App\\Place', 'user_route_places', 'route_id', 'id');
	}

	public function companions()
	{
		return $this->belongsToMany('App\\User', 'user_route_companions', 'route_id', 'id');
	}
} 