<?php  namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletingTrait;

class UseRouteCompanion extends Model {

	use SoftDeletingTrait;

	protected $table = 'user_route_companion';
} 