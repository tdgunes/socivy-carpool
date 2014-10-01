<?php namespace App\Http\Controllers;

use App\Http\Requests\User\ShowRequest;
use App\User;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\View;
use Cartalyst\Sentry\Facades\Laravel\Sentry;

class UserController extends Controller {

	public function show(ShowRequest $request, $id)
	{
		$user = User::where('id', $id)->first();

		return View::make('user.show', [
			'user' => $user
		]);
	}

}
