<?php  namespace App\Http\Controllers;

use App\Http\Requests\Me\UpdateSettings;
use App\User;
use App\UserRoute;
use Cartalyst\Sentry\Facades\Laravel\Sentry;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\View;

class MeController extends Controller {

	public function index() {
		$user = User::where('id', Sentry::getUser()->id)
				->with([
					'routes' => function($q) {
						return $q->withOnRoads()->orderBy('action_time');
					},
					'companions'
				])
				->first();

		$myCarRoutes = $user->routes;

		$myRoutes = $user->companions()
				->withOnRoads()
				->orderBy('action_time')
				->get();

		return View::make('me.index', [
			'myCarRoutes' => $myCarRoutes,
			'myRoutes' => $myRoutes
		]);
	}

	public function settings()
	{
		$user = User::where('id', Sentry::getUser()->id)->with(['information', 'routeSettings'])->first();

		return View::make('me.settings', [
			'user' => $user
		]);
	}

	public function updateSettings(UpdateSettings $validate)
	{
		$user = User::where('id', Sentry::getUser()->id)->with(['information', 'routeSettings'])->first();

		$user->name = Input::get('name');

		if(Input::get('password'))
		{
			$user->password = Input::get('password');
		}

		$user->save();

		$user->information->phone = Input::get('phone');

		$user->information->save();

		$user->routeSettings->show_phone = Input::get('show_phone') == "on"? 1:0;

		$user->routeSettings->mail_when_route_added = Input::get('mail_when_route_added') == "on"? 1:0;

		$user->routeSettings->save();

		return View::make('me.settings', [
			'user' => $user
		])->withErrors(['Başarılı bir şekilde kaydedildi!']);
	}
} 