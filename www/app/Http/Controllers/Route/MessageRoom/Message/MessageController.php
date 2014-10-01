<?php namespace App\Http\Controllers\Route\MessageRoom\Message;

use App\Http\Requests\Route\MessageRoom\IndexRequest;
use App\Http\Requests\Route\MessageRoom\Message\StoreRequest;
use App\UserRouteMessage;
use App\UserRouteMessageRoom;
use Cartalyst\Sentry\Facades\Laravel\Sentry;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Redirect;

class MessageController extends Controller {

	public function create()
	{

	}


	public function store(StoreRequest $request, $routeId, $roomId)
	{
		$message = new UserRouteMessage([
			'room_id' => $roomId,
			'message' => $request->get('message'),
			'user_id' => Sentry::getUser()->id
		]);

		$message->save();

		return Redirect::route('route.message-room.show', [$routeId, $roomId]);
	}

	/**
	 * Display the specified resource.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function show($id)
	{
		//
	}

	/**
	 * Show the form for editing the specified resource.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function edit($id)
	{
		//
	}

	/**
	 * Update the specified resource in storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function update($id)
	{
		//
	}

	/**
	 * Remove the specified resource from storage.
	 *
	 * @param  int  $id
	 * @return Response
	 */
	public function destroy($id)
	{
		//
	}

}
