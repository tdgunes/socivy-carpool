<?php namespace App\Http\Requests\User;

use App\User;
use Cartalyst\Sentry\Facades\Laravel\Sentry;
use Illuminate\Foundation\Http\FormRequest;

class ShowRequest extends FormRequest {

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
		return $this->route->parameter('user') != Sentry::getUser()->id;
	}

	public function forbiddenResponse()
	{
		return $this->redirector->route('me.index');
	}

}
