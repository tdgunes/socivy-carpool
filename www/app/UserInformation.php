<?php  namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletingTrait;

class UserInformation extends Model {

	use SoftDeletingTrait;

	protected $table = 'user_information';

	protected $guarded = [];
} 