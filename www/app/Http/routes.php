<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the Closure to execute when that URI is requested.
|
*/

require_once 'Controllers/API/routes.php';

// Add Route routes.
require_once 'Controllers/Route/routes.php';

Route::group([
	'before' => 'auth'
], function() {

	Route::get('logout', [
		'uses' => 'Auth@logout',
		'as' => 'auth.logout'
	]);

	Route::get('me', [
		'uses' => 'MeController@index',
		'as' => 'me.index'
	]);

	Route::get('me/settings', [
		'uses' => 'MeController@settings',
		'as' => 'me.settings'
	]);

	Route::post('me/settings', [
		'uses' => 'MeController@updateSettings',
		'as' => 'me.settings'
	]);

	Route::resource('place', 'PlaceController');

	Route::resource('user', 'UserController');

	Route::resource('message', 'MessageController');

});

Route::group([
	'before' => 'guest'
], function() {

	Route::get('/', [
		'uses' => 'HomeController@index',
		'as' => 'home'
	]);

	Route::get('login', [
		'uses' => 'Auth@login',
		'as' => 'auth.login',
	]);

	Route::post('authentication', [
		'uses' => 'Auth@authentication',
		'as' => 'auth.authentication'
	]);

	Route::get('activation/{userID}/{activationCode}', [
		'uses' => 'Auth@activation',
		'as' => 'auth.activation'
	]);

	Route::get('register', [
		'uses' => 'Auth@register',
		'as' => 'auth.register'
	]);

	Route::post('register', [
		'uses' => 'Auth@registerPost'
	]);

});