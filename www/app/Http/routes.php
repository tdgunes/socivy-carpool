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

Route::get('/', [
	'uses' => 'HomeController@index',
	'as' => 'home'
]);

Route::group([
	'before' => 'auth'
], function() {

	Route::get('logout', [
		'uses' => 'Auth@logout',
		'as' => 'auth.logout'
	]);

	Route::resource('route', 'RouteController');

	Route::resource('place', 'PlaceController');

});

Route::group([
	'before' => 'guest'
], function() {

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