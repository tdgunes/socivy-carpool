<?php namespace App\Http\Requests\Route\MessageRoom;

use App\User;
use App\UserRoute;
use Cartalyst\Sentry\Facades\Laravel\Sentry;
use Illuminate\Foundation\Http\FormRequest;

class StoreRequest extends FormRequest {

	/**
	 * Get the validation rules that apply to the request.
	 *
	 * @return array
	 */
	public function rules()
	{
		return [
			//
		];
	}

	/**
	 * Determine if the user is authorized to make this request.
	 *
	 * @return bool
	 */
	public function authorize()
	{
		$route = UserRoute::where('id', $this->route->getParameter('route'))->first();

		if(
			// If user can create one
			$route->canCreateMessageRoom
		)
		{
			return true;
		}

		return false;
	}

}
