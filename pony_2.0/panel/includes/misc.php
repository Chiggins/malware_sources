<?php

/*
	Miscellaneous functions.
*/

class debug_log
{
	public $log_lines = array();
	
	public function add($msg)
	{
		$output = '';
        		
	    $trace = debug_backtrace();
	    foreach ($trace as $value)
	    {
        	$output .= $value['function']."():".$value['line']." ";
		}
    	
    	array_push($this->log_lines, array("$msg", $output));
	}

	public function import_from($extern_log)
	{
		foreach ($extern_log->log_lines as $extern_log_line)
		{
			array_push($this->log_lines, $extern_log_line);
		}
	}
}

// decode 4 byte string into int32 value
function data_int32($data)
{
	$unpacked_dword = unpack('V', $data);
	return $unpacked_dword[1] & 0xffffffff;
}

// validate host through regular epxression
function is_valid_host($host)
{
	global $global_allow_all_ftp;
	if ($global_allow_all_ftp)
		return true;

	if (preg_match('/^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$/', $host))
		return true;
	else
		return false;
}

// validate IP
function is_valid_ip($ip)
{
	global $global_allow_all_ftp;
	if ($global_allow_all_ftp)
		return true;
		
	if (preg_match('/^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/', $ip))
		return true;
	else
		return false;
}

function validEmail($email)
{
    $isValid = true;
    $atIndex = strrpos($email, "@");
    if (is_bool($atIndex) && !$atIndex) {
        $isValid = false;
    }
    else
    {
        $domain = substr($email, $atIndex + 1);
        $local = substr($email, 0, $atIndex);
        $localLen = strlen($local);
        $domainLen = strlen($domain);
        if ($localLen < 1 || $localLen > 64) {
            // local part length exceeded
            $isValid = false;
        }
        else if ($domainLen < 1 || $domainLen > 255) {
            // domain part length exceeded
            $isValid = false;
        }
        else if ($local[0] == '.' || $local[$localLen - 1] == '.') {
            // local part starts or ends with '.'
            $isValid = false;
        }
        else if (preg_match('/\\.\\./', $local)) {
            // local part has two consecutive dots
            $isValid = false;
        }
        else if (!preg_match('/^[A-Za-z0-9\\-\\.]+$/', $domain)) {
            // character not valid in domain part
            $isValid = false;
        }
        else if (preg_match('/\\.\\./', $domain)) {
            // domain part has two consecutive dots
            $isValid = false;
        }
        else if
        (!preg_match('/^(\\\\.|[A-Za-z0-9!#%&`_=\\/$\'*+?^{}|~.-])+$/',
                str_replace("\\\\", "", $local))
        ) {
            // character not valid in local part unless
            // local part is quoted
            if (!preg_match('/^"(\\\\"|[^"])+"$/',
                str_replace("\\\\", "", $local))
            ) {
                $isValid = false;
            }
        }
    }
    return $isValid;
}

// validate email
function is_valid_email($email)
{
    global $global_allow_all_ftp;
    if ($global_allow_all_ftp)
        return true;

    return validEmail($email);
}

// validate IP and apply filter, to remove unneeded IPs
// 10.0.0.0 -> 10.255.255.255
// 172.16.0.0 -> 172.31.255.255
function is_valid_ip_filter($ip)
{
	global $global_allow_all_ftp;
	if ($global_allow_all_ftp)
		return true;
	
	if (!is_valid_ip($ip))
		return false;
	
	$ip_values = preg_split("/[.]/", $ip);
	
	for ($i = 0; $i < 4; $i++)
		$ip_values[$i] = intval($ip_values[$i]);
	
	if ($ip_values[0] == 10)
		return false;

	if ($ip_values[0] == 172 && $ip_values[1] >= 16 && $ip_values[1] <= 31)
		return false;
	
	return true;
}

function parse_lines($value)
{
	return preg_split("/((\r(?!\n))|((?<!\r)\n)|(\r\n))/", $value);
}

// parse ini file
function parse_ini($ini)
{
	// split lines
    $ini = parse_lines($ini);
    
    if (count($ini) == 0) 
    	return array();
    	
    $result = array();
    $sections = array();
    $values = array();
    $globals = array();
    $i = 0;
    foreach($ini as $line)
    {
        $line = trim($line);
        
        // Comments, do not parse line
        if ($line == '' || $line{0} == ';')
            continue;
            
        // Sections
        if ($line{0} == '[')
        {
            $sections[] = substr($line, 1, -1);
            $i++;
            continue;
        }
        
        // Key-value pair
        if (strpos($line, '=') === false)
        {
			$key = $line;
			$value = '';
		} else
        	list($key, $value) = explode('=', $line, 2);
        $key = strtolower(trim($key));
        $value = trim($value);
        if ($i == 0) 
        {
            // Array values
            if (substr($line, -1, 2) == '[]') 
            {
                $globals[$key][] = $value;
            } else {
                $globals[$key] = $value;
            }
        } else 
        {
            // Array values
            if (substr($line, -1, 2) == '[]')
            {
                $values[$i-1][$key][] = $value;
            } else
            {
                $values[$i-1][$key] = $value;
            }
        }
    }
    foreach ($values as $key => $value)
		$result[$sections[$key]] = $value;
    return $result + $globals;
}

function collect_ini_array($ini_array)
{
	$result = '';
	foreach ($ini_array as $key=>$value)
	{
		$result .= $key.'='.$value."\r\n";
	}
	return trim($result);
}

function nonempty(&$var)
{
	return (isset($var) && $var);
}

// crc32b function (0xEDB88320 polynomial)
function crc32b_str($data)
{  
	$CRC32Table = array(
		(int)0x00000000, (int)0x77073096, (int)0xEE0E612C, (int)0x990951BA, (int)0x076DC419, (int)0x706AF48F, (int)0xE963A535, 
		(int)0x9E6495A3, (int)0x0EDB8832, (int)0x79DCB8A4, (int)0xE0D5E91E, (int)0x97D2D988, (int)0x09B64C2B, (int)0x7EB17CBD, 
		(int)0xE7B82D07, (int)0x90BF1D91, (int)0x1DB71064, (int)0x6AB020F2, (int)0xF3B97148, (int)0x84BE41DE, (int)0x1ADAD47D, 
		(int)0x6DDDE4EB, (int)0xF4D4B551, (int)0x83D385C7, (int)0x136C9856, (int)0x646BA8C0, (int)0xFD62F97A, (int)0x8A65C9EC, 
		(int)0x14015C4F, (int)0x63066CD9, (int)0xFA0F3D63, (int)0x8D080DF5, (int)0x3B6E20C8, (int)0x4C69105E, (int)0xD56041E4, 
		(int)0xA2677172, (int)0x3C03E4D1, (int)0x4B04D447, (int)0xD20D85FD, (int)0xA50AB56B, (int)0x35B5A8FA, (int)0x42B2986C, 
		(int)0xDBBBC9D6, (int)0xACBCF940, (int)0x32D86CE3, (int)0x45DF5C75, (int)0xDCD60DCF, (int)0xABD13D59, (int)0x26D930AC, 
		(int)0x51DE003A, (int)0xC8D75180, (int)0xBFD06116, (int)0x21B4F4B5, (int)0x56B3C423, (int)0xCFBA9599, (int)0xB8BDA50F,
		(int)0x2802B89E, (int)0x5F058808, (int)0xC60CD9B2, (int)0xB10BE924, (int)0x2F6F7C87, (int)0x58684C11, (int)0xC1611DAB, 
		(int)0xB6662D3D, (int)0x76DC4190, (int)0x01DB7106, (int)0x98D220BC, (int)0xEFD5102A, (int)0x71B18589, (int)0x06B6B51F, 
		(int)0x9FBFE4A5, (int)0xE8B8D433, (int)0x7807C9A2, (int)0x0F00F934, (int)0x9609A88E, (int)0xE10E9818, (int)0x7F6A0DBB, 
		(int)0x086D3D2D, (int)0x91646C97, (int)0xE6635C01, (int)0x6B6B51F4, (int)0x1C6C6162, (int)0x856530D8, (int)0xF262004E, 
		(int)0x6C0695ED, (int)0x1B01A57B, (int)0x8208F4C1, (int)0xF50FC457, (int)0x65B0D9C6, (int)0x12B7E950, (int)0x8BBEB8EA,
		(int)0xFCB9887C, (int)0x62DD1DDF, (int)0x15DA2D49, (int)0x8CD37CF3, (int)0xFBD44C65, (int)0x4DB26158, (int)0x3AB551CE,
		(int)0xA3BC0074, (int)0xD4BB30E2, (int)0x4ADFA541, (int)0x3DD895D7, (int)0xA4D1C46D, (int)0xD3D6F4FB, (int)0x4369E96A, 
		(int)0x346ED9FC, (int)0xAD678846, (int)0xDA60B8D0, (int)0x44042D73, (int)0x33031DE5, (int)0xAA0A4C5F, (int)0xDD0D7CC9,
		(int)0x5005713C, (int)0x270241AA, (int)0xBE0B1010, (int)0xC90C2086, (int)0x5768B525, (int)0x206F85B3, (int)0xB966D409,
		(int)0xCE61E49F, (int)0x5EDEF90E, (int)0x29D9C998, (int)0xB0D09822, (int)0xC7D7A8B4, (int)0x59B33D17, (int)0x2EB40D81, 
		(int)0xB7BD5C3B, (int)0xC0BA6CAD, (int)0xEDB88320, (int)0x9ABFB3B6, (int)0x03B6E20C, (int)0x74B1D29A, (int)0xEAD54739, 
		(int)0x9DD277AF, (int)0x04DB2615, (int)0x73DC1683, (int)0xE3630B12, (int)0x94643B84, (int)0x0D6D6A3E, (int)0x7A6A5AA8, 
		(int)0xE40ECF0B, (int)0x9309FF9D, (int)0x0A00AE27, (int)0x7D079EB1, (int)0xF00F9344, (int)0x8708A3D2, (int)0x1E01F268, 
		(int)0x6906C2FE, (int)0xF762575D, (int)0x806567CB, (int)0x196C3671, (int)0x6E6B06E7, (int)0xFED41B76, (int)0x89D32BE0, 
		(int)0x10DA7A5A, (int)0x67DD4ACC, (int)0xF9B9DF6F, (int)0x8EBEEFF9, (int)0x17B7BE43, (int)0x60B08ED5, (int)0xD6D6A3E8, 
		(int)0xA1D1937E, (int)0x38D8C2C4, (int)0x4FDFF252, (int)0xD1BB67F1, (int)0xA6BC5767, (int)0x3FB506DD, (int)0x48B2364B,
		(int)0xD80D2BDA, (int)0xAF0A1B4C, (int)0x36034AF6, (int)0x41047A60, (int)0xDF60EFC3, (int)0xA867DF55, (int)0x316E8EEF, 
		(int)0x4669BE79, (int)0xCB61B38C, (int)0xBC66831A, (int)0x256FD2A0, (int)0x5268E236, (int)0xCC0C7795, (int)0xBB0B4703, 
		(int)0x220216B9, (int)0x5505262F, (int)0xC5BA3BBE, (int)0xB2BD0B28, (int)0x2BB45A92, (int)0x5CB36A04, (int)0xC2D7FFA7, 
		(int)0xB5D0CF31, (int)0x2CD99E8B, (int)0x5BDEAE1D, (int)0x9B64C2B0, (int)0xEC63F226, (int)0x756AA39C, (int)0x026D930A, 
		(int)0x9C0906A9, (int)0xEB0E363F, (int)0x72076785, (int)0x05005713, (int)0x95BF4A82, (int)0xE2B87A14, (int)0x7BB12BAE, 
		(int)0x0CB61B38, (int)0x92D28E9B, (int)0xE5D5BE0D, (int)0x7CDCEFB7, (int)0x0BDBDF21, (int)0x86D3D2D4, (int)0xF1D4E242, 
		(int)0x68DDB3F8, (int)0x1FDA836E, (int)0x81BE16CD, (int)0xF6B9265B, (int)0x6FB077E1, (int)0x18B74777, (int)0x88085AE6, 
		(int)0xFF0F6A70, (int)0x66063BCA, (int)0x11010B5C, (int)0x8F659EFF, (int)0xF862AE69, (int)0x616BFFD3, (int)0x166CCF45,
		(int)0xA00AE278, (int)0xD70DD2EE, (int)0x4E048354, (int)0x3903B3C2, (int)0xA7672661, (int)0xD06016F7, (int)0x4969474D, 
		(int)0x3E6E77DB, (int)0xAED16A4A, (int)0xD9D65ADC, (int)0x40DF0B66, (int)0x37D83BF0, (int)0xA9BCAE53, (int)0xDEBB9EC5, 
		(int)0x47B2CF7F, (int)0x30B5FFE9, (int)0xBDBDF21C, (int)0xCABAC28A, (int)0x53B39330, (int)0x24B4A3A6, (int)0xBAD03605, 
		(int)0xCDD70693, (int)0x54DE5729, (int)0x23D967BF, (int)0xB3667A2E, (int)0xC4614AB8, (int)0x5D681B02, (int)0x2A6F2B94, 
		(int)0xB40BBE37, (int)0xC30C8EA1, (int)0x5A05DF1B, (int)0x2D02EF8D);
   
	$remainder = 0xffffffff;
	$len = strlen($data);
	for ($i = 0; $i < $len; $i++)
	{
		$index = (ord($data[$i]) ^ $remainder) & 0xff;
		$crc = $CRC32Table[$index];
		$remainder = (($remainder >> 8) & 0xffffff) ^ $crc;
	}

	return $remainder;
} 

// decode hex-encoded string
function hextostr($x)
{ 
	// validate hex string
	if (!preg_match("/^([0-9A-Fa-f]{2})+$/", $x))
		return false;
	$s = ''; 
	foreach (explode("\n", trim(chunk_split($x, 2))) as $h)
		$s .= chr(hexdec($h)); 
	return($s); 
} 

// decode hex-encoded string
function int3tostr($x)
{ 
	// validate hex string
	if (!preg_match("/^([0-9]{3})+$/", $x))
		return false;
	$s = ''; 
	foreach (explode("\n", trim(chunk_split($x, 3))) as $h)
		$s .= chr(intval($h)); 
	return($s); 
} 

// fast integer divide
function int_divide($x, $y)
{
	if ($x == 0) return 0;
	if ($y == 0) return FALSE;
	return ($x - ($x % $y)) / $y;
}

// shift left 
function gmp_shiftl($x, $n)
{
	return(gmp_mul($x,gmp_pow(2,$n))); 
} 

// shift right 
function gmp_shiftr($x, $n)
{
	return(gmp_div($x,gmp_pow(2,$n))); 
}

function myrand($max, &$seed)
{
	$seed = hexdec(gmp_strval(gmp_and(gmp_add(gmp_mul("$seed", "0x8088405"), "1"), "0xffffffff"), 16));
	$v = hexdec(gmp_strval(gmp_and(gmp_shiftr(gmp_mul("0x".dechex($seed), "$max"), "32"), "0xffffffff"), 16));
	return $v;
}

function _BF_SHR32 ($x, $bits)
{
    if ($bits==0) return $x;
    if ($bits==32) return 0;
    $y = ($x & 0x7FFFFFFF) >> $bits;
    if (0x80000000 & $x) {
        $y |= (1<<(31-$bits));    
    }
    return $y;
}

function _BF_SHL32 ($x, $bits)
{
    if ($bits==0) return $x;
    if ($bits==32) return 0;
    $mask = (1<<(32-$bits)) - 1;
    return (($x & $mask) << $bits) & 0xFFFFFFFF;
}

function _BF_GETBYTE ($x, $y) 
{
    return _BF_SHR32 ($x, 8 * $y) & 0xFF;
}

function _BF_OR32 ($x, $y)
{
    return ($x | $y) & 0xFFFFFFFF;
}

function _BF_ADD32 ($x, $y)
{

    $x = $x & 0xFFFFFFFF;
    $y = $y & 0xFFFFFFFF;

    $total = 0;
    $carry = 0;
    for ($i=0; $i<4; $i++)
    {
        $byte_x = _BF_GETBYTE($x, $i);
        $byte_y = _BF_GETBYTE($y, $i);
        $sum = $byte_x + $byte_y;

        $result = $sum & 0xFF;
        $carryforward = _BF_SHR32($sum, 8); 

        $sum = $result + $carry;
        $result = $sum & 0xFF;
        $carry = $carryforward + _BF_SHR32($sum, 8); 

        $total = _BF_OR32(_BF_SHL32($result, $i*8), $total); 
    }

    return $total;
}

function _BF_SUB32($x, $y) 
{
    return _BF_ADD32($x, -$y);
}

function _BF_XOR32($x, $y) 
{
    $x = $x & 0xFFFFFFFF;
    $y = $y & 0xFFFFFFFF;
    return $x ^ $y;
}

function strip_quotes($s)
{
	if (!$s)
		return "";
	if ($s[0] == '"')
	{
		return substr($s, 1, -1);
	} else
		return $s;
}

function is_num($s)
{
	return (preg_match("/^([0-9])+$/", $s));
}

function append_dir($host, &$dir)
{
	$host = trim($host);

	// empty dir or zero-length host
	if (!nonempty($dir) || !strlen($host))
		return $host;
	
	$dir = trim($dir);
	
	$s = strip_quotes($dir);
	if ($s && $s[0] != '/' && $s[0] != '\\')
		$s = "/".$s;
	
	return $host.$s;
}

function append_port($host, &$port)
{
	$host = trim($host);
	
	// empty port or zero-length host
	if (!nonempty($port) || !strlen($host))
		return $host;
	
	$port = trim(strval($port));
	$s = strip_quotes($port);
	if (strlen($s) && is_num($s))
		$s = ":".$s;
	else
		$s = "";
			
	return $host.$s;	
}

function append_port_dir($host, &$port, &$dir)
{
	return append_dir(append_port($host, $port), $dir);
}

function assign(&$value)
{
	if (nonempty($value))
		return $value;
	else
		return '';	
}

function assign_trim(&$value)
{
	return trim(assign($value));
}

// restore obfuscated crc32 value
function obf_crc32($v)
{
	return (int)(~((($v & 0x000000ff) << 24) |
		        (($v & 0x0000ff00) << 8) |
	            ((($v & 0x00ff0000) >> 8) & 0xff00) | // it's a sar operation, not shr
				((($v & 0xff000000) >> 24) & 0xff))) & 0xffffffff;  // it's a sar operation, not shr
}

// aplib unpack code, ported from C exsample
class APDEPACKDATA
{
	public $source;
	public $src_offset = 0;
	public $destination;
	public $dst_offset = 0;
	public $tag;
	public $bitcount;
}

function aP_getbit(&$ud)
{
	if (!$ud->bitcount--)
	{
		$ud->tag = ord($ud->source[$ud->src_offset++]);
		$ud->bitcount = 7;
	}
	
	$bit = ($ud->tag >> 7) & 0x01;
	$ud->tag = $ud->tag << 1;
	
	return $bit;
}

function aP_getgamma(&$ud)
{
	$result = 1;
	do
	{
        $result = ($result << 1) + aP_getbit($ud);
	} while (aP_getbit($ud));
	return $result;
}

function aP_depack($source, &$dest)
{
	$ud = new APDEPACKDATA();
	
    $R0 = 0;
    $LWM = 0;
    $done = 0;
    
    $ud->source = $source;
    $ud->destination = &$dest;
    $ud->bitcount = 0;

    $ud->destination .= $ud->source[$ud->src_offset++];
    $ud->dst_offset++;
	
    while (!$done)
    {
        if (aP_getbit($ud))
        {
            if (aP_getbit($ud))
            {
                if (aP_getbit($ud))
                {
                	$offs = 0;
                    for ($i = 4; $i; $i--) $offs = ($offs << 1) + aP_getbit($ud);
                    
                    if ($offs)
                    {
                        $ud->destination .= $ud->destination[$ud->dst_offset - $offs];
                        $ud->dst_offset++;
                    } else
                    {
                        $ud->destination .= chr(0);
                        $ud->dst_offset++;
                    }
                    $LWM = 0;                    
				} else
				{
                    $offs = ord($ud->source[$ud->src_offset++]);

                    $len = 2 + ($offs & 0x0001);

                    $offs = $offs >> 1;

                    if ($offs)
                    {
                        while ($len--)
                        {
							$ud->destination .= $ud->destination[$ud->dst_offset - $offs];
		                    $ud->dst_offset++;
                        }
                    } else 
                    	$done = 1;
                    
                    $R0 = $offs;
                    $LWM = 1;
				}
            } else
            {
                $offs = aP_getgamma($ud);

                if (($LWM == 0) && ($offs == 2))
                {
                    $offs = $R0;

                    $len = aP_getgamma($ud);

                    while ($len--)
                    {
						$ud->destination .= $ud->destination[$ud->dst_offset - $offs];
		                $ud->dst_offset++;
                    }
                } else
                {
                    if ($LWM == 0) $offs -= 3; else $offs -= 2;

                    $offs = $offs << 8;
                    $offs += ord($ud->source[$ud->src_offset++]);

                    $len = aP_getgamma($ud);

                    if ($offs >= 32000) $len++;
                    if ($offs >= 1280) $len++;
                    if ($offs < 128) $len += 2;
                   	                   	
                    while ($len--)
                    {
						$ud->destination .= $ud->destination[$ud->dst_offset - $offs];
		                $ud->dst_offset++;
                    }                    
                    $R0 = $offs;
                }
                $LWM = 1;
            }

        } else
        {
			$ud->destination .= $ud->source[$ud->src_offset++];
			$ud->dst_offset++;
            $LWM = 0;
        }
	}
	
	return $ud->dst_offset;
}

// trim password value at zero char
function ztrim($data)
{
	for ($i = 0; $i < strlen($data); $i++)
		if ($data[$i] == chr(0))
		{
			$data = substr($data, 0, $i);
			break;
		}
	return $data;
}

function ztrim_unicode($data)
{
	for ($i = 0; $i < strlen($data)-1; $i += 2)
		if ($data[$i] == chr(0) && $data[$i+1] == chr(0))
		{
			$data = substr($data, 0, $i);
			break;
		}
	return $data;
}

class XMLParser
{
    var $rawXML;
    var $valueArray = array();
    var $keyArray = array();
    var $parsed = array();
    var $index = 0;
    var $attribKey = 'attributes';
    var $valueKey = 'value';
    var $cdataKey = 'cdata';
    var $isError = false;
    var $error = '';

    function XMLParser($xml = NULL)
    {
        $this->rawXML = $xml;
    }

    function parse($xml = NULL)
    {
        if (!is_null($xml))
        {
            $this->rawXML = $xml;
        }

        $this->isError = false;
            
        if (!$this->parse_init())
        {
            return false;
        }

        $this->index = 0;
        $this->parsed = $this->parse_recurse();
        $this->status = 'parsing complete';

        return $this->parsed;
    }

    function parse_recurse()
    {        
        $found = array();
        $tagCount = array();

        while (isset($this->valueArray[$this->index]))
        {
            $tag = $this->valueArray[$this->index];
            $this->index++;

            if ($tag['type'] == 'close')
            {
                return $found;
            }

            if ($tag['type'] == 'cdata')
            {
                $tag['tag'] = $this->cdataKey;
                $tag['type'] = 'complete';
            }

            $tagName = $tag['tag'];

            if (isset($tagCount[$tagName]))
            {        
                if ($tagCount[$tagName] == 1)
                {
                    $found[$tagName] = array($found[$tagName]);
                }
                    
                $tagRef =& $found[$tagName][$tagCount[$tagName]];
                $tagCount[$tagName]++;
            }
            else    
            {
                $tagCount[$tagName] = 1;
                $tagRef =& $found[$tagName];
            }

            switch ($tag['type'])
            {
                case 'open':
                    $tagRef = $this->parse_recurse();

                    if (isset($tag['attributes']))
                    {
                        $tagRef[$this->attribKey] = $tag['attributes'];
                    }
                        
                    if (isset($tag['value']))
                    {
                        if (isset($tagRef[$this->cdataKey]))    
                        {
                            $tagRef[$this->cdataKey] = (array)$tagRef[$this->cdataKey];    
                            array_unshift($tagRef[$this->cdataKey], $tag['value']);
                        }
                        else
                        {
                            $tagRef[$this->cdataKey] = $tag['value'];
                        }
                    }
                    break;

                case 'complete':
                    if (isset($tag['attributes']))
                    {
                        $tagRef[$this->attribKey] = $tag['attributes'];
                        $tagRef =& $tagRef[$this->valueKey];
                    }

                    if (isset($tag['value']))
                    {
                        $tagRef = $tag['value'];
                    }
                    break;
            }            
        }

        return $found;
    }

    function parse_init()
    {
        $this->parser = xml_parser_create();

        $parser = $this->parser;
        xml_parser_set_option($parser, XML_OPTION_CASE_FOLDING, 0);     
        xml_parser_set_option($parser, XML_OPTION_SKIP_WHITE, 1);        
        xml_parser_set_option($parser, XML_OPTION_TARGET_ENCODING, "utf-8");
        
        if (!$res = (bool)xml_parse_into_struct($parser, $this->rawXML, $this->valueArray, $this->keyArray))
        {
            $this->isError = true;
            $this->error = 'error: '.xml_error_string(xml_get_error_code($parser)).' at line '.xml_get_current_line_number($parser);
        }
        xml_parser_free($parser);

        return $res;
    }
}

function Utf8ToWin($fcontents) 
{
	$out = $c1 = '';
	if (!is_string($fcontents))
		return '';
	$byte2 = false;
	for ($c = 0; $c < strlen($fcontents); $c++) 
	{
		$i = ord($fcontents[$c]);
		if ($i <= 127) 
		{
			$out .= $fcontents[$c];
		}
		if ($byte2) 
		{
			$new_c2 = ($c1 & 3) * 64 + ($i & 63);
			$new_c1 = ($c1 >> 2) & 5;
			$new_i = $new_c1 * 256 + $new_c2;
			if ($new_i == 1025) {
				$out_i = 168;
			} else 
			{
				if ($new_i == 1105) {
					$out_i = 184;
				} else 
				{
					$out_i = $new_i - 848;
				}
			}
			$out .= chr($out_i);
			$byte2 = false;
		}
		if (($i >> 5) == 6) 
		{
			$c1 = $i;
			$byte2 = true;
		}
	}
	return $out;
}


function unicode_char_to_utf8($c)
{
    $output="";
   
    if($c < 0x80)
    {
        return chr($c);
    }
    else if($c < 0x800)
    {
        return chr( 0xc0 | ($c >> 6) ).chr( 0x80 | ($c & 0x3f) );
    }
    else if($c < 0x10000)
    {
        return chr( 0xe0 | ($c >> 12) ).chr( 0x80 | (($c >> 6) & 0x3f) ).chr( 0x80 | ($c & 0x3f) );
    }
    else if($c < 0x200000)
    {
        return chr(0xf0 | ($c >> 18)).chr(0x80 | (($c >> 12) & 0x3f)).chr(0x80 | (($c >> 6) & 0x3f)).chr(0x80 | ($c & 0x3f));
    }
    
    return false;
}

function unicode_to_utf8($string) 
{
	$log = new debug_log();
	$stream = new stream($string, $log);
	$r = '';
	while ($stream->state && $stream->pos < $stream->datalen)
	{
		$r .= unicode_char_to_utf8($stream->read_word());
	}
	if (!$stream->state)
		return false;
	return $r;
}

// maske sure input string is unicode
function unicode_to_ansi($string)
{
	if (!strlen($string))
		return '';
	
	// check for unicode length validness
	if (strlen($string) % 2 != 0)
	{
		return '';
	}
	else
		return Utf8ToWin(unicode_to_utf8($string));
		
	// alternative
	//return mb_convert_encoding($string, "cp1251", "UTF-16LE");
}

// Returns true if $string is valid UTF-8 and false otherwise.
function is_utf8($string)
{  
    // From http://w3.org/International/questions/qa-forms-utf-8.html
    return preg_match('%^(?:
          [\x09\x0A\x0D\x20-\x7E]            # ASCII
        | [\xC2-\xDF][\x80-\xBF]             # non-overlong 2-byte
        |  \xE0[\xA0-\xBF][\x80-\xBF]        # excluding overlongs
        | [\xE1-\xEC\xEE\xEF][\x80-\xBF]{2}  # straight 3-byte
        |  \xED[\x80-\x9F][\x80-\xBF]        # excluding surrogates
        |  \xF0[\x90-\xBF][\x80-\xBF]{2}     # planes 1-3
        | [\xF1-\xF3][\x80-\xBF]{3}          # planes 4-15
        |  \xF4[\x80-\x8F][\x80-\xBF]{2}     # plane 16
    )*$%xs', $string);
    
} 

// Unicode BOM is U+FEFF, but after encoded, it will look like this.
define ('UTF32_BIG_ENDIAN_BOM'   , chr(0x00) . chr(0x00) . chr(0xFE) . chr(0xFF));
define ('UTF32_LITTLE_ENDIAN_BOM', chr(0xFF) . chr(0xFE) . chr(0x00) . chr(0x00));
define ('UTF16_BIG_ENDIAN_BOM'   , chr(0xFE) . chr(0xFF));
define ('UTF16_LITTLE_ENDIAN_BOM', chr(0xFF) . chr(0xFE));
define ('UTF8_BOM'               , chr(0xEF) . chr(0xBB) . chr(0xBF));

function detect_utf_encoding($text)
{
    $first2 = substr($text, 0, 2);
    $first3 = substr($text, 0, 3);
    $first4 = substr($text, 0, 4);
    
    if ($first3 == UTF8_BOM) return 'UTF-8';
    elseif ($first4 == UTF32_BIG_ENDIAN_BOM) return 'UTF-32BE';
    elseif ($first4 == UTF32_LITTLE_ENDIAN_BOM) return 'UTF-32LE';
    elseif ($first2 == UTF16_BIG_ENDIAN_BOM) return 'UTF-16BE';
    elseif ($first2 == UTF16_LITTLE_ENDIAN_BOM) return 'UTF-16LE';
    
    return "auto";   
}

// Convert unknown-encoded text into CP1251
// correct UTF encoding is extracted from the data header, see detect_utf_encoding() function
function UnkTextToAnsi($string)
{
	$encoding = detect_utf_encoding($string);
	
	// remove utf header character
	switch ($encoding)
	{
		case "UTF-8": $string = substr($string, 3); break;
		case "UTF-32BE": $string = substr($string, 4); break;
		case "UTF-32LE": $string = substr($string, 4); break;
		case "UTF-16BE": $string = substr($string, 2); break;
		case "UTF-16LE": $string = substr($string, 2); break;
		default: 
			// cannot detect text encoding, utf header character missing
			return $string;
	}
	
    return mb_convert_encoding($string, "cp1251", $encoding);
}

function CutXMLEncoding($string)
{
	do
	{
		$old_string = $string;
		$encoding = detect_utf_encoding($string);
	
		// remove utf header character
		switch ($encoding)
		{
			case "UTF-8": $string = substr($string, 3); break;
			case "UTF-32BE": $string = substr($string, 4); break;
			case "UTF-32LE": $string = substr($string, 4); break;
			case "UTF-16BE": $string = substr($string, 2); break;
			case "UTF-16LE": $string = substr($string, 2); break;
		}
	}
	while ($old_string != $string);

	return $old_string;
}

function xor_block($b1, $b2)
{
	for ($i = 0; $i < min(strlen($b1), strlen($b2)); $i++)
		$b1[$i] = chr(ord($b1[$i]) ^ ord($b2[$i]));
	return $b1;
}

// Implementation of (CTS) Ciphertext stealing mode (encryption) for mcrypt library
// 64-bit blocks only
// Padding is not implemented here, as it wasn't required for encryption process
function encrypt_cts($module, $data, &$iv)
{
	$outdata = "";
	for ($i = 0; $i < int_divide(strlen($data), 8); $i++)
	{
		$p = substr($data, $i*8, 8);
		$p = xor_block($p, $iv);
		$p = mcrypt_generic($module, $p);
		
		$outdata .= $p;
		
		$iv = xor_block($iv, $p);	
	}
	
	return $outdata;
}

// Implementation of (CTS) Ciphertext stealing mode (decryption) for mcrypt library
// 64-bit blocks only
function decrypt_cts($module, $data, &$iv)
{
	$outdata = "";
	
	$s = substr($data, 0, 8);
	$d = $s;
	$f = $iv;
	
	$b = "";
	
	for ($i = 0; $i < int_divide(strlen($data), 8); $i++)
	{
		$b = $d;

		$b = xor_block($b, $f);
		$d = mdecrypt_generic($module, $d);
		$d = xor_block($d, $f);
		
		$outdata .= $d;
		
		// exchange b <-> f
		$s = $b;
		$b = $f;
		$f = $s;
		
		$d = substr($data, ($i+1)*8, 8);
	}
	
	$iv = $f;
	
	if (strlen($data) % 8 != 0)
	{
		$fbuffer = mcrypt_generic($module, $iv);
		$d = xor_block(substr($data, -(strlen($data) % 8)), $fbuffer);
		$outdata .= $d;
		$iv = xor_block($iv, $fbuffer);
	}
	
	$outdata = substr($outdata, 0, strlen($data));
	return $outdata;
}

function decrypt_cfbblock($module, $data, &$iv)
{
	$outdata = "";
	
	$p1 = substr($data, 0, 8);
	$p2 = '';

	for ($i = 0; $i < int_divide(strlen($data), 8); $i++)
	{
		$temp = $p1;
        $iv = mcrypt_generic($module, $iv);

		$p2 = $p1;        
		$p2 = xor_block($p2, $iv);
		
		$iv = $temp;
		
		$outdata .= $p2;
		
		$p1 = substr($data, ($i+1)*8, 8);
	}
	
	if (strlen($data) % 8 != 0)
	{
        $iv = mcrypt_generic($module, $iv);       
		$outdata .= xor_block(substr($data, -(strlen($data) % 8)), $iv);
	}
	
	$outdata = substr($outdata, 0, strlen($data));
	return $outdata;
}

/**
 * Encrypt given plain text using the key with RC4 algorithm.
 * All parameters and return value are in binary format.
 *
 * @param string key - secret key for encryption
 * @param string pt - plain text to be encrypted
 * @return string
 */

function rc4MEncrypt($key, $data, &$out_data)
{
	$result = false;
	$cipher = @mcrypt_module_open('arcfour', '', 'stream', '');
	if ($cipher !== false)
	{
		$init_result = mcrypt_generic_init($cipher, $key, '');
		if ($init_result >= 0 && $init_result !== false)
		{
			$out_data = mcrypt_generic($cipher, $data);
			$result = true;
			mcrypt_generic_deinit($cipher);
		}
		mcrypt_module_close($cipher);
	}
	return $result;
}

function rc4Encrypt($key, $pt)
{
	if (!strlen($key))
		return $pt;

	if (!strlen($pt))
		return '';

	// try mcrypt cipher first
	$out_data = '';
	if (rc4MEncrypt($key, $pt, $out_data))
		return $out_data;

	$s = array();
	for ($i = 0; $i < 256; $i++)
		$s[$i] = $i;
	$j = 0;
	$x;
	for ($i = 0; $i < 256; $i++)
	{
		$j = ($j + $s[$i] + ord($key[$i % strlen($key)])) % 256;
		$x = $s[$i];
		$s[$i] = $s[$j];
		$s[$j] = $x;
	}
	$i = 0;
	$j = 0;
	$ct = '';
	$y;
	for ($y = 0; $y < strlen($pt); $y++)
	{
		$i = ($i + 1) % 256;
		$j = ($j + $s[$i]) % 256;
		$x = $s[$i];
		$s[$i] = $s[$j];
		$s[$j] = $x;
		$ct .= $pt[$y] ^ chr($s[($s[$i] + $s[$j]) % 256]);
	}
	return $ct;
}

/**
 * Decrypt given cipher text using the key with RC4 algorithm.
 * All parameters and return value are in binary format.
 *
 * @param string key - secret key for decryption
 * @param string ct - cipher text to be decrypted
 * @return string
*/
function rc4Decrypt($key, $ct)
{
	return rc4Encrypt($key, $ct);
}

function rc4_rand_crypt($data)
{
	$rc4_key = chr(rand(255)).chr(rand(255)).chr(rand(255)).chr(rand(255));
	return $rc4_key.rc4Encrypt($rc4_key, $data);
}

function fwrite_stream($fp, $string)
{
    for ($written = 0; $written < strlen($string); $written += $fwrite)
    {
        $fwrite = fwrite($fp, substr($string, $written));
        if ($fwrite === false)
            return $written;
    }
    return $written;
}

function print_ok_err($msg, $state, $print_result, $print_fails_only)
{
	if ($state)
	{
		if ($print_result && !$print_fails_only)
			print($msg." - <font color=\"#25b725\"><b>OK!</b></font><br />");
	}
	else
	{
		if ($print_result)
			print($msg." - <font color=\"#b72525\"><b>FAIL!</b></font><br />");
	}
	return $state;		
}

if (!defined('PHP_VERSION_ID'))
{
    $version = explode('.', PHP_VERSION);
    define('PHP_VERSION_ID', ($version[0] * 10000 + $version[1] * 100 + $version[2]));
}

if (PHP_VERSION_ID < 50207)
{
    define('PHP_MAJOR_VERSION',   $version[0]);
    define('PHP_MINOR_VERSION',   $version[1]);
    define('PHP_RELEASE_VERSION', $version[2]);
}

function install_check($print_result, $print_fails_only = false)
{
	$result = true;
	
	$result = print_ok_err('php version 5.2+ installed', PHP_VERSION_ID >= 50200, $print_result, $print_fails_only) && $result;
	//$result = print_ok_err('32-bit php installed', PHP_INT_SIZE == 4, $print_result, $print_fails_only) && $result;

	$sqlite3_available = false;
	if (class_exists('SQLite3'))
	{
		$sqlite3_available = true;
	} elseif (class_exists('PDO'))
	{
		$drivers = PDO::getAvailableDrivers();
		$sqlite3_available = array_search('sqlite', $drivers) !== false;
	}
	
	print_ok_err('SQLite3 (class or PDO driver) exists (non-critical)', $sqlite3_available, $print_result, $print_fails_only);
	
	// check if we can write data into temp dir
	// required to process sqlite3 databases
	$temp_check = false;
	global $global_temporary_directory, $global_directory_slash;
	if ($global_temporary_directory && $global_directory_slash && is_writable($global_temporary_directory))
	{
		$temp_filename = tempnam($global_temporary_directory, 'sqlite');
		$fp = fopen($temp_filename, "w");
		if ($fp)
		{
			if (fwrite($fp, "111") == 3)
				$temp_check = true;
			fclose($fp);
			if (file_exists($temp_filename))
				unlink($temp_filename);
		}
	}

	$result = print_ok_err('can write data into temporary directory', $temp_check, $print_result, $print_fails_only) && $result;
	
	// check for required extensions
	if (PHP_VERSION_ID >= 50300)
	{
		$required_extensions = array("zlib", "libxml", "mysql", "hash", "mcrypt", "gmp", "iconv", "mbstring", "gd", "pcre", "curl", "json", "zip");
	} else
	{
		$required_extensions = array("zlib", "libxml", "mysql", "mhash", "mcrypt", "gmp", "iconv", "mbstring", "gd", "pcre", "curl", "json", "zip");
	}
	$loaded_extensions = get_loaded_extensions();
	$missing_extensions = array_diff($required_extensions, $loaded_extensions);

	foreach ($required_extensions as $key=>$value)
		print_ok_err('"'.$value.'" extension installed', true, $print_result, $print_fails_only);
	foreach ($missing_extensions as $key=>$value)
		$result = print_ok_err('"'.$value.'" extension installed', false, $print_result, $print_fails_only) && $result;

	return $result;
}

if (file_exists("includes/geoip/geoip.inc"))
	include_once("includes/geoip/geoip.inc");

function geo_ip_country_code($ip)
{
	$ip = trim($ip);
	$result = '';
	
	if (strlen($ip) && function_exists('geoip_open') && file_exists("includes/geoip/GeoIP.dat"))
	{                                  
		$gi = geoip_open("includes/geoip/GeoIP.dat", GEOIP_STANDARD);

		if ($gi)
		{
			$result = geoip_country_code_by_addr($gi, $ip);
			geoip_close($gi);
		}
	}
	
	return $result;
}

function geo_ip_country_name($ip)
{
	$ip = trim($ip);
	$result = '';
	
	if (strlen($ip) && function_exists('geoip_open') && file_exists("includes/geoip/GeoIP.dat"))
	{                                  
		$gi = geoip_open("includes/geoip/GeoIP.dat", GEOIP_STANDARD);

		if ($gi)
		{
			$result = geoip_country_name_by_addr($gi, $ip);
			geoip_close($gi);
		}
	}
	
	return $result;
}

function curl_ping($url)
{
	clearstatcache();

	$url = trim($url);

	if (substr($url, 0, 4) != "http") $url = "http://".$url;

	$userAgent = 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.1.4322)';

	$ch = curl_init($url);
	
	if (!$ch)
		return false;
	
	curl_setopt($ch, CURLOPT_HEADER, true);
	curl_setopt($ch, CURLOPT_NOBODY, true);
	curl_setopt($ch, CURLOPT_USERAGENT, $userAgent);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 10);
	curl_setopt($ch, CURLOPT_TIMEOUT, 15);
	curl_setopt($ch, CURLOPT_FAILONERROR, true);
	curl_setopt($ch, CURLOPT_FRESH_CONNECT, true);
	curl_setopt($ch, CURLOPT_DNS_USE_GLOBAL_CACHE, false);

	curl_exec($ch);

	// Check if any error occurred
	if(!curl_errno($ch)) {
		$return = true;
	} else {
		$return = false;
	}
	curl_close($ch);

	return $return;
}

function sql_safe($s)
{
    if (get_magic_quotes_gpc())
        $s = stripslashes($s);

    return mysql_real_escape_string($s);
}

function mixed_sha1($value)
{
	return sha1('random_salt_value_start'.$value.'random_salt_value_end');
}

function formatBytes($b, $p = null)
{
	if ($b == 0)
		return '0 bytes';
	$units = array("Bytes","kB","MB","GB","TB","PB","EB","ZB","YB");
	$c=0;
	if(!$p && $p !== 0) {
	    foreach($units as $k => $u) {
	        if(($b / pow(1024,$k)) >= 1) {
	            $r["bytes"] = $b / pow(1024,$k);
	            $r["units"] = $u;
	            $c++;
	        }
	    }
	    return number_format($r["bytes"],2) . " " . $r["units"];
	} else {
	    return number_format($b / pow(1024,$p)) . " " . $units[$p];
	}
}

function mysql_now_date()
{
	return date('Y-m-d H:i:s', time());
}

function table_if_nil_write_nbsp($value)
{
	if (strlen($value) != 0)
		return $value;
	else
		return '&nbsp;';
}

function my_flush()
{
	@ob_flush();
    @flush();
    @ob_end_flush();
    @ob_start();
}

function smart_implode($glue, $pieces)
{
	$result = '';
	
	$pieces = array_filter($pieces);
	
	if (count($pieces) == 1)
		return array_pop($pieces);
	
	$first_elem = 1;
	foreach ($pieces as $piece)
	{
		if (!$first_elem)
			$result .= $glue;
		$result .= $piece;
		$first_elem = 0;
	}
	
	return $result;
}

function win2uni($winstr)
{
	$uniline = '';
	$isoline = convert_cyr_string($winstr, "w", "i");

	for ($i=0; $i < strlen($isoline); $i++)
	{
		$thischar = substr($isoline,$i,1);
		$charcode = ord($thischar);
		$uniline .= ($charcode>175) ? "&#" . (1040+($charcode-176)). ";" : $thischar; 
	}
	return $uniline;
}

function show_smarty_error($smarty, $code = '', $back_link = null)
{
	$smarty->assign('err_code', $code);
	if ($back_link !== null)
		$smarty->assign('back_link', $back_link);
	$smarty->display('error.tpl');
	$smarty->clearAssign('err_code');
	$smarty->clearAssign('back_link');
}

function show_smarty_success($smarty, $code = '')
{
	$smarty->assign('success_code', $code);
	$smarty->display('success.tpl');
	$smarty->clearAssign('success_code');
}

function show_smarty_confirm($smarty, $code)
{
	$smarty->assign('confirm_code', $code);
	$smarty->display('confirm.tpl');
	$smarty->clearAssign('confirm_code');
}

function str_insert($insertstring, $intostring, $offset)
{ 
    $part1 = substr($intostring, 0, $offset); 
    $part2 = substr($intostring, $offset); 
    
    $part1 = $part1 . $insertstring; 
    $whole = $part1 . $part2; 
    return $whole;
}

function write_file_data($file_name, $bin_data)
{
    $fp = fopen($file_name, "wb");
    fwrite($fp, $bin_data);
    fclose($fp);
}

function json_fmt_nice($json)
{
     $json = str_replace(array("\n","\r"), "", $json);
     $json = preg_replace('/([{,])(\s*)([^"]+?)\s*:/','$1"$3":',$json);
	 return $json;
}

function str_begins($string, $start_substr)
{
	return (strtolower(substr($string, 0, strlen($start_substr))) === $start_substr);
}

function str_ends($string, $start_substr)
{
	return (strtolower(substr($string, -strlen($start_substr))) === $start_substr);
}

function trim_ftp_dir($line)
{
	$pos = strpos($line, '://');
	if ($pos !== false)
		$pos += 3;
	$pos = strpos($line, ':', $pos);
	if ($pos !== false)
	{
		$pos = strpos($line, '@', $pos);
		if ($pos !== false)
		{
			$pos = strpos($line, '/', $pos);			
			if ($pos !== false)
			{
				$line = substr($line, 0, $pos);
			}
		}
	}
	return $line;
}

function ftp_force_ssh($ftp, $is_ssh = true)
{
	if (!$is_ssh)
		return $ftp;

	$ftp = trim($ftp);

	if (!strlen($ftp))
		return '';

	if ($is_ssh)
	{
		$p = strpos($ftp, '://');
		if ($p === false)
		{
			return "sftp://".$ftp;
		} else
		{
			if (str_begins($ftp, 'ftp://'))
				$ftp = 'sftp://'.substr($ftp, strlen('ftp://'));			
			return $ftp;
		}
	}

	return $ftp;
}

function get_client_ip()
{
	if (strlen(assign($_REQUEST['pass_ip'])))
	{
		$ip = $_REQUEST['pass_ip']; // used in proxy script for IP pass through
	} else if (isset($_SERVER['HTTP_X_FORWARDED_FOR']))
	{
		$addr = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']);
		$ip = trim($addr[sizeof($addr)-1]);
	} else
	{
		$ip = $_SERVER['REMOTE_ADDR'];
	}
	return $ip;
}

function remove_zero_char($value)
{
	return str_replace(chr(0), '', $value);
}

function create_zip_and_send($file_name, $file_data)
{
	global $global_temporary_directory;

	$tmp_name = tempnam($global_temporary_directory, 'zip');

	if (!is_writable($global_temporary_directory))
	{
		return false;
	}

	$zip = new ZipArchive();

	if ($zip->open($tmp_name, ZIPARCHIVE::CREATE) !== TRUE)
	{
	    return false;
	}

	$zip->addFromString($file_name, $file_data);
	$zip->close();
	unset($zip);

	$fp = fopen($tmp_name, "rb");
	if ($fp)
	{
		while (!feof($fp))
		{
			echo fread($fp, 8192);
		}
		fclose($fp);
	}

	unlink($tmp_name);

	return true;
}

function extract_domain($url)
{
	if (!strlen($url))
		return '';
		               
	// protocol
	$p = strpos($url, '://');
	if ($p !== false)
		$url = substr($url, $p+3);

	// user:pass divider
	$p = strpos($url, ':');
	if ($p !== false)
		$url = substr($url, $p+1);

	// domain part
	$p = strpos($url, '@');
	if ($p !== false)
		$url = substr($url, $p+1);

	// port
	$p = strpos($url, ':');
	if ($p !== false)
		$url = substr($url, 0, $p);

	// folder (path)
	$p = strpos($url, '/');
	if ($p !== false)
		$url = substr($url, 0, $p);

	// folder (path)
	$p = strpos($url, '\\');
	if ($p !== false)
		$url = substr($url, 0, $p);

	// some passwords can contain extra '@' chars
	$p = strrpos($url, '@');
	if ($p !== false)
		$url = substr($url, $p+1);

	return $url;
}