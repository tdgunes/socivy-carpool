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
			$table->string('name');

			$table->float('latitude',9, 7);
			$table->float('longitude', 10, 7);

			$table->foreign('route_id')->references('id')->on('user_routes')
				->onDelete('cascade')
				->onUpdate('cascade');
		});

		DB::statement("ALTER TABLE user_route_places ADD point POINT;");
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