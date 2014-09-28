<?php namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use App\UserInformation;
use Cartalyst\Sentry\Facades\Laravel\Sentry;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Redirect;

class Register extends FormRequest {

	/**
	 * Get the validation rules that apply to the request.
	 *
	 * @return array
	 */
	public function rules()
	{
		if(\App::environment() == "development")
		{
			$emailRegex = 'regex:/^[a-z0-9\.]+\@(ozu\.edu\.tr|ozyegin\.edu\.tr|hotmail\.com|gmail\.com)$/';
		}
		else {
			$emailRegex = 'regex:/^[a-z0-9\.]+\@(ozu\.edu\.tr|ozyegin\.edu\.tr)$/';
		}

		return [
			'name' => 'required',
			'email' => ['required','email', 'unique:users,email', $emailRegex],
			'password' => 'required|min:6',
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
		try {
			$user = Sentry::createUser([
				'email' => $this->input('email'),
				'password' => $this->input('password'),
				'name' => $this->input('name')
			]);

			$information = new UserInformation([
				'phone' => $this->input('phone')
			]);

			$user->information()->save($information);

			$templateData = [
				'activationLink' => route('auth.activation', [$user->id, $user->getActivationCode()]),
				'name' => $user->name
			];

			Mail::send('emails.auth.activation', $templateData, function($message) use ($user) {
				$message->to($user->email, $user->name)->subject('Socivy Carpool Activation Mail');
			});

			return true;
		}
		catch(\Exception $e)
		{
			throw $e;
			// TODO: Burayı hallet, sadece normal uyarı çıkar!
			return false;
		}
	}

	public function forbiddenResponse()
	{
		return Redirect::route('aut.register')->withErrors(['Hatalı deneme!']);
	}
}
