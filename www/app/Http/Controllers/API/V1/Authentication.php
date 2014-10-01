<?php namespace App\Http\Controllers\API\V1;

use App\Http\Requests\API\V1\Authentication\IndexRequest;
use Illuminate\Routing\Controller;
use Symfony\Component\HttpFoundation\JsonResponse;

class Authentication extends Controller {

	public function index(IndexRequest $request)
	{
		$out = [
			'info' => [
				'status' => 'success'
			],
			'result' => [
				'access_token' => rand(1000, 20000)
			]
		];

		return new JsonResponse($out, 200);
	}
}
