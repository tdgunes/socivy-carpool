<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\Schema;

class UserRouteGeneralSettings extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('user_route_general_settings', function (Blueprint $table) {
			$table->increments('id');
			$table->timestamps();
			$table->softDeletes();

			$table->unsignedInteger('user_id');
			$table->integer('show_phone');
			$table->integer('mail_when_route_added');

			$table->foreign('user_id')->references('id')->on('users')
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
		Schema::drop('user_route_general_settings');
	}

}
