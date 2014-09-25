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
			'action_day' => 'required|between:0,10',
			'action_hour' => 'required|date_format:"H"',
			'action_minute' => 'required|date_format:"i"',
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
