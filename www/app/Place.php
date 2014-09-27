<?php  namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletingTrait;

class Place extends Model {

	use SoftDeletingTrait;

	protected $table = 'places';

	protected $guarded = [];


} 