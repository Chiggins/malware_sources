<?php

//error_reporting(0);


// Global DI call method function
function cdim($className, $methodName, $arguments = NULL){
	global $di;
	return $di->callMethod($className, $methodName, $arguments);
}


function logError($msg) {
	global $config;
	if (isset($config['realpath'])) {
		// если в конфиге есть
		$logFile = $config['realpath'].'/logs/log.txt'; 
	} else {
		// если в корне есть
		if (file_exists('./logs') && is_dir('./logs')) {
			$logFile = './logs/log.txt'; 
		} else {
			// если на уровень выше есть
			if (file_exists('../logs') && is_dir('../logs')) { 
				$logFile = '../logs/log.txt'; 
			}	
		}
		
	}
	file_put_contents($logFile, date("Y/m/d H:i.s",time())."\n-------------------\n".$msg."\n\n",FILE_APPEND);
}

// дебаг
function debug($arr) {
	$bColor  = isset($arr['Error']) ? 'red' : 'gray';
	$bSize  = isset($arr['Error']) ? 3 : 1;
	echo "<pre style='border:".$bSize."px dashed ".$bColor.";border-radius:10px;padding:10px;text-transform:none;'>";
	ob_start();
		var_export($arr);
	$out = ob_get_contents();
	ob_end_flush();
	echo "</pre>\n\n";
	logError($out);
}

// put smth to log file
function cLog($arg) {
	global $config;
	if (is_array($arg) || is_object($arg))	{
		ob_start();
		print_r($arg);
		$out = ob_get_contents();
		ob_end_clean();
	} else {
		ob_start();
		echo $arg;
		$out = ob_get_contents();
		ob_end_clean();
	}
	
	file_put_contents($config['options']['realpath'].'/logs/log.txt', $out);
	
}

// '2301' to 'XP SP3 x86 Admin'
function osToString($os)
{
	// array('os'=>2,'ossp'=>3,'arch'=>'x86','userrights'=>'a');
	
	switch ($os[0]) {
		case '0':
			$return['os'] = 'Unknown';
			break;
		case '1':
			$return['os'] = '2000';
			break;
		case '2':
			$return['os'] = 'XP';
			break;
		case '3':
			$return['os'] = '2003';
			break;
		case '4':
			$return['os'] = 'Vista';
			break;
		case '5':
			$return['os'] = '2008';
			break;
		case '6':
			$return['os'] = 'Seven';
			break;
		case '7':
			$return['os'] = '2008r2';
			break;
	}
			
			
	$return['ossp'] = $os[1];

	if ($os[2] == "0") $return['arch'] = " x86"; else $return['arch'] = " x64";
	if ($os[3] == "0") $return['userrights'] = "U"; else $return['userrights'] = "A";
	
	return $return;
}

function stringToOs($os)
{
	// array('os'=>2,'ossp'=>3,'arch'=>'x86','userrights'=>'a');
	$return = '';
	switch ($os[0]) {
		case 'Unknown':
			$return .= '0';
			break;
		case '2000':
			$return .= '1';
			break;
		case 'XP':
			$return .= '2';
			break;
		case '2003':
			$return .= '3';
			break;
		case 'Vista':
			$return .= '4';
			break;
		case '2008':
			$return .= '5';
			break;
		case 'Seven':
			$return .= '6';
			break;
		case '2008r2':
			$return .= '7';
			break;
	}
			
			
	$return .= $os[1];

	if ($os[2] == "x86") $return .= "0"; else $return .= "1";
	if ($os[3] == "U") $return .= "0"; else $return .= "1";
	
	return $return;
}

// время в unix формате в 5 дней 6 часов 17 минут ...
function uptimeToString($time) {
	$d = (int) ($time / 3600 / 24);
	$h = (int) (($time - $d*3600*24) / 3600);
	$m = (int) (($time - $d*3600*24 - $h*3600) / 60);
	$s = (int) ($time - $d*3600*24 - $h*3600 - $m*60);
	return (($d)?(($d<10)?("0".$d):$d):"00")." d ".(($h)?(($h<10)?("0".$h):$h):"00")." h ".(($m)?(($m<10)?("0".$m):$m):"00")." m ".(($s)?(($s<10)?("0".$s):$s):"00")." s";
}


function formatBytes($a_bytes) {
	$units = array('B','KB','MB','GB','TB','PB','EB','ZB','YB');
	return @round(
		$a_bytes / pow(1024, ($i = floor(log($a_bytes, 1024)))), 10
	).' '.$units[$i];
}


function getIp() {
	
    global $REMOTE_ADDR;
    global $HTTP_X_FORWARDED_FOR, $HTTP_X_FORWARDED, $HTTP_FORWARDED_FOR, $HTTP_FORWARDED;
    global $HTTP_VIA, $HTTP_X_COMING_FROM, $HTTP_COMING_FROM;
    global $HTTP_SERVER_VARS, $HTTP_ENV_VARS;
 
    // Get some server/environment variables values
    if (empty($REMOTE_ADDR)) {
        if (!empty($_SERVER) && isset($_SERVER['REMOTE_ADDR'])) {
            $REMOTE_ADDR = $_SERVER['REMOTE_ADDR'];
        }
        else if (!empty($_ENV) && isset($_ENV['REMOTE_ADDR'])) {
            $REMOTE_ADDR = $_ENV['REMOTE_ADDR'];
        }
        else if (!empty($HTTP_SERVER_VARS) && isset($HTTP_SERVER_VARS['REMOTE_ADDR'])) {
            $REMOTE_ADDR = $HTTP_SERVER_VARS['REMOTE_ADDR'];
        }
        else if (!empty($HTTP_ENV_VARS) && isset($HTTP_ENV_VARS['REMOTE_ADDR'])) {
            $REMOTE_ADDR = $HTTP_ENV_VARS['REMOTE_ADDR'];
        }
        else if (@getenv('REMOTE_ADDR')) {
            $REMOTE_ADDR = getenv('REMOTE_ADDR');
        }
    } // end if

    //if (isset($REMOTE_ADDR) && !empty($REMOTE_ADDR)) { return $REMOTE_ADDR; } else { return $_SERVER['REMOTE_ADDR']; }

 
    if (empty($HTTP_X_FORWARDED_FOR)) {
        if (!empty($_SERVER) && isset($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            $HTTP_X_FORWARDED_FOR = $_SERVER['HTTP_X_FORWARDED_FOR'];
        }
        else if (!empty($_ENV) && isset($_ENV['HTTP_X_FORWARDED_FOR'])) {
            $HTTP_X_FORWARDED_FOR = $_ENV['HTTP_X_FORWARDED_FOR'];
        }
        else if (!empty($HTTP_SERVER_VARS) && isset($HTTP_SERVER_VARS['HTTP_X_FORWARDED_FOR'])) {
            $HTTP_X_FORWARDED_FOR = $HTTP_SERVER_VARS['HTTP_X_FORWARDED_FOR'];
        }
        else if (!empty($HTTP_ENV_VARS) && isset($HTTP_ENV_VARS['HTTP_X_FORWARDED_FOR'])) {
            $HTTP_X_FORWARDED_FOR = $HTTP_ENV_VARS['HTTP_X_FORWARDED_FOR'];
        }
        else if (@getenv('HTTP_X_FORWARDED_FOR')) {
            $HTTP_X_FORWARDED_FOR = getenv('HTTP_X_FORWARDED_FOR');
        }
    } // end if
 
    if (empty($HTTP_X_FORWARDED)) {
        if (!empty($_SERVER) && isset($_SERVER['HTTP_X_FORWARDED'])) {
            $HTTP_X_FORWARDED = $_SERVER['HTTP_X_FORWARDED'];
        }
        else if (!empty($_ENV) && isset($_ENV['HTTP_X_FORWARDED'])) {
            $HTTP_X_FORWARDED = $_ENV['HTTP_X_FORWARDED'];
        }
        else if (!empty($HTTP_SERVER_VARS) && isset($HTTP_SERVER_VARS['HTTP_X_FORWARDED'])) {
            $HTTP_X_FORWARDED = $HTTP_SERVER_VARS['HTTP_X_FORWARDED'];
        }
        else if (!empty($HTTP_ENV_VARS) && isset($HTTP_ENV_VARS['HTTP_X_FORWARDED'])) {
            $HTTP_X_FORWARDED = $HTTP_ENV_VARS['HTTP_X_FORWARDED'];
        }
        else if (@getenv('HTTP_X_FORWARDED')) {
            $HTTP_X_FORWARDED = getenv('HTTP_X_FORWARDED');
        }
    } // end if
 
    if (empty($HTTP_FORWARDED_FOR)) {
        if (!empty($_SERVER) && isset($_SERVER['HTTP_FORWARDED_FOR'])) {
            $HTTP_FORWARDED_FOR = $_SERVER['HTTP_FORWARDED_FOR'];
        }
        else if (!empty($_ENV) && isset($_ENV['HTTP_FORWARDED_FOR'])) {
            $HTTP_FORWARDED_FOR = $_ENV['HTTP_FORWARDED_FOR'];
        }
        else if (!empty($HTTP_SERVER_VARS) && isset($HTTP_SERVER_VARS['HTTP_FORWARDED_FOR'])) {
            $HTTP_FORWARDED_FOR = $HTTP_SERVER_VARS['HTTP_FORWARDED_FOR'];
        }
        else if (!empty($HTTP_ENV_VARS) && isset($HTTP_ENV_VARS['HTTP_FORWARDED_FOR'])) {
            $HTTP_FORWARDED_FOR = $HTTP_ENV_VARS['HTTP_FORWARDED_FOR'];
        }
        else if (@getenv('HTTP_FORWARDED_FOR')) {
            $HTTP_FORWARDED_FOR = getenv('HTTP_FORWARDED_FOR');
        }
    } // end if
 
    if (empty($HTTP_FORWARDED)) {
        if (!empty($_SERVER) && isset($_SERVER['HTTP_FORWARDED'])) {
            $HTTP_FORWARDED = $_SERVER['HTTP_FORWARDED'];
        }
        else if (!empty($_ENV) && isset($_ENV['HTTP_FORWARDED'])) {
            $HTTP_FORWARDED = $_ENV['HTTP_FORWARDED'];
        }
        else if (!empty($HTTP_SERVER_VARS) && isset($HTTP_SERVER_VARS['HTTP_FORWARDED'])) {
            $HTTP_FORWARDED = $HTTP_SERVER_VARS['HTTP_FORWARDED'];
        }
        else if (!empty($HTTP_ENV_VARS) && isset($HTTP_ENV_VARS['HTTP_FORWARDED'])) {
            $HTTP_FORWARDED = $HTTP_ENV_VARS['HTTP_FORWARDED'];
        }
        else if (@getenv('HTTP_FORWARDED')) {
            $HTTP_FORWARDED = getenv('HTTP_FORWARDED');
        }
    } // end if
 
    if (empty($HTTP_VIA)) {
        if (!empty($_SERVER) && isset($_SERVER['HTTP_VIA'])) {
            $HTTP_VIA = $_SERVER['HTTP_VIA'];
        }
        else if (!empty($_ENV) && isset($_ENV['HTTP_VIA'])) {
            $HTTP_VIA = $_ENV['HTTP_VIA'];
        }
        else if (!empty($HTTP_SERVER_VARS) && isset($HTTP_SERVER_VARS['HTTP_VIA'])) {
            $HTTP_VIA = $HTTP_SERVER_VARS['HTTP_VIA'];
        }
        else if (!empty($HTTP_ENV_VARS) && isset($HTTP_ENV_VARS['HTTP_VIA'])) {
            $HTTP_VIA = $HTTP_ENV_VARS['HTTP_VIA'];
        }
        else if (@getenv('HTTP_VIA')) {
            $HTTP_VIA = getenv('HTTP_VIA');
        }
    } // end if
 
    if (empty($HTTP_X_COMING_FROM)) {
        if (!empty($_SERVER) && isset($_SERVER['HTTP_X_COMING_FROM'])) {
            $HTTP_X_COMING_FROM = $_SERVER['HTTP_X_COMING_FROM'];
        }
        else if (!empty($_ENV) && isset($_ENV['HTTP_X_COMING_FROM'])) {
            $HTTP_X_COMING_FROM = $_ENV['HTTP_X_COMING_FROM'];
        }
        else if (!empty($HTTP_SERVER_VARS) && isset($HTTP_SERVER_VARS['HTTP_X_COMING_FROM'])) {
            $HTTP_X_COMING_FROM = $HTTP_SERVER_VARS['HTTP_X_COMING_FROM'];
        }
        else if (!empty($HTTP_ENV_VARS) && isset($HTTP_ENV_VARS['HTTP_X_COMING_FROM'])) {
            $HTTP_X_COMING_FROM = $HTTP_ENV_VARS['HTTP_X_COMING_FROM'];
        }
        else if (@getenv('HTTP_X_COMING_FROM')) {
            $HTTP_X_COMING_FROM = getenv('HTTP_X_COMING_FROM');
        }
    } // end if
 
    if (empty($HTTP_COMING_FROM)) {
        if (!empty($_SERVER) && isset($_SERVER['HTTP_COMING_FROM'])) {
            $HTTP_COMING_FROM = $_SERVER['HTTP_COMING_FROM'];
        }
        else if (!empty($_ENV) && isset($_ENV['HTTP_COMING_FROM'])) {
            $HTTP_COMING_FROM = $_ENV['HTTP_COMING_FROM'];
        }
        else if (!empty($HTTP_COMING_FROM) && isset($HTTP_SERVER_VARS['HTTP_COMING_FROM'])) {
            $HTTP_COMING_FROM = $HTTP_SERVER_VARS['HTTP_COMING_FROM'];
        }
        else if (!empty($HTTP_ENV_VARS) && isset($HTTP_ENV_VARS['HTTP_COMING_FROM'])) {
            $HTTP_COMING_FROM = $HTTP_ENV_VARS['HTTP_COMING_FROM'];
        }
        else if (@getenv('HTTP_COMING_FROM')) {
            $HTTP_COMING_FROM = getenv('HTTP_COMING_FROM');
        }
    } // end if
 
    // Gets the default ip sent by the user
    if (!empty($REMOTE_ADDR)) {
        $direct_ip = $REMOTE_ADDR;
    }
 
    // Gets the proxy ip sent by the user
    $proxy_ip = '';
    if (!empty($HTTP_X_FORWARDED_FOR)) {
        $proxy_ip = $HTTP_X_FORWARDED_FOR;
    } else if (!empty($HTTP_X_FORWARDED)) {
        $proxy_ip = $HTTP_X_FORWARDED;
    } else if (!empty($HTTP_FORWARDED_FOR)) {
        $proxy_ip = $HTTP_FORWARDED_FOR;
    } else if (!empty($HTTP_FORWARDED)) {
        $proxy_ip = $HTTP_FORWARDED;
    } else if (!empty($HTTP_VIA)) {
        $proxy_ip = $HTTP_VIA;
    } else if (!empty($HTTP_X_COMING_FROM)) {
        $proxy_ip = $HTTP_X_COMING_FROM;
    } else if (!empty($HTTP_COMING_FROM)) {
        $proxy_ip = $HTTP_COMING_FROM;
    } // end if... else if...
 
    // Returns the true IP if it has been found, else FALSE
    if (empty($proxy_ip)) {
        // True IP without proxy
        return $direct_ip;
    } else {
        return $proxy_ip;
    } // end if... else...
 
} // end of the 'getIp()' function


function getcountry($ip) {
	global $config;
	if (!function_exists('geoip_country_name_by_name')) include_once($config['options']['real_path'].'/gears/geoip/geoip.php');
	$gi = geoip_open($config['options']['real_path']."/gears/geoip/geoip.dat", GEOIP_STANDARD);
	$code = geoip_country_code_by_addr1($gi, $ip);
		
	if(strlen(trim($code)) < 2)	{
		$code = "XX";
	}

	geoip_close($gi);
	return $code;
}

class GeoIP {
    var $flags;
    var $filehandle;
    var $memory_buffer;
    var $databaseType;
    var $databaseSegments;
    var $record_length;
    var $shmid;
    var $GEOIP_COUNTRY_CODE_TO_NUMBER = array(
"" => 0, "AP" => 1, "EU" => 2, "AD" => 3, "AE" => 4, "AF" => 5, 
"AG" => 6, "AI" => 7, "AL" => 8, "AM" => 9, "AN" => 10, "AO" => 11, 
"AQ" => 12, "AR" => 13, "AS" => 14, "AT" => 15, "AU" => 16, "AW" => 17, 
"AZ" => 18, "BA" => 19, "BB" => 20, "BD" => 21, "BE" => 22, "BF" => 23, 
"BG" => 24, "BH" => 25, "BI" => 26, "BJ" => 27, "BM" => 28, "BN" => 29, 
"BO" => 30, "BR" => 31, "BS" => 32, "BT" => 33, "BV" => 34, "BW" => 35, 
"BY" => 36, "BZ" => 37, "CA" => 38, "CC" => 39, "CD" => 40, "CF" => 41, 
"CG" => 42, "CH" => 43, "CI" => 44, "CK" => 45, "CL" => 46, "CM" => 47, 
"CN" => 48, "CO" => 49, "CR" => 50, "CU" => 51, "CV" => 52, "CX" => 53, 
"CY" => 54, "CZ" => 55, "DE" => 56, "DJ" => 57, "DK" => 58, "DM" => 59, 
"DO" => 60, "DZ" => 61, "EC" => 62, "EE" => 63, "EG" => 64, "EH" => 65, 
"ER" => 66, "ES" => 67, "ET" => 68, "FI" => 69, "FJ" => 70, "FK" => 71, 
"FM" => 72, "FO" => 73, "FR" => 74, "FX" => 75, "GA" => 76, "GB" => 77,
"GD" => 78, "GE" => 79, "GF" => 80, "GH" => 81, "GI" => 82, "GL" => 83, 
"GM" => 84, "GN" => 85, "GP" => 86, "GQ" => 87, "GR" => 88, "GS" => 89, 
"GT" => 90, "GU" => 91, "GW" => 92, "GY" => 93, "HK" => 94, "HM" => 95, 
"HN" => 96, "HR" => 97, "HT" => 98, "HU" => 99, "ID" => 100, "IE" => 101, 
"IL" => 102, "IN" => 103, "IO" => 104, "IQ" => 105, "IR" => 106, "IS" => 107, 
"IT" => 108, "JM" => 109, "JO" => 110, "JP" => 111, "KE" => 112, "KG" => 113, 
"KH" => 114, "KI" => 115, "KM" => 116, "KN" => 117, "KP" => 118, "KR" => 119, 
"KW" => 120, "KY" => 121, "KZ" => 122, "LA" => 123, "LB" => 124, "LC" => 125, 
"LI" => 126, "LK" => 127, "LR" => 128, "LS" => 129, "LT" => 130, "LU" => 131, 
"LV" => 132, "LY" => 133, "MA" => 134, "MC" => 135, "MD" => 136, "MG" => 137, 
"MH" => 138, "MK" => 139, "ML" => 140, "MM" => 141, "MN" => 142, "MO" => 143, 
"MP" => 144, "MQ" => 145, "MR" => 146, "MS" => 147, "MT" => 148, "MU" => 149, 
"MV" => 150, "MW" => 151, "MX" => 152, "MY" => 153, "MZ" => 154, "NA" => 155,
"NC" => 156, "NE" => 157, "NF" => 158, "NG" => 159, "NI" => 160, "NL" => 161, 
"NO" => 162, "NP" => 163, "NR" => 164, "NU" => 165, "NZ" => 166, "OM" => 167, 
"PA" => 168, "PE" => 169, "PF" => 170, "PG" => 171, "PH" => 172, "PK" => 173, 
"PL" => 174, "PM" => 175, "PN" => 176, "PR" => 177, "PS" => 178, "PT" => 179, 
"PW" => 180, "PY" => 181, "QA" => 182, "RE" => 183, "RO" => 184, "RU" => 185, 
"RW" => 186, "SA" => 187, "SB" => 188, "SC" => 189, "SD" => 190, "SE" => 191, 
"SG" => 192, "SH" => 193, "SI" => 194, "SJ" => 195, "SK" => 196, "SL" => 197, 
"SM" => 198, "SN" => 199, "SO" => 200, "SR" => 201, "ST" => 202, "SV" => 203, 
"SY" => 204, "SZ" => 205, "TC" => 206, "TD" => 207, "TF" => 208, "TG" => 209, 
"TH" => 210, "TJ" => 211, "TK" => 212, "TM" => 213, "TN" => 214, "TO" => 215, 
"TL" => 216, "TR" => 217, "TT" => 218, "TV" => 219, "TW" => 220, "TZ" => 221, 
"UA" => 222, "UG" => 223, "UM" => 224, "US" => 225, "UY" => 226, "UZ" => 227, 
"VA" => 228, "VC" => 229, "VE" => 230, "VG" => 231, "VI" => 232, "VN" => 233,
"VU" => 234, "WF" => 235, "WS" => 236, "YE" => 237, "YT" => 238, "RS" => 239, 
"ZA" => 240, "ZM" => 241, "ME" => 242, "ZW" => 243, "A1" => 244, "A2" => 245, 
"O1" => 246, "AX" => 247, "GG" => 248, "IM" => 249, "JE" => 250, "BL" => 251,
"MF" => 252
);
    var $GEOIP_COUNTRY_CODES = array(
"", "AP", "EU", "AD", "AE", "AF", "AG", "AI", "AL", "AM", "AN", "AO", "AQ",
"AR", "AS", "AT", "AU", "AW", "AZ", "BA", "BB", "BD", "BE", "BF", "BG", "BH",
"BI", "BJ", "BM", "BN", "BO", "BR", "BS", "BT", "BV", "BW", "BY", "BZ", "CA",
"CC", "CD", "CF", "CG", "CH", "CI", "CK", "CL", "CM", "CN", "CO", "CR", "CU",
"CV", "CX", "CY", "CZ", "DE", "DJ", "DK", "DM", "DO", "DZ", "EC", "EE", "EG",
"EH", "ER", "ES", "ET", "FI", "FJ", "FK", "FM", "FO", "FR", "FX", "GA", "GB",
"GD", "GE", "GF", "GH", "GI", "GL", "GM", "GN", "GP", "GQ", "GR", "GS", "GT",
"GU", "GW", "GY", "HK", "HM", "HN", "HR", "HT", "HU", "ID", "IE", "IL", "IN",
"IO", "IQ", "IR", "IS", "IT", "JM", "JO", "JP", "KE", "KG", "KH", "KI", "KM",
"KN", "KP", "KR", "KW", "KY", "KZ", "LA", "LB", "LC", "LI", "LK", "LR", "LS",
"LT", "LU", "LV", "LY", "MA", "MC", "MD", "MG", "MH", "MK", "ML", "MM", "MN",
"MO", "MP", "MQ", "MR", "MS", "MT", "MU", "MV", "MW", "MX", "MY", "MZ", "NA",
"NC", "NE", "NF", "NG", "NI", "NL", "NO", "NP", "NR", "NU", "NZ", "OM", "PA",
"PE", "PF", "PG", "PH", "PK", "PL", "PM", "PN", "PR", "PS", "PT", "PW", "PY",
"QA", "RE", "RO", "RU", "RW", "SA", "SB", "SC", "SD", "SE", "SG", "SH", "SI",
"SJ", "SK", "SL", "SM", "SN", "SO", "SR", "ST", "SV", "SY", "SZ", "TC", "TD",
"TF", "TG", "TH", "TJ", "TK", "TM", "TN", "TO", "TL", "TR", "TT", "TV", "TW",
"TZ", "UA", "UG", "UM", "US", "UY", "UZ", "VA", "VC", "VE", "VG", "VI", "VN",
"VU", "WF", "WS", "YE", "YT", "RS", "ZA", "ZM", "ME", "ZW", "A1", "A2", "O1",
"AX", "GG", "IM", "JE", "BL", "MF"
);
    var $GEOIP_COUNTRY_CODES3 = array(
"","AP","EU","AND","ARE","AFG","ATG","AIA","ALB","ARM","ANT","AGO","AQ","ARG",
"ASM","AUT","AUS","ABW","AZE","BIH","BRB","BGD","BEL","BFA","BGR","BHR","BDI",
"BEN","BMU","BRN","BOL","BRA","BHS","BTN","BV","BWA","BLR","BLZ","CAN","CC",
"COD","CAF","COG","CHE","CIV","COK","CHL","CMR","CHN","COL","CRI","CUB","CPV",
"CX","CYP","CZE","DEU","DJI","DNK","DMA","DOM","DZA","ECU","EST","EGY","ESH",
"ERI","ESP","ETH","FIN","FJI","FLK","FSM","FRO","FRA","FX","GAB","GBR","GRD",
"GEO","GUF","GHA","GIB","GRL","GMB","GIN","GLP","GNQ","GRC","GS","GTM","GUM",
"GNB","GUY","HKG","HM","HND","HRV","HTI","HUN","IDN","IRL","ISR","IND","IO",
"IRQ","IRN","ISL","ITA","JAM","JOR","JPN","KEN","KGZ","KHM","KIR","COM","KNA",
"PRK","KOR","KWT","CYM","KAZ","LAO","LBN","LCA","LIE","LKA","LBR","LSO","LTU",
"LUX","LVA","LBY","MAR","MCO","MDA","MDG","MHL","MKD","MLI","MMR","MNG","MAC",
"MNP","MTQ","MRT","MSR","MLT","MUS","MDV","MWI","MEX","MYS","MOZ","NAM","NCL",
"NER","NFK","NGA","NIC","NLD","NOR","NPL","NRU","NIU","NZL","OMN","PAN","PER",
"PYF","PNG","PHL","PAK","POL","SPM","PCN","PRI","PSE","PRT","PLW","PRY","QAT",
"REU","ROU","RUS","RWA","SAU","SLB","SYC","SDN","SWE","SGP","SHN","SVN","SJM",
"SVK","SLE","SMR","SEN","SOM","SUR","STP","SLV","SYR","SWZ","TCA","TCD","TF",
"TGO","THA","TJK","TKL","TLS","TKM","TUN","TON","TUR","TTO","TUV","TWN","TZA",
"UKR","UGA","UM","USA","URY","UZB","VAT","VCT","VEN","VGB","VIR","VNM","VUT",
"WLF","WSM","YEM","YT","SRB","ZAF","ZMB","MNE","ZWE","A1","A2","O1",
"ALA","GGY","IMN","JEY","BLM","MAF"
    );
    var $GEOIP_COUNTRY_NAMES = array(
"", "Asia/Pacific Region", "Europe", "Andorra", "United Arab Emirates",
"Afghanistan", "Antigua and Barbuda", "Anguilla", "Albania", "Armenia",
"Netherlands Antilles", "Angola", "Antarctica", "Argentina", "American Samoa",
"Austria", "Australia", "Aruba", "Azerbaijan", "Bosnia and Herzegovina",
"Barbados", "Bangladesh", "Belgium", "Burkina Faso", "Bulgaria", "Bahrain",
"Burundi", "Benin", "Bermuda", "Brunei Darussalam", "Bolivia", "Brazil",
"Bahamas", "Bhutan", "Bouvet Island", "Botswana", "Belarus", "Belize",
"Canada", "Cocos (Keeling) Islands", "Congo, The Democratic Republic of the",
"Central African Republic", "Congo", "Switzerland", "Cote D'Ivoire", "Cook Islands",
"Chile", "Cameroon", "China", "Colombia", "Costa Rica", "Cuba", "Cape Verde",
"Christmas Island", "Cyprus", "Czech Republic", "Germany", "Djibouti",
"Denmark", "Dominica", "Dominican Republic", "Algeria", "Ecuador", "Estonia",
"Egypt", "Western Sahara", "Eritrea", "Spain", "Ethiopia", "Finland", "Fiji",
"Falkland Islands (Malvinas)", "Micronesia, Federated States of", "Faroe Islands",
"France", "France, Metropolitan", "Gabon", "United Kingdom",
"Grenada", "Georgia", "French Guiana", "Ghana", "Gibraltar", "Greenland",
"Gambia", "Guinea", "Guadeloupe", "Equatorial Guinea", "Greece", "South Georgia and the South Sandwich Islands",
"Guatemala", "Guam", "Guinea-Bissau",
"Guyana", "Hong Kong", "Heard Island and McDonald Islands", "Honduras",
"Croatia", "Haiti", "Hungary", "Indonesia", "Ireland", "Israel", "India",
"British Indian Ocean Territory", "Iraq", "Iran, Islamic Republic of",
"Iceland", "Italy", "Jamaica", "Jordan", "Japan", "Kenya", "Kyrgyzstan",
"Cambodia", "Kiribati", "Comoros", "Saint Kitts and Nevis", "Korea, Democratic People's Republic of",
"Korea, Republic of", "Kuwait", "Cayman Islands",
"Kazakhstan", "Lao People's Democratic Republic", "Lebanon", "Saint Lucia",
"Liechtenstein", "Sri Lanka", "Liberia", "Lesotho", "Lithuania", "Luxembourg",
"Latvia", "Libyan Arab Jamahiriya", "Morocco", "Monaco", "Moldova, Republic of",
"Madagascar", "Marshall Islands", "Macedonia",
"Mali", "Myanmar", "Mongolia", "Macau", "Northern Mariana Islands",
"Martinique", "Mauritania", "Montserrat", "Malta", "Mauritius", "Maldives",
"Malawi", "Mexico", "Malaysia", "Mozambique", "Namibia", "New Caledonia",
"Niger", "Norfolk Island", "Nigeria", "Nicaragua", "Netherlands", "Norway",
"Nepal", "Nauru", "Niue", "New Zealand", "Oman", "Panama", "Peru", "French Polynesia",
"Papua New Guinea", "Philippines", "Pakistan", "Poland", "Saint Pierre and Miquelon",
"Pitcairn Islands", "Puerto Rico", "Palestinian Territory",
"Portugal", "Palau", "Paraguay", "Qatar", "Reunion", "Romania",
"Russian Federation", "Rwanda", "Saudi Arabia", "Solomon Islands",
"Seychelles", "Sudan", "Sweden", "Singapore", "Saint Helena", "Slovenia",
"Svalbard and Jan Mayen", "Slovakia", "Sierra Leone", "San Marino", "Senegal",
"Somalia", "Suriname", "Sao Tome and Principe", "El Salvador", "Syrian Arab Republic",
"Swaziland", "Turks and Caicos Islands", "Chad", "French Southern Territories",
"Togo", "Thailand", "Tajikistan", "Tokelau", "Turkmenistan",
"Tunisia", "Tonga", "Timor-Leste", "Turkey", "Trinidad and Tobago", "Tuvalu",
"Taiwan", "Tanzania, United Republic of", "Ukraine",
"Uganda", "United States Minor Outlying Islands", "United States", "Uruguay",
"Uzbekistan", "Holy See (Vatican City State)", "Saint Vincent and the Grenadines",
"Venezuela", "Virgin Islands, British", "Virgin Islands, U.S.",
"Vietnam", "Vanuatu", "Wallis and Futuna", "Samoa", "Yemen", "Mayotte",
"Serbia", "South Africa", "Zambia", "Montenegro", "Zimbabwe",
"Anonymous Proxy","Satellite Provider","Other",
"Aland Islands","Guernsey","Isle of Man","Jersey","Saint Barthelemy","Saint Martin"
);

    var $GEOIP_CONTINENT_CODES = array(
"--", "AS", "EU", "EU", "AS", "AS", "SA", "SA", "EU", "AS",
"SA", "AF", "AN", "SA", "OC", "EU", "OC", "SA", "AS", "EU",
"SA", "AS", "EU", "AF", "EU", "AS", "AF", "AF", "SA", "AS",
"SA", "SA", "SA", "AS", "AF", "AF", "EU", "SA", "NA", "AS",
"AF", "AF", "AF", "EU", "AF", "OC", "SA", "AF", "AS", "SA",
"SA", "SA", "AF", "AS", "AS", "EU", "EU", "AF", "EU", "SA",
"SA", "AF", "SA", "EU", "AF", "AF", "AF", "EU", "AF", "EU",
"OC", "SA", "OC", "EU", "EU", "EU", "AF", "EU", "SA", "AS",
"SA", "AF", "EU", "SA", "AF", "AF", "SA", "AF", "EU", "SA",
"SA", "OC", "AF", "SA", "AS", "AF", "SA", "EU", "SA", "EU",
"AS", "EU", "AS", "AS", "AS", "AS", "AS", "EU", "EU", "SA",
"AS", "AS", "AF", "AS", "AS", "OC", "AF", "SA", "AS", "AS",
"AS", "SA", "AS", "AS", "AS", "SA", "EU", "AS", "AF", "AF",
"EU", "EU", "EU", "AF", "AF", "EU", "EU", "AF", "OC", "EU",
"AF", "AS", "AS", "AS", "OC", "SA", "AF", "SA", "EU", "AF",
"AS", "AF", "NA", "AS", "AF", "AF", "OC", "AF", "OC", "AF",
"SA", "EU", "EU", "AS", "OC", "OC", "OC", "AS", "SA", "SA",
"OC", "OC", "AS", "AS", "EU", "SA", "OC", "SA", "AS", "EU",
"OC", "SA", "AS", "AF", "EU", "AS", "AF", "AS", "OC", "AF",
"AF", "EU", "AS", "AF", "EU", "EU", "EU", "AF", "EU", "AF",
"AF", "SA", "AF", "SA", "AS", "AF", "SA", "AF", "AF", "AF",
"AS", "AS", "OC", "AS", "AF", "OC", "AS", "EU", "SA", "OC",
"AS", "AF", "EU", "AF", "OC", "NA", "SA", "AS", "EU", "SA",
"SA", "SA", "SA", "AS", "OC", "OC", "OC", "AS", "AF", "EU",
"AF", "AF", "EU", "AF", "--", "--", "--", "EU", "EU", "EU",
"EU", "SA", "SA" );
    
}

function getCNameByCCode($cc) {
	if ($cc=='XX') return 'Unknown';
	$geoip = new GeoIP;
	return $geoip->GEOIP_COUNTRY_NAMES[$geoip->GEOIP_COUNTRY_CODE_TO_NUMBER[$cc]];
}

function getUserRights($userID) {
	$q = "SELECT ur.rights FROM `users` as u
			left join `userrights` as ur on ur.name = u.rights
			WHERE u.id = '".$userID."'";
	$value=cdim('db','query',$q);
	return unserialize($value[0]->rights);
}

function getUserNameById($id) {
	$res = cdim('db','query',"SELECT * FROM `users` WHERE `id` = ".$id.";");
	return isset($res) ? $res[0]->user_login : 'системная запись';
}

function generateCookie() {
	$abc = str_split('qazwsxedcrfvtgbyhnujmikolp1234567890');
	shuffle($abc);
	$i=1;
	foreach($abc as $k=>$v) {
		$return[] = rand(0,1)==1 ? strtoupper($v) : $v;
		if ($i>=10) return implode('',$return); else $i++;
	}
	return implode('',$return);
}


// цвет пользователя в формате FFFFFF приоритет за тем что в таблице users перед таблицей userrights
$getUserColorBiId = function($id) {
	if (!is_numeric($id)) $where = "WHERE u.user_login = '".$id."'";
	if (is_numeric($id)) $where = "WHERE u.id = ".$id."";
	$rights = cdim('db','query',"SELECT ur.rights, u.color FROM `users` AS u
								LEFT JOIN `userrights` AS ur ON ur.name = u.rights
								".$where."
	;");

	if ($rights[0]->color!='') return $rights[0]->color;
	$rights = unserialize($rights[0]->rights);
	return $rights['color'];
};




function getRightsSelector() {
	$q = "SELECT * FROM `userrights`";
	$rights = cdim('db','query',$q);
	$out = '';
	foreach($rights as $k=>$v) {
		$unserializedRights = unserialize($v->rights);
		$out .= '<option value="'.$v->id.'">'.$unserializedRights['rolename'].'</option>'."\n";
	}
	return $out;
}

function ua2os($ua) {
	$OSList = array (
		// Match user agent string with operating systems
		'Windows 3.11' => 'Win16',
		'Windows 95' => '(Windows 95)|(Win95)|(Windows_95)',
		'Windows 98' => '(Windows 98)|(Win98)',
		'Windows NT 4.0' => '(Windows NT 4.0)|(WinNT4.0)|(WinNT)',
		'Windows 2000' => '(Windows NT 5.0)|(Windows 2000)',
		'Windows XP' => '(Windows NT 5.1)|(Windows XP)',
		'Windows Server 2003' => '(Windows NT 5.2)',
		'Windows 8.1' => '(Windows NT 6.3)',
		'Windows 8' => '(Windows NT 6.2)',
		'Windows 7' => '(Windows NT 6.1)|(Windows NT 7.0)',
		'Windows Vista' => '(Windows NT 6.0)',
		'Windows ME' => 'Windows ME',
		'Open BSD' => 'OpenBSD',
		'Sun OS' => 'SunOS',
		'Linux' => '(Linux)|(X11)',
		'Mac OS' => '(Mac_PowerPC)|(Macintosh)',
		'QNX' => 'QNX',
		'BeOS' => 'BeOS',
		'OS/2' => 'OS\/2',
		'Search Bot'=>'(nuhk)|(Googlebot)|(Yammybot)|(Openbot)|(Slurp)|(MSNBot)|(Ask Jeeves\/Teoma)|(ia_archiver)'
	);

	foreach($OSList as $k=>$v) {
		if (preg_match('/'.$v.'/i', $ua)) {
			return $k;
		}
		
	}
	return 'Unknown';
}


function parse_user_agent( $u_agent = null ) {
	if( is_null($u_agent) && isset($_SERVER['HTTP_USER_AGENT']) ) $u_agent = $_SERVER['HTTP_USER_AGENT'];

	$platform = null;
	$browser  = null;
	$version  = null;

	$empty = array( 'platform' => $platform, 'browser' => $browser, 'version' => $version );

	if( !$u_agent ) return $empty;

	if( preg_match('/\((.*?)\)/im', $u_agent, $parent_matches) ) {

		preg_match_all('/(?P<platform>Android|CrOS|iPhone|iPad|Linux|Macintosh|Windows(\ Phone\ OS)?|Silk|linux-gnu|BlackBerry|PlayBook|Nintendo\ (WiiU?|3DS)|Xbox)
			(?:\ [^;]*)?
			(?:;|$)/imx', $parent_matches[1], $result, PREG_PATTERN_ORDER);

		$priority		   = array( 'Android', 'Xbox' );
		$result['platform'] = array_unique($result['platform']);
		if( count($result['platform']) > 1 ) {
			if( $keys = array_intersect($priority, $result['platform']) ) {
				$platform = reset($keys);
			} else {
				$platform = $result['platform'][0];
			}
		} elseif( isset($result['platform'][0]) ) {
			$platform = $result['platform'][0];
		}
	}

	if( $platform == 'linux-gnu' ) {
		$platform = 'Linux';
	} elseif( $platform == 'CrOS' ) {
		$platform = 'Chrome OS';
	}

	preg_match_all('%(?P<browser>Camino|Kindle(\ Fire\ Build)?|Firefox|Iceweasel|Safari|MSIE|Trident/.*rv|AppleWebKit|Chrome|IEMobile|Opera|OPR|Silk|Lynx|Midori|Version|Wget|curl|NintendoBrowser|PLAYSTATION\ (\d|Vita)+)
			(?:\)?;?)
			(?:(?:[:/ ])(?P<version>[0-9A-Z.]+)|/(?:[A-Z]*))%ix',
		$u_agent, $result, PREG_PATTERN_ORDER);


	// If nothing matched, return null (to avoid undefined index errors)
	if( !isset($result['browser'][0]) || !isset($result['version'][0]) ) {
		return $empty;
	}

	$browser = $result['browser'][0];
	$version = $result['version'][0];

	$find = function ( $search, &$key ) use ( $result ) {
		$xkey = array_search(strtolower($search), array_map('strtolower', $result['browser']));
		if( $xkey !== false ) {
			$key = $xkey;

			return true;
		}

		return false;
	};

	$key = 0;
	if( $browser == 'Iceweasel' ) {
		$browser = 'Firefox';
	} elseif( $find('Playstation Vita', $key) ) {
		$platform = 'PlayStation Vita';
		$browser  = 'Browser';
	} elseif( $find('Kindle Fire Build', $key) || $find('Silk', $key) ) {
		$browser  = $result['browser'][$key] == 'Silk' ? 'Silk' : 'Kindle';
		$platform = 'Kindle Fire';
		if( !($version = $result['version'][$key]) || !is_numeric($version[0]) ) {
			$version = $result['version'][array_search('Version', $result['browser'])];
		}
	} elseif( $find('NintendoBrowser', $key) || $platform == 'Nintendo 3DS' ) {
		$browser = 'NintendoBrowser';
		$version = $result['version'][$key];
	} elseif( $find('Kindle', $key) ) {
		$browser  = $result['browser'][$key];
		$platform = 'Kindle';
		$version  = $result['version'][$key];
	} elseif( $find('OPR', $key) ) {
		$browser = 'Opera Next';
		$version = $result['version'][$key];
	} elseif( $find('Opera', $key) ) {
		$browser = 'Opera';
		$find('Version', $key);
		$version = $result['version'][$key];
	} elseif( $find('Midori', $key) ) {
		$browser = 'Midori';
		$version = $result['version'][$key];
	} elseif( $find('Chrome', $key) ) {
		$browser = 'Chrome';
		$version = $result['version'][$key];
	} elseif( $browser == 'AppleWebKit' ) {
		if( ($platform == 'Android' && !($key = 0)) ) {
			$browser = 'Android Browser';
		} elseif( $platform == 'BlackBerry' || $platform == 'PlayBook' ) {
			$browser = 'BlackBerry Browser';
		} elseif( $find('Safari', $key) ) {
			$browser = 'Safari';
		}

		$find('Version', $key);

		$version = $result['version'][$key];
	} elseif( $browser == 'MSIE' || strpos($browser, 'Trident') !== false ) {
		if( $find('IEMobile', $key) ) {
			$browser = 'IEMobile';
		} else {
			$browser = 'MSIE';
			$key	 = 0;
		}
		$version = $result['version'][$key];
	} elseif( $key = preg_grep("/playstation \d/i", array_map('strtolower', $result['browser'])) ) {
		$key = reset($key);

		$platform = 'PlayStation ' . preg_replace('/[^\d]/i', '', $key);
		$browser  = 'NetFront';
	}

	return array( 'platform' => $platform, 'browser' => $browser, 'version' => $version );

}

function base64url_encode($data) { 
  return rtrim(strtr(base64_encode($data), '+/', '-_'), '='); 
} 

function base64url_decode($data) { 
  return base64_decode(str_pad(strtr($data, '-_', '+/'), strlen($data) % 4, '=', STR_PAD_RIGHT)); 
} 

?>