<?php  namespace App\Http\Controllers;

use App\User;
use App\UserRoute;
use Cartalyst\Sentry\Facades\Laravel\Sentry;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\View;

class MeController extends Controller {

	public function index() {
		$user = User::where('id', Sentry::getUser()->id)
				->with([
					'routes' => function($q) {
						return $q->withOnRoads();
					},
					'companions'
				])
				->first();

		$myCarRoutes = $user->routes;

		$myRoutes = $user->companions()->withOnRoads()->get();

/*
		var_dump(\DB::getQueryLog(), $myRoutes->toArray(), [
			'myCarRoutes' => $myCarRoutes,
			'myRoutes' => $myRoutes
		]); die();
*/
		return View::make('me.index', [
			'myCarRoutes' => $myCarRoutes,
			'myRoutes' => $myRoutes
		]);
	}
} 