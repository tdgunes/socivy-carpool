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
		[
			'name' => 'Ataşehir Migros',
			'latitude' => '40.992435',
			'longitude' => '29.126969'
		],
		[
			'name' => 'Kadiköy',
			'latitude' => '40.991480',
			'longitude' => '29.023352'
		],
		[
			'name' => 'Bostancı',
			'latitude' => '40.955903',
			'longitude' => '29.099683'
		],
		[
			'name' => 'Taşdelen',
			'latitude' => '41.024803',
			'longitude' => '29.225505'
		],
	];

	public function run()
	{
		$this->cleanOld();

		foreach ($this->places as $placeData)
		{
			$place = new Place($placeData);
			$place->save();
		}
	}

	public function cleanOld()
	{
		foreach ($this->places as $placeData)
		{
			Place::where('latitude', $placeData['latitude'])
				->where('longitude', $placeData['longitude'])
				->withTrashed()
				->forceDelete();
		}
	}
} 