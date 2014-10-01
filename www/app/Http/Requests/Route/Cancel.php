<?php namespace App\Http\Requests\Route;

use App\UserRoute;
use Illuminate\Foundation\Http\FormRequest;

class Cancel extends FormRequest {

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
		$route = UserRoute::where('id', $this->route->parameter('id'))->first();

		if($route->canCancel)
		{
			return true;
		}

		return false;
	}

	public function forbiddenResponse()
	{
		return $this->redirector->route('route.show', [$this->route->parameter('id')])
			->withInput($this->except($this->dontFlash))
			->withErrors([
				'Bu işlemi yapamazsınız!'
			]);;
	}

}
