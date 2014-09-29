<?php  namespace App\Http\Controllers;

use App\Http\Requests\AuthenticationRequest;
use App\Http\Requests\Register;
use Cartalyst\Sentry\Facades\Laravel\Sentry;
use Cartalyst\Sentry\Users\UserNotActivatedException;
use Cartalyst\Sentry\Users\WrongPasswordException;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Redirect;
use Illuminate\Support\Facades\Session;
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

	public function authentication(AuthenticationRequest $validation)
	{
		try {
			$user = Sentry::authenticate([
				'email' => Input::get('email'),
				'password' => Input::get('password')
			]);
		}
		catch(UserNotActivatedException $e) {
			return Redirect::route('auth.login')->withErrors([
				'Hesabınız onaylanmamış, lütfen posta kutunuzu kontrol edin.'
			]);
		}
		catch(\Exception $e) {
			return Redirect::route('auth.login')->withErrors([
				'Hatalı giriş.'
			]);
		}

		if(Input::get('original-url') != null)
		{
			return Redirect::to(Input::get('original-url'));
		}
		else {
			return Redirect::route('me.index');
		}
	}

	public function register()
	{
		return View::make('auth.register');
	}

	public function registerPost(Register $register)
	{
		return Redirect::route('auth.login')->withErrors(['Aktivasyon için mail adresinizi kontrol edin!']);
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