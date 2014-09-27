<?php  namespace Seeder\Main;

use App\Place;
use Illuminate\Database\Seeder;

class PlaceSeeder extends Seeder {

	public $places = [
		[
			'name' => 'Özyeğin Üniversitesi',
			'latitude' => '41.029547',
			'longitude' => '29.260404'
		],
		[
			'name' => 'Altunizade Cookshop',
			'latitude' => '41.021954',
			'longitude' => '29.044544'
		],
		[
			'name' => 'Merkez Ataşehir McDonalds',
			'latitude' => '40.99269',
			'longitude' => '29.127781'
		],
		[
			'name' => 'Taşdelen Kardiyum',
			'latitude' => '41.031689',
			'longitude' => '29.227221'
		],
	];

	public function run()
	{
		foreach ($this->places as $placeData)
		{
			$place = new Place($placeData);
			$place->save();
		}
	}
} 