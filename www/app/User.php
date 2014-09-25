<?php namespace App;

class User extends \Cartalyst\Sentry\Users\Eloquent\User {

	/**
	 * The database table used by the model.
	 *
	 * @var string
	 */
	protected $table = 'users';

	public function routes()
	{
		$this->hasMany('App\\UserRoute', 'user_id', 'id');
	}

	public function companions()
	{
		return $this->belongsToMany('App\\UserRoute', 'user_route_companions', 'user_id', 'route_id');
	}

	public function information()
	{
		return $this->hasOne('App\\UserInformation', 'user_id', 'id');
	}
}
