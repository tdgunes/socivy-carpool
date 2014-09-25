<?php namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class RouteRequest extends FormRequest {

	/**
	 * Get the validation rules that apply to the request.
	 *
	 * @return array
	 */
	public function rules()
	{
		return [
			'available_seat' => 'required|between:1,50',
			'plan' => 'required|in:toSchool,fromSchool',
			'date' => 'required', //|date_format:YY/MM/DD hh:mm|after:' . date('YY/MM/DD hh:mm'),
			'points.0.lat' => 'required',
			'points.0.lng' => 'required',
			'points.0.name' => 'required'
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
