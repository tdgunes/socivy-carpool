<?php  namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletingTrait;

class UserRouteGeneralSetting extends Model {

	use SoftDeletingTrait;

	protected $table = 'user_route_general_settings';

	protected $guarded = [];


} 