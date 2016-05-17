function getXmlHttp() {
	var xmlhttp;
	if (window.XMLHttpRequest) {
		xmlhttp = new XMLHttpRequest( );
	} else if (window.ActiveXObject) {
		xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
		if ( !xmlhttp ){
			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
		}
	}
	return xmlhttp;
}

Array.from = function(ar){ 
	var result = new Array();
	for (var i = 0; i < ar.length; i++)
		result.push(ar[i]);
	return result;
}
function autoJS(src){
	// getting all scripts
	var scripts = Array.from(src.getElementsByTagName('script'));
	for (var i = 0; i < scripts.length; i++) {
		// get current script
		var script = scripts[i];
		
		// clonning the current script
		var jsObj = document.createElement('script');
		if (script.src)
			jsObj.src = script.src;
		if (script.type)
			jsObj.type = script.type;
		jsObj.text = script.text;
		
		// updating ...
		script.parentNode.removeChild(script);
		src.appendChild(jsObj);
	}
}

function ajax_load(url, tag_id, func, funcarg, silent, custlhtml) {
	var elem = document.getElementById(tag_id);
	if (elem) {
		var bckHTML = elem.innerHTML;
		if (!silent) elem.innerHTML = '<table><tr><td valign="center"><img src="img/ajax-loader.gif" alt="ajax-loader"></td><td valign="center"> <i>Loading...</i></td></tr></table>';
		if (custlhtml) elem.innerHTML = custlhtml;
	}
	
	if (url.indexOf('?') != -1)
		url += '&';
	else
		url += '?';
	url += 'rnd=' + Math.random();
	
	var xmlhttp = getXmlHttp();
	xmlhttp.onreadystatechange = function() {
		if (this.readyState == 4) {
			if (this.status == 200) {
				var resp = this.responseText;
				if (elem) {
					elem.innerHTML = resp;
					autoJS(elem);
				}
				if (func) {
					if (tag_id == ':restofunc:') funcarg = resp;
					funcarg ? func(funcarg) : func();
				}
			}
			else {
				if (!silent && elem) elem.innerHTML = '<table><tr><td><img src="img/ajax-error.png" alt="error"></td><td valign="center"> <font class="error">Error</font> : #' + this.status + ' </td></tr></table>';
				else if (custlhtml && elem) elem.innerHTML = bckHTML;
			}
		}
	};
	xmlhttp.open('GET', url, true);
	xmlhttp.send('');
}

function ajax_getInputs (tag_id) {
	var elem = document.getElementById(tag_id);
	var data = '';
	var arr = elem.getElementsByTagName('input');
	for (var i = 0; i < arr.length; i++) {
		if (arr[i].type == 'submit')
			continue;
		var val = arr[i].value;
		if (arr[i].type == 'checkbox') {
			val = arr[i].checked;
			if (!val)
				continue;
		}
        data += arr[i].name + '=' + escape(val) + '&';
	}
	var arr = elem.getElementsByTagName('textarea');
	for (var i = 0; i < arr.length; i++) {
		var val = arr[i].value;
        data += arr[i].name + '=' + escape(val) + '&';
	}
	return data.substr(0, data.length - 1);
}

function ajax_pload(url, pdata, tag_id, loader, callback, cbarg) {
	var elem = document.getElementById(tag_id);
	if (elem) {
		var ldr = '<table><tr><td valign="center"><img src="img/ajax-loader.gif" alt="ajax-loader"></td><td valign="center"> <i>Loading...</i></td></tr></table>';
		if (loader)
			ldr = loader;
		elem.innerHTML = ldr;
	}
	
	if (url.indexOf('?') != -1)
		url += '&';
	else
		url += '?';
	url += 'rnd=' + Math.random();
	
	var xmlhttp = getXmlHttp();
	xmlhttp.open("POST", url, true);
	xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xmlhttp.setRequestHeader("Content-length", pdata.length);
	xmlhttp.setRequestHeader("Connection", "close");
	
	xmlhttp.onreadystatechange = function() {
		if (this.readyState == 4) {
			if (this.status == 200) {
				if (elem) {
					elem.innerHTML = this.responseText;
					autoJS(elem);
				}
				if (callback) {
					callback(this.responseText, cbarg);
				}
			}
			else {
				elem.innerHTML += '<br><table><tr><td><img src="img/error.png" alt="error"></td><td valign="center"> <font class="error">Error</font> : #' + this.status + ' </td></tr></table>';
			}
		}
	};
	xmlhttp.send(pdata);
}