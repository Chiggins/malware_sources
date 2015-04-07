<?php

class di {
	
	// храним классы в массиве
	public $objects;


	// регистрируем новый класс
	public function addClass($className, $classObject) {
		$this->objects[$className] = $classObject;
	}

	// вызываем метод объекта класса
	public function callMethod($className, $classMethod, $methodArguments=NULL) {
		// если класс не создан, либо не является объектом то ошибку
		if (!isset($this->objects[$className]) || !is_object($this->objects[$className])) {
			errorHandler(0,$className.' Class not registred (called method: '.$classMethod.' with argument '.$methodArguments,__FILE__,__LINE__);
		} else {
			return $this->objects[$className]->$classMethod($methodArguments);
		}
		
	}

	
}

// Создаем объект класса библиотеки
$di = new di();

?>