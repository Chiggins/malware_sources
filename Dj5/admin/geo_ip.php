<?php
# Geo IP
class geo_ip {
	static $COUNTRY_CODES = array("?", "AP", "EU", "AD", "AE", "AF", "AG", "AI", "AL", "AM", "AN", "AO", "AQ", "AR", "AS", "AT", "AU", "AW", "AZ", "BA", "BB", "BD", "BE", "BF", "BG", "BH", "BI", "BJ", "BM", "BN", "BO", "BR", "BS", "BT", "BV", "BW", "BY", "BZ", "CA", "CC", "CD", "CF", "CG", "CH", "CI", "CK", "CL", "CM", "CN", "CO", "CR", "CU", "CV", "CX", "CY", "CZ", "DE", "DJ", "DK", "DM", "DO", "DZ", "EC", "EE", "EG", "EH", "ER", "ES", "ET", "FI", "FJ", "FK", "FM", "FO", "FR", "FX", "GA", "GB", "GD", "GE", "GF", "GH", "GI", "GL", "GM", "GN", "GP", "GQ", "GR", "GS", "GT", "GU", "GW", "GY", "HK", "HM", "HN", "HR", "HT", "HU", "ID", "IE", "IL", "IN", "IO", "IQ", "IR", "IS", "IT", "JM", "JO", "JP", "KE", "KG", "KH", "KI", "KM", "KN", "KP", "KR", "KW", "KY", "KZ", "LA", "LB", "LC", "LI", "LK", "LR", "LS", "LT", "LU", "LV", "LY", "MA", "MC", "MD", "MG", "MH", "MK", "ML", "MM", "MN", "MO", "MP", "MQ", "MR", "MS", "MT", "MU", "MV", "MW", "MX", "MY", "MZ", "NA", "NC", "NE", "NF", "NG", "NI", "NL", "NO", "NP", "NR", "NU", "NZ", "OM", "PA", "PE", "PF", "PG", "PH", "PK", "PL", "PM", "PN", "PR", "PS", "PT", "PW", "PY", "QA", "RE", "RO", "RU", "RW", "SA", "SB", "SC", "SD", "SE", "SG", "SH", "SI", "SJ", "SK", "SL", "SM", "SN", "SO", "SR", "ST", "SV", "SY", "SZ", "TC", "TD", "TF", "TG", "TH", "TJ", "TK", "TM", "TN", "TO", "TP", "TR", "TT", "TV", "TW", "TZ", "UA", "UG", "UM", "US", "UY", "UZ", "VA", "VC", "VE", "VG", "VI", "VN", "VU", "WF", "WS", "YE", "YT", "YU", "ZA", "ZM", "ZR", "ZW", "A1", "A2", "O1");
	
	static $COUNTRY_NAMES = array("?", "Asia/Pacific Region", "Europe", "Andorra", "United Arab Emirates", "Afghanistan", "Antigua and Barbuda", "Anguilla", "Albania", "Armenia", "Netherlands Antilles", "Angola", "Antarctica", "Argentina", "American Samoa", "Austria", "Australia", "Aruba", "Azerbaijan", "Bosnia and Herzegovina", "Barbados", "Bangladesh", "Belgium", "Burkina Faso", "Bulgaria", "Bahrain", "Burundi", "Benin", "Bermuda", "Brunei Darussalam", "Bolivia", "Brazil", "Bahamas", "Bhutan", "Bouvet Island", "Botswana", "Belarus", "Belize", "Canada", "Cocos (Keeling) Islands", "Congo, The Democratic Republic of the", "Central African Republic", "Congo", "Switzerland", "Cote Divoire", "Cook Islands",  "Chile", "Cameroon", "China", "Colombia", "Costa Rica", "Cuba", "Cape Verde", "Christmas Island", "Cyprus", "Czech Republic", "Germany", "Djibouti", "Denmark", "Dominica", "Dominican Republic", "Algeria", "Ecuador", "Estonia", "Egypt", "Western Sahara", "Eritrea", "Spain", "Ethiopia", "Finland", "Fiji", "Falkland Islands (Malvinas)", "Micronesia, Federated States of", "Faroe Islands", "France", "France, Metropolitan", "Gabon", "United Kingdom", "Grenada", "Georgia", "French Guiana", "Ghana", "Gibraltar", "Greenland", "Gambia", "Guinea", "Guadeloupe", "Equatorial Guinea", "Greece", "South Georgia and the South Sandwich Islands", "Guatemala", "Guam", "Guinea-Bissau", "Guyana", "Hong Kong", "Heard Island and McDonald Islands", "Honduras", "Croatia", "Haiti", "Hungary", "Indonesia", "Ireland", "Israel", "India", "British Indian Ocean Territory", "Iraq", "Iran", "Iceland", "Italy", "Jamaica", "Jordan", "Japan", "Kenya", "Kyrgyzstan", "Cambodia", "Kiribati", "Comoros", "Saint Kitts and Nevis", "North Korea", "South Korea", "Kuwait", "Cayman Islands", "Kazakhstan", "Lao People's Democratic Republic", "Lebanon", "Saint Lucia", "Liechtenstein", "Sri Lanka", "Liberia", "Lesotho", "Lithuania", "Luxembourg", "Latvia", "Libyan Arab Jamahiriya", "Morocco", "Monaco", "Moldova", "Madagascar", "Marshall Islands", "Macedonia", "Mali", "Myanmar", "Mongolia", "Macau", "Northern Mariana Islands", "Martinique", "Mauritania", "Montserrat", "Malta", "Mauritius", "Maldives", "Malawi", "Mexico", "Malaysia", "Mozambique", "Namibia", "New Caledonia", "Niger", "Norfolk Island", "Nigeria", "Nicaragua", "Netherlands", "Norway", "Nepal", "Nauru", "Niue", "New Zealand", "Oman", "Panama", "Peru", "French Polynesia", "Papua New Guinea", "Philippines", "Pakistan", "Poland", "Saint Pierre and Miquelon", "Pitcairn Islands", "Puerto Rico", "Palestinian Territory, Occupied", "Portugal", "Palau", "Paraguay", "Qatar", "Reunion", "Romania", "Russia", "Rwanda", "Saudi Arabia", "Solomon Islands", "Seychelles", "Sudan", "Sweden", "Singapore", "Saint Helena", "Slovenia", "Svalbard and Jan Mayen", "Slovakia", "Sierra Leone", "San Marino", "Senegal", "Somalia", "Suriname", "Sao Tome and Principe", "El Salvador", "Syria", "Swaziland", "Turks and Caicos Islands", "Chad", "French Southern Territories", "Togo", "Thailand", "Tajikistan", "Tokelau", "Turkmenistan", "Tunisia", "Tonga", "East Timor", "Turkey", "Trinidad and Tobago", "Tuvalu", "Taiwan", "Tanzania, United Republic of", "Ukraine", "Uganda", "United States Minor Outlying Islands", "USA", "Uruguay", "Uzbekistan", "Holy See (Vatican City State)", "Saint Vincent and the Grenadines", "Venezuela", "Virgin Islands, British", "Virgin Islands, U.S.", "Vietnam", "Vanuatu", "Wallis and Futuna", "Samoa", "Yemen", "Mayotte", "Bosnia and Herzegovina", "South Africa", "Zambia", "Democratic Republic Congo", "Zimbabwe", "Anonymous Proxy","Satellite Provider","Other");
	
	const STANDARD = 0;
	const MEMORY_CACHE = 1;
	const SHARED_MEMORY = 2;
	const COUNTRY_BEGIN = 16776960;
	const STATE_BEGIN_REV0 = 16700000;
	const STATE_BEGIN_REV1 = 16000000;
	const STRUCTURE_INFO_MAX_SIZE = 20;
	const DATABASE_INFO_MAX_SIZE = 100;
	const COUNTRY_EDITION = 106;
	const REGION_EDITION_REV0 = 112;
	const REGION_EDITION_REV1 = 3;
	const CITY_EDITION_REV0 = 111;
	const CITY_EDITION_REV1 = 2;
	const ORG_EDITION = 110;
	const SEGMENT_RECORD_LENGTH = 3;
	const STANDARD_RECORD_LENGTH = 3;
	const ORG_RECORD_LENGTH = 4;
	const MAX_RECORD_LENGTH = 4;
	const MAX_ORG_RECORD_LENGTH = 300;
	const FULL_RECORD_LENGTH = 50;
	const US_OFFSET = 1;
	const CANADA_OFFSET = 677;
	const WORLD_OFFSET = 1353;
	const FIPS_RANGE = 360;
	const SHM_KEY = 0x4f415401;
	
	private $flags = 0;
	private $filehandle;
	private $memoryBuffer;
	private $databaseType;
	private $databaseSegments;
	private $recordLength;
	private $shmid;
	private static $instances = array();
	
	function __construct($filename = null, $flags = null) {
		if ($filename !== null) {
			$this->open($filename, $flags);
		}
		self::$instances[$filename] = $this;
	}
	static function getInstance($filename = null, $flags = null) {
		if (!isset(self::$instances[$filename])) {
			self::$instances[$filename] = new geo_ip($filename, $flags);
		}
		return self::$instances[$filename];
	}
	function open($filename, $flags = null) {
		if ($flags !== null) {
			$this->flags = $flags;
		}
		if ($this->flags & self::SHARED_MEMORY) {
			$this->shmid = @shmop_open(self::SHM_KEY, "a", 0, 0);
			if ($this->shmid === false) {
				$this->loadSharedMemory($filename);
				$this->shmid = @shmop_open(self::SHM_KEY, "a", 0, 0);
				if ($this->shmid === false) {
					throw new Exception("Unable to open shared memory at key: " . dechex(self::SHM_KEY));
				}
			}
		} else {
			$this->filehandle = fopen($filename, "rb");
			if (!$this->filehandle) {
				throw new Exception("Unable to open file: $filename");
			}
			if ($this->flags & self::MEMORY_CACHE) {
				$s_array = fstat($this->filehandle);
				$this->memoryBuffer = fread($this->filehandle, $s_array['size']);
			}
		}
		$this->setupSegments();
	}
	private function loadSharedMemory($filename) {
		$fp = fopen($filename, "rb");
		if (!$fp) {
			throw new Exception("Unable to open file: $filename");
		}
		$s_array = fstat($fp);
		$size = $s_array['size'];
		if ($shmid = shmop_open(self::SHM_KEY, "w", 0, 0)) {
			shmop_delete ($shmid);
			shmop_close ($shmid);
		}
		$shmid = shmop_open(self::SHM_KEY, "c", 0644, $size);
		shmop_write($shmid, fread($fp, $size), 0);
		shmop_close($shmid);
		fclose($fp);
	}
	private function setupSegments() {
		$this->databaseType = self::COUNTRY_EDITION;
		$this->recordLength = self::STANDARD_RECORD_LENGTH;
		if ($this->flags & self::SHARED_MEMORY) {
			$offset = shmop_size($this->shmid) - 3;
			for ($i = 0; $i < self::STRUCTURE_INFO_MAX_SIZE; $i++) {
				$delim = shmop_read($this->shmid, $offset, 3);
				$offset += 3;
				if ($delim == (chr(255).chr(255).chr(255))) {
					$this->databaseType = ord(shmop_read($this->shmid, $offset, 1));
					$offset++;
					if ($this->databaseType === self::REGION_EDITION_REV0) {
						$this->databaseSegments = self::STATE_BEGIN_REV0;
					} elseif ($this->databaseType === self::REGION_EDITION_REV1) {
						$this->databaseSegments = self::STATE_BEGIN_REV1;
					} elseif (($this->databaseType === self::CITY_EDITION_REV0) || ($this->databaseType === self::CITY_EDITION_REV1) || ($this->databaseType === self::ORG_EDITION)) {
						$this->databaseSegments = 0;
						$buf = shmop_read($this->shmid, $offset, self::SEGMENT_RECORD_LENGTH);
						for ($j = 0; $j < self::SEGMENT_RECORD_LENGTH; $j++) {
							$this->databaseSegments += (ord($buf[$j]) << ($j * 8));
						}
						if ($this->databaseType === self::ORG_EDITION) {
							$this->recordLength = self::ORG_RECORD_LENGTH;
						}
					}
					break;
				} else {
					$offset -= 4;
				}
			}
			if ($this->databaseType == self::COUNTRY_EDITION) {
				$this->databaseSegments = self::COUNTRY_BEGIN;
			}
		} else {
			$filepos = ftell($this->filehandle);
			fseek($this->filehandle, -3, SEEK_END);
			for ($i = 0; $i < self::STRUCTURE_INFO_MAX_SIZE; $i++) {
				$delim = fread($this->filehandle, 3);
				if ($delim == (chr(255).chr(255).chr(255))) {
					$this->databaseType = ord(fread($this->filehandle,1));
					if ($this->databaseType === self::REGION_EDITION_REV0) {
						$this->databaseSegments = self::STATE_BEGIN_REV0;
					} elseif($this->databaseType === self::REGION_EDITION_REV1) { 
						$this->databaseSegments = self::STATE_BEGIN_REV1;
					} elseif ($this->databaseType === self::CITY_EDITION_REV0 || $this->databaseType === self::CITY_EDITION_REV1 || $this->databaseType === self::ORG_EDITION) {
						$this->databaseSegments = 0;
						$buf = fread($this->filehandle, self::SEGMENT_RECORD_LENGTH);
						for ($j = 0; $j < self::SEGMENT_RECORD_LENGTH; $j++) {
							$this->databaseSegments += (ord($buf[$j]) << ($j * 8));
						}
						if ($this->databaseType === self::ORG_EDITION) {
							$this->recordLength = self::ORG_RECORD_LENGTH;
						}
					}
					break;
				} else {
					fseek($this->filehandle, -4, SEEK_CUR);
				}
			}
			if ($this->databaseType === self::COUNTRY_EDITION) {
				$this->databaseSegments = self::COUNTRY_BEGIN;
			}
			fseek($this->filehandle, $filepos, SEEK_SET);
		}
	}
	private function lookupCountryId($addr) {
		$ipnum = ip2long($addr);
		if ($ipnum === false) {
			throw new Exception("Invalid IP address: " . var_export($addr, true));
		}
		if ($this->databaseType !== self::COUNTRY_EDITION) {
			throw new Exception("Invalid database type; lookupCountry*() methods expect Country database.");
		}
		return $this->seekCountry($ipnum) - self::COUNTRY_BEGIN;
	}
	function lookupCountryCode($addr) {
		return self::$COUNTRY_CODES[$this->lookupCountryId($addr)];
	}
	function lookupCountryName($addr) {
		return self::$COUNTRY_NAMES[$this->lookupCountryId($addr)];
	}
	private function seekCountry($ipnum) {
		$offset = 0;
		for ($depth = 31; $depth >= 0; --$depth) {
			if ($this->flags & self::MEMORY_CACHE) {
				$buf = substr($this->memoryBuffer, 2 * $this->recordLength * $offset, 2 * $this->recordLength);
			} elseif ($this->flags & self::SHARED_MEMORY) {
				$buf = shmop_read ($this->shmid, 2 * $this->recordLength * $offset, 2 * $this->recordLength );
			} else {
				if (fseek($this->filehandle, 2 * $this->recordLength * $offset, SEEK_SET) !== 0) {
					throw new Exception("fseek failed");
				}
				$buf = fread($this->filehandle, 2 * $this->recordLength);
			}
			$x = array(0,0);
			for ($i = 0; $i < 2; ++$i) {
				for ($j = 0; $j < $this->recordLength; ++$j) {
					$x[$i] += ord($buf[$this->recordLength * $i + $j]) << ($j * 8);
				}
			}
			if ($ipnum & (1 << $depth)) {
				if ($x[1] >= $this->databaseSegments) {
					return $x[1];
				}
				$offset = $x[1];
			} else {
				if ($x[0] >= $this->databaseSegments) {
					return $x[0];
				}
				$offset = $x[0];
			}
		}
		throw new Exception("Error traversing database - perhaps it is corrupt?");
	}
}
?>