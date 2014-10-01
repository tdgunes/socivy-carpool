<?php
/**
 * Son derece kirli bir kod olup buraya uğramadan gitmeni öneririm!
 */

$z = $_GET['z'];
$x = $_GET['x'];
$y = $_GET['y'];

$s = $_GET['s'];

$ch = curl_init();

// set url
curl_setopt($ch, CURLOPT_URL, "http://{$s}.tile.osm.org/{$z}/{$x}/{$y}.png");

//return the transfer as a string
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

curl_setopt($ch, CURLOPT_VERBOSE, 1);
curl_setopt($ch, CURLOPT_HEADER, 1);

$response = curl_exec($ch);

$header_size = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
$rawHeader = substr($response, 0, $header_size);
$body = substr($response, $header_size);

$header = end(array_filter(explode("\r\n\r\n", $rawHeader)));

$headerLines = explode("\r\n", $header);
foreach ($headerLines as $header) {
	if (stripos($header, "Content-Length") === false && stripos($header, "Transfer-Encoding") === false) {
		header($header);
	}
}

echo $body;