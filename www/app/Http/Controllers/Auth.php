<?php  namespace App\Http\Controllers;

use App\Http\Requests\Register;
use Cartalyst\Sentry\Facades\Laravel\Sentry;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Redirect;
use Illuminate\Support\Facades\View;

class Auth  extends Controller {

	public function login()
	{
		return View::make('auth.login');
	}

	public function logout()
	{
		Sentry::logout();
		return Redirect::route('auth.login');
	}

	public function authentication()
	{
		// TODO: Buraya gerekli senarylara göre yönlendirmeler eklenecek!
		$user = Sentry::authenticate([
			'email' => Input::get('email'),
			'password' => Input::get('password')
		]);

		return Redirect::route('home');
	}

	public function register()
	{
		return View::make('auth.register');
	}

	public function registerPost(Register $register)
	{
		return Redirect::route('home');
	}

	public function activation($userID, $activationCode)
	{
		$user = Sentry::findUserById($userID);

		if($user->attemptActivation($activationCode))
		{
			return Redirect::route('auth.login')->withErrors(['Aktivasyon Başarılı!']);
		}
		else {
			return Redirect::route('auth.login')->withErrors(['Yanlış Aktivasyon Kodu!']);;
		}
	}

} 