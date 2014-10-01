<?php namespace App\Http\Requests\API\V1\Authentication;

use Illuminate\Foundation\Http\FormRequest;
use Cartalyst\Sentry\Facades\Laravel\Sentry;
use Illuminate\Http\JsonResponse;

class IndexRequest extends FormRequest {

	/**
	 * Get the validation rules that apply to the request.
	 *
	 * @return array
	 */
	public function rules()
	{
		return [
			'email' => 'required|email',
			'password' => 'required|min:6',
			'publicKey' => 'required|in:1234,5678'
		];
	}

	/**
	 * Determine if the user is authorized to make this request.
	 *
	 * @return bool
	 */
	public function authorize()
	{
		try {
			Sentry::authenticate([
				'email' => $this->get('email'),
				'password' => $this->get('password')
			]);

			return true;
		}
		catch(\Exception $e)
		{
			return false;
		}

	}

	public function forbiddenResponse()
	{
		$out = [
			'info' =>  [
				'status' => 'fail'
			]
		];
		return new JsonResponse($out, 422);
	}

}
