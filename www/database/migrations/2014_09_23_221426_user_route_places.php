<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\Schema;

class UserRoutePlaces extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('user_route_places', function(Blueprint $table) {
			$table->increments('id');
			$table->timestamps();
			$table->softDeletes();

			$table->unsignedInteger('route_id');
			$table->unsignedInteger('place_id');

			$table->foreign('place_id')->references('id')->on('places');
			$table->foreign('route_id')->references('id')->on('user_routes');
		});
	}

	/**
	 * Reverse the migrations.
	 *
	 * @return void
	 */
	public function down()
	{
		Schema::drop('user_route_places');
	}

}