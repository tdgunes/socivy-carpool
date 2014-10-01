<?php

Route::group([
	'prefix' => 'api/v1',
	'namespace' => 'API\\V1'
], function() {
	Route::post('authenticate', [
		'as' => 'api.v1.authenticate.index',
		'uses' => 'Authentication@index'
	]);
});
 