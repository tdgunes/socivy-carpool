<?php namespace App\Http\Requests\Me;

use Illuminate\Foundation\Http\FormRequest;

class UpdateSettings extends FormRequest {

	/**
	 * Get the validation rules that apply to the request.
	 *
	 * @return array
	 */
	public function rules()
	{
		return [
			'name' => 'required|min:4',
			'password' => 'min:8',
			'phone' => 'required|regex:"^\+?9?0?\s?[0-9]{3}\s?[0-9]{3}\s?[0-9]{2}\s?[0-9]{2}\s?$"'
		];
	}

	/**
	 * Determine if the user is authorized to make this request.
	 *
	 * @return bool
	 */
	public function authorize()
	{
		return true;
	}

}
