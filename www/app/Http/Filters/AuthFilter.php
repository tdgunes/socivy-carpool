<?php namespace App\Http\Filters;

use Illuminate\Http\Request;
use Illuminate\Routing\Route;
use Illuminate\Contracts\Auth\Authenticator;
use Illuminate\Contracts\Routing\ResponseFactory;
use Cartalyst\Sentry\Facades\Laravel\Sentry;
use Illuminate\Support\Facades\Redirect;

class AuthFilter {

	/**
	 * The authenticator implementation.
	 *
	 * @var Authenticator
	 */
	protected $auth;

	/**
	 * The response factory implementation.
	 *
	 * @var ResponseFactory
	 */
	protected $response;

	/**
	 * Create a new filter instance.
	 *
	 */
	public function __construct()
	{

	}

	/**
	 * Run the request filter.
	 *
	 * @param  \Illuminate\Routing\Route  $route
	 * @param  \Illuminate\Http\Request  $request
	 * @return mixed
	 */
	public function filter(Route $route, Request $request)
	{
		if (!Sentry::check())
		{
			if ($request->ajax())
			{
				return $this->response->make('Unauthorized', 401);
			}
			else
			{
				return Redirect::route('auth.login');
			}
		}
	}

}
