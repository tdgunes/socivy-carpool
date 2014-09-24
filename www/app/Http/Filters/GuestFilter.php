<?php namespace App\Http\Filters;

use Cartalyst\Sentry\Facades\Laravel\Sentry;
use Illuminate\Support\Facades\Redirect;

class GuestFilter {

	/**
	 * The authenticator implementation.
	 *
	 * @var Authenticator
	 */
	protected $auth;

	/**
	 * Create a new filter instance.
	 */
	public function __construct()
	{
	}

	/**
	 * Run the request filter.
	 *
	 * @return mixed
	 */
	public function filter()
	{
		if (Sentry::check())
		{
			return Redirect::route('home');
		}
	}

}
