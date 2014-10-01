<?php

Route::group([
	'before' => 'auth',
	'namespace' => 'Route'
], function() {

	Route::resource('route', 'RouteController');

	Route::get('route/{id}/request', [
		'uses' => 'RouteController@request',
		'as' => 'route.request'
	]);

	Route::get('route/{id}/cancel', [
		'uses' => 'RouteController@cancel',
		'as' => 'route.cancel'
	]);

	Route::resource('route.message-room', 'MessageRoom\\MessageRoomController');

	Route::resource('route.message-room.message', 'MessageRoom\\Message\\MessageController');

});