<?php namespace App\Http\Controllers;

use App\Http\Requests\RouteRequest;
use App\UserRoute;
use App\UserRoutePlace;
use Carbon\Carbon;
use Illuminate\Support\Facades\Redirect;
use Cartalyst\Sentry\Facades\Laravel\Sentry;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\View;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Mail;

class RouteController extends Controller {

	/**
	 * Display a listing of the resource.
	 *
	 * @return Response
	 */
	public function index()
	{
		$routes = UserRoute::withOnRoads()
			->with([
				'user',
				'places'
			])
			->orderBy('action_time')
			->get();

		return View::make('route.index', [
			'routes' => $routes
		]);
	}

	/**
	 * Show the form for creating a new resource.
	 *
	 * @return Response
	 */
	public function create()
	{
		return View::make('route.create');
	}

	public function store(RouteRequest $request)
	{
		$actionTime = Carbon::today()
							->addMinutes(Input::get('action_minute'))
							->addHours(Input::get('action_hour'))
							->modify('+' . Input::get('action_day') . ' day');

		$route = new UserRoute([
			'description' => Input::get('description'),
			'available_seat' => Input::get('available_seat'),
			'plan' => Input::get('plan'),
			'user_id' => Sentry::getUser()->id,
			'action_time' => $actionTime
		]);

		$route->save();

		foreach(Input::get('points') as $point)
		{
			$routePlace = new UserRoutePlace([
				'name' => $point['name'],
				'longitude' => $point['lng'],
				'latitude' => $point['lat'],
				'route_id' => $route->id
			]);

			$routePlace->save();
		}

		return Redirect::route('route.show', [$route->id]);
	}

	/**
	 * Display the specified resource.
	 *
	 * @param  int $id
	 * @return Response
	 */
	public function show($id)
	{
		$route = UserRoute::where('id', $id)->with('places', 'user.information', 'companions')->first();

		return View::make('route.show', [
			'route' => $route
		]);
	}

	/**
	 * Show the form for editing the specified resource.
	 *
	 * @param  int $id
	 * @return Response
	 */
	public function edit($id)
	{
		//
	}

	/**
	 * Update the specified resource in storage.
	 *
	 * @param  int $id
	 * @return Response
	 */
	public function update($id)
	{
		//
	}

	/**
	 * Remove the specified resource from storage.
	 *
	 * @param  int $id
	 * @return Response
	 */
	public function destroy($id)
	{
		$route = UserRoute::where('id', $id)->first();

		if($route->user_id == Sentry::getUser()->id)
		{
			$companions = $route->companions()->get();

			foreach ($companions as $companion)
			{
				$templateData = [
					'userName' => $companion->name,
					'routeOwnerName' => $route->user()->get()->name,
					'routePlan' => $route->plan,
					'routeActionTime' => $route->action_time,
					'routePlaces' => $route->places()->get()->toArray()
				];

				Mail::send('emails.route.delete', $templateData, function($message) use ($companion) {
					$message->to($companion->email, $companion->name)->subject('Socivy Rota Silindi');
				});

			}

			$route->delete();
		}

		return Redirect::route('route.index');
	}

	public function request($id)
	{
		$route = UserRoute::where('id', $id)->first();

		if($route->canRequest)
		{
			Sentry::getUser()->companions()->attach($id);

			$routeOwner = $route->user()->first();

			$templateData = [
				'userName' => $routeOwner->name,
				'routeLink' => route('route.show', [$route->id]),
				'companionName' => Sentry::getUser()->name
			];

			Mail::send('emails.route.join', $templateData, function($message) use ($routeOwner) {
				$message->to($routeOwner->email, $routeOwner->name)->subject('Socivy Rotaya Yolcu Katılımı');
			});
		}

		return Redirect::route('route.show', [$id]);
	}

	public function cancel($id)
	{
		$route = UserRoute::where('id', $id)->first();

		if($route->canCancel)
		{
			Sentry::getUser()->companions()->detach($id);

			$routeOwner = $route->user()->first();

			$templateData = [
				'userName' => $routeOwner->name,
				'routeLink' => route('route.show', [$route->id]),
				'companionName' => $routeOwner->name
			];

			Mail::send('emails.route.cancel', $templateData, function($message) use ($routeOwner) {
				$message->to($routeOwner->email, $routeOwner->name)->subject('Socivy Rota Yolcu İptali');
			});
		}

		return Redirect::route('route.show', [$id]);
	}

}
