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
			'name' => 'Kadıköy Haldun Taner',
			'latitude' => '40.991480',
			'longitude' => '29.023352'
		],
		[
			'name' => 'Bostancı Lunapark',
			'latitude' => '40.955903',
			'longitude' => '29.099683'
		],
		[
			'name' => 'Taşdelen BP',
			'latitude' => '41.024803',
			'longitude' => '29.225505'
		],
		[
			'name' => 'Libadiye Kavşak',
			'latitude' => '41.020141',
			'longitude' => '29.075049'
		],
		[
			'name' => 'Madenler, Çamlık, İETT Durağı',
			'latitude' => '41.013956',
			'longitude' => '29.189295'
		],
        [
            'name' => 'Emlak Konutları',
            'latitude' => '41.042106',
            'longitude' => '29.270861'
        ],
        [
            'name' => 'Nişantepe Durağı',
            'latitude' => '41.044194',
            'longitude' => '29.256919'
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