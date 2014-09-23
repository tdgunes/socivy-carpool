<?php namespace App;

use Illuminate\Database\Eloquent\Model;

class Place extends Model {

	use SoftDeletingTrait;

    /**
	 * @var string
	 */
    protected $table = 'places';
    
    /**
	 * @var array
	 */    
    protected $fillable = [];
}