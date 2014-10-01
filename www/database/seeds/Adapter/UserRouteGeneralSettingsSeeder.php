<?php  namespace Seeder\Adapter;

use App\User;
use Illuminate\Database\Seeder;
use App\UserRouteGeneralSetting;

class UserRouteGeneralSettingsSeeder extends Seeder {

	public $settingTemplate = [
		'show_phone' => 1,
		'mail_when_route_added' => 0
	];

	public function run()
	{
		$users = User::all();

		foreach($users as $user)
		{
			$settingInfo = $this->settingTemplate;

			$settingInfo['user_id'] = $user['id'];

			$setting = new UserRouteGeneralSetting($settingInfo);

			$setting->save();
		}
	}
} 