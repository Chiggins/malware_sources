<?php
# TODO: Clicksort: multisort (primary, secondary)
# TODO: Filters: checkbox, radio, text, range

/** Clicksort: helper for creating clicksort links
 */
class Clicksort {

	protected $multisort;

	/** Init clicksort
	 * @param bool $multisort Allow sorting by multiple fields (TODO)
	 */
	function __construct($multisort = false){
		$this->multisort = $multisort;
	}

	/** The current sort configuration read from the URL
	 * array( field =>
	 * @var string[]
	 */
	protected $config = array();

	/** Load the current sort configuration
	 * @param string $config Sorting configuration string: 'field{+|-}[,...]'
	 * @param string $default Default sorting configuration (applied if nothing selected by the user)
	 */
	function config($config, $default = ''){
		if ($this->multisort || empty($config))
			$config = $default.','.$config;
		# Parse & read the configuration
		foreach(explode(',', $config) as $order => $sort)
			if (preg_match('~^(\w+)([+-])$~iS', $sort, $m)){
				list(, $field_name, $direction) = $m;
				# Configure the sorter
				if (isset($this->fields[$field_name])){
					$field = $this->fields[$field_name];
					$field->direction = $direction;
					$field->order = $order;
				}
			}
		# Sort the fields
		uasort($this->fields, array($this, '_fields_cmp'));
	}

	/** The registered sorters
	 * @var _Clicksort_Field[]
	 */
	protected $fields = array();

	/** Quick create a new field
	 * By default, $title = $field_name, $expression = "`$field_name`"
	 * @return _Clicksort_Field
	 */
	function addField($field_name, $default_direction = '+', $expression = null){
		# Defaults
		if (is_null($expression))
			$expression = "`$field_name`";
		$name = ucwords(strtr($field_name, '_-', '  '));
		# Sorter
		$field = new _Clicksort_Field($field_name, $name, $expression, $default_direction);
		$this->fields[$field_name] = $field;
		# Return
		return $field;
	}

	/** Is the sorting enabled for this field in the current configuration?
	 * @param $field_name
	 * @return bool
	 */
	function field_enabled($field_name){
		return $this->fields[$field_name]->enabled();
	}

	/** Create a configuration with the field toggled (enable/disable)
	 * @param string $field Field name
	 * @return string
	 *
	 * enabled = !is_null($field->direction)
	 * self = $field->field_name == $field_name
	 */
	function field_toggle_url($field_name){
		$url = array();
		foreach($this->fields as $field)
			if (!$this->multisort){
				if ($field->field_name == $field_name)
					$url[] = $field->url(true); # In multisort, column name also toggles the order
			} else {
				if ($field->field_name == $field_name ^ $field->enabled())
					$url[] = $field->url();
			}
		return implode(',', $url);
	}

	/** Create a configuration with the field direction toggled (asc/desc)
	 * @param string $field Field name
	 * @return string
	 */
	function field_dir_toggle_url($field_name){
		$url = array();
		foreach($this->fields as $field)
			if ($field->enabled())
				$url[] = $field->url($field->field_name == $field_name);
		return implode(',', $url);
	}

	/** Create SQL for the 'ORDER BY' clause
	 * @return string
	 */
	function orderBy(){
		$sql = array();
		foreach($this->fields as $field)
			if ($field->enabled())
				$sql[] = $field->expression.' '.($field->direction == '+'? 'ASC' : 'DESC');

		if (empty($sql))
			$sql[] = '1'; # terminator
		return implode(',', $sql);
	}

	/** URL prefix
	 * @var string
	 */
	protected $render_url = '?sort=';

	/** Set the URL prefix for field sort configuration generation (appended)
	 * @param string $url
	 */
	function render_url($url = '?sort='){
		$this->render_url = $url;
	}

	/** Render a link to toggle the field (enable/disable)
	 * @param string $field_name Field name
	 * @param string|null $title Field title
	 * @return string
	 */
	function field_toggle_render($field_name, $title = null){
		$field = $this->fields[$field_name];
		return '<a href="'.$this->render_url.rawurlencode($this->field_toggle_url($field_name)).'" '
				.'class="clicksort-toggle ">'
				.(is_null($title)? $field->title : $title)
				.'</a>';
	}

	/** Render a link to toggle the field direction (asc/desc).
	 * Displays nothing if the field is not enabled in the current config
	 * @param string $url URL prefix
	 * @param string $field_name Field name
	 * @return string
	 */
	function field_dir_toggle_render($field_name){
		$field = $this->fields[$field_name];
		if (!$field->enabled())
			return '';
		$asc = ($field->direction == '+');
		return '<a href="'.$this->render_url.rawurlencode($this->field_dir_toggle_url($field_name)).'" '
				.'class="clicksort-direction clicksort-direction-'.($asc? 'asc' : 'desc').'"> '
				#.($asc ? '↑' : '↓')
				.' </a>';
	}

	/** Render a link to toggle the field and the direction
	 * @param string $url URL prefix
	 * @param string $field_name Field name
	 * @param string|null $title Field title
	 * @return string
	 */
	function field_render($field_name, $title = null){
		return
				$this->field_toggle_render($field_name, $title).
				$this->field_dir_toggle_render($field_name)
				;
	}




	/** Fields sorter function */
	protected function _fields_cmp($a,$b){
		if ($a === $b) return 0;
		if (is_null($a->order)) return +1;
		if (is_null($b->order)) return -1;
		return ($a < $b)? -1 : +1;
	}
}

/** Clicksort: one sorter
 */
class _Clicksort_Field {
	/** Field name (used in the url)
	 * @var string
	 */
	public $field_name;

	/** Field title (printed).
	 * Overridable at the render level.
	 * @var string
	 */
	public $title;

	/** Field expression
	 * @var string
	 */
	public $expression;

	/** The default sort direction: [+-]
	 * Is used when you first enable the clicksort field
	 * @var string
	 */
	public $default_direction;

	function __construct($field_name, $title, $expression, $default_direction){
		$this->field_name = $field_name;
		$this->title = $title;
		$this->expression = $expression;
		$this->default_direction = $default_direction;
	}

	/** Order in which the field appears in the sort configuration
	 * @var int|null
	 */
	public $order = null;

	/** Sort direction in the current configuration
	 * @var string|null
	 */
	public $direction = null;

	/** Is sorting by this field enabled in the current configuration
	 * @return bool
	 */
	function enabled(){
		return !is_null($this->direction);
	}

	/** Get an url component of the field
	 * @param bool $inverse
	 *  FALSE for the current config's direction.
	 *  TRUE to inverse the direction if it's specified in the current config
	 * @return string
	 */
	function url($inverse = false){
		$dir = null;
		if (!is_null($this->direction)){
			$dir = $this->direction;
			if ($inverse)
				$dir = ($dir == '+')? '-' : '+';
		}
		return $this->field_name.(is_null($dir)? $this->default_direction : $dir);
	}
}

/** Render data
 */
class _Clicksort_Field_Render {
	public $direction_asc = '↑';
	public $direction_desc = '↓';
	public $direction_none = '';

	public $field_toggle = '<a href="{url}" class="clicksort-enable">{name}</a> ';
	public $direction_toggle = '<a href="{url}" class="clicksort-direction">{direction}</a> ';
}