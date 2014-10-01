<?php namespace App\Http\Controllers\Route\MessageRoom;

use App\Http\Requests\Route\MessageRoom\StoreRequest;
use App\User;
use App\UserRouteMessageRoom;
use Cartalyst\Sentry\Facades\Laravel\Sentry;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Redirect;
use Illuminate\Support\Facades\View;
use App\Http\Requests\Route\MessageRoom\IndexRequest;

class MessageRoomController extends Controller {

	public function index(IndexRequest $request, $routeId)
	{
		$rooms = UserRouteMessageRoom::where('route_id', $routeId)->with('creator', 'route')->get();

		return View::make('route.message-room.index', [
			'rooms' => $rooms
		]);
	}

	public function show($routeId, $id)
	{
		$room = UserRouteMessageRoom::where('id', $id)->with('messages')->first();

		return View::make('route.message-room.show', [
			'room' => $room
		]);
	}

	public function store(StoreRequest $request, $routeId)
	{
		$user = User::where('id', Sentry::getUser()->id)->with('routes.messageRooms')->first();

		$messageRoom = new UserRouteMessageRoom([
			'route_id' => $routeId,
			'creator_id' => $user->id
		]);

		$messageRoom->save();

		return Redirect::route('route.message-room.show', [$routeId, $messageRoom->id]);
	}

} 