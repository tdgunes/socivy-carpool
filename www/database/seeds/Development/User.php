<?php namespace Seeder\Development;

use App\UserInformation;
use Cartalyst\Sentry\Facades\Laravel\Sentry;
use Illuminate\Database\Seeder;

class User extends Seeder {

	public $users = [
		[
			'name' => 'Ömer Kala',
			'email' => 'kalaomer@hotmail.com',
			'password' => 'satellite',
			'phone' => '555 603 84 26'
		]
	];

	public function run()
	{
		foreach ($this->users as $userData)
		{
			$user = Sentry::createUser([
				'name' => $userData['name'],
				'email' => $userData['email'],
				'password' => $userData['password'],
				'activated' => true
			]);

			$userInformation = new UserInformation([
				'phone' => $userData['phone']
			]);

			$user->information()->save($userInformation);
		}

	}
} 