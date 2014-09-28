<?php  namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletingTrait;

class UserRouteCompanion extends Model {

	use SoftDeletingTrait;

	protected $table = 'user_route_companions';

	public function user()
	{
		return $this->belongsTo('App\User', 'user_id', 'id');
	}

	public function routes()
	{
		return $this->belongsTo('App\UserRoutePlace', 'route_id', 'id');
	}
} 