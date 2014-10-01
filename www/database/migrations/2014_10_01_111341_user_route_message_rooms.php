<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\Schema;

class UserRouteMessageRooms extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('user_route_message_rooms', function (Blueprint $table)
		{
			$table->increments('id');
			$table->timestamps();
			$table->softDeletes();

			$table->unsignedInteger('creator_id');
			$table->unsignedInteger('route_id');

			$table->foreign('creator_id')->references('id')->on('users')
				->onDelete('cascade')
				->onUpdate('cascade');

			$table->foreign('route_id')->references('id')->on('user_routes')
				->onDelete('cascade')
				->onUpdate('cascade');
		});
	}

	/**
	 * Reverse the migrations.
	 *
	 * @return void
	 */
	public function down()
	{
		Schema::drop('user_route_message_rooms');
	}

}
