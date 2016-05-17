<?php
/* Utility */
function http_response($code, $msg, $body){
	if (!headers_sent())
		header("HTTP/1.1 $code $msg");
	print $body;
	return false;
	}
function http_error($code, $msg, $body){
	return http_response($code, $msg, "ERROR: $body");
	}
function http_error400($body){
	return http_response(400, 'Bad request', "ERROR: $body");
	}

class ActionException extends Exception {}

# TODO: PATH_INFO splitters
# TODO: regexp matchers
# TODO: URL generation
# TODO: formatters: xml, template, 

class Router {
	const CONTROLLER_SUFFIX = 'Controller';
	const ACTION_PREFIX = 'action';
	
	# TODO: inherit from a base controller
	# TODO: AJAX helpers (especially errors!): connectors. Maybe, AJAXcontroller base class?
	# TODO: GET/POST/... handlers
	# TODO: pre/port-request wrappers
	
	/** Create a router for ClassName
	 * @param string $class	Name of the class
	 * @return Router
	 * @throws NoControllerRouteException
	 */
	static function forClass($controller){
		$className = $controller.self::CONTROLLER_SUFFIX;
		if (!class_exists($className))
			throw new NoControllerRouteException($controller);
		return new Router(new $className());
		}
	
	/** Create a router object for a Controller class
	 * @param string	$class	Controller class name
	 */
	function __construct($class){
		$this->controller = new $class();
		}
	
	/** Get the list of actions
	 */
	function actions(){
		$ret = array();
		$c = new ReflectionClass($this->controller);
		foreach ($c->getMethods(ReflectionMethod::IS_PUBLIC) as $method){
			$ret[ $method->name ] = (string)$method; # TODO: works?!
			}
		return $ret;
		}
	
	/** Route the request using the Controller
	 * @param string	$method	Method of the class to call
	 * @param mixed[]	$params	The provided parameters
	 * @return array(ReflectionMethod, mixed[])
	 * @throws NoMethodRouteException
	 * @throws ParamRequiredRouteException
	 * @throws ShouldBeArrayRouteException
	 */
	function route($action, $params){
		# Get the method to invoke
		$methodName = self::ACTION_PREFIX.$action;
		if (!method_exists($this->controller, $methodName))
			throw new NoMethodRouteException(get_class($this->controller).'::'.$action);
		$method = new ReflectionMethod($this->controller, $methodName);
		# Check & collect the arguments
		$args = array();
		foreach($method->getParameters() as $p){
			if (!isset($params[$p->name])){
				// If param is not set - check whether it's required
				if ($p->isOptional())
					$args[] = $p->getDefaultValue();
					else
					throw new ParamRequiredRouteException($p->name);
				} else {
				// Set parameter: check if is array
				if ($p->isArray() && !is_array($params[$p->name]))
					throw new ShouldBeArrayRouteException($p->name);
				$args[] = $params[$p->name];
				}
			}
		
		# Invoke the method
		return array($method, $args);
		}
	
	/** Route the request && invoke the method */
	function invoke($action, $params){
		list($method, $args) = $this->route($action, $params);
		return $method->invokeArgs( $this->controller, $args );
		}
	}

abstract class RouteException extends Exception {}
class NoControllerRouteException extends RouteException {}
class NoMethodRouteException extends RouteException {}
class ParamRequiredRouteException extends RouteException {}
class ShouldBeArrayRouteException extends RouteException {}




function XMLdata($data, $rootNodeName = 'data', $xml=null){
	ini_set ('zend.ze1_compatibility_mode', 0); # turn off SimpleXML complains
	if ($xml == null)
		$xml = simplexml_load_string("<?xml version='1.0' encoding='utf-8'?><$rootNodeName />");
	if (!is_array($data))
		$xml->addChild('scalar', $data);
		else
		foreach($data as $key => $value){
			$keystr = is_numeric($key) ? 'key' : $key; # No numeric keys
			#$key = preg_replace('/[^a-z0-9_:-]/i', '', $key); # key format
			if (is_array($value)){ # deeper!
				$node = $xml->addChild($keystr);
				XMLdata($value, $rootNodeName, $node); # recursive
				} else  {
				$value = htmlentities($value);
				$node = $xml->addChild($keystr,$value);
				}
			if (is_numeric($key))
				$node->addAttribute('i', $key);
			}
	return $xml;
	}
