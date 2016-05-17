function statsToggleVisibility(elem, name)
{
	var className = elem.nextSibling.nextSibling.className;
	if(className == 'statscontent')
	{
		elem.nextSibling.nextSibling.className = 'statscontent hide';
		elem.getElementsByClassName('down')[0].className = 'up';
		document.cookie = name + '=off;';
	}
	else
	{
		elem.nextSibling.nextSibling.className = 'statscontent';
		elem.getElementsByClassName('up')[0].className = 'down';
		document.cookie = name + '=on;';
	}
}

function navigateTo(page)
{
	window.location.href = page;
}

function changeLayout(index)
{
	if(index >= 0 && index <= 9)
	{
		document.getElementById('ddos_target').style.display = 'block';
		document.getElementById('ddos_port').style.display = 'block';
		document.getElementById('ddos_duration').style.display = 'block';
		document.getElementById('ddos_amount').style.display = 'block';
	}
	else if(index == 10)
	{
		document.getElementById('ddos_target').style.display = 'block';
		document.getElementById('ddos_port').style.display = 'none';
		document.getElementById('ddos_duration').style.display = 'block';
		document.getElementById('ddos_amount').style.display = 'block';
	}
	else if(index == 11 || index == 12)
	{
		document.getElementById('ddos_target').style.display = 'none';
		document.getElementById('ddos_port').style.display = 'none';
		document.getElementById('ddos_duration').style.display = 'none';
		document.getElementById('ddos_amount').style.display = 'none';
	}
}

function changeLayoutMisc(value)
{
	if(value == 'download' || value == 'download.update' || value == 'view' || value == 'view.hidden' || value == 'smartview.del') //url
	{
		document.getElementById('misc_url').style.display = 'block';
		document.getElementById('misc_command').style.display = 'none';
		document.getElementById('misc_args').style.display = 'none';
		document.getElementById('misc_open').style.display = 'none';
		document.getElementById('misc_close').style.display = 'none';
	}
	else if(value == 'download.arguments') //url & args
	{
		document.getElementById('misc_url').style.display = 'block';
		document.getElementById('misc_command').style.display = 'none';
		document.getElementById('misc_args').style.display = 'block';
		document.getElementById('misc_open').style.display = 'none';
		document.getElementById('misc_close').style.display = 'none';
	}
	else if(value == 'smartview.add') //url & open & close
	{
		document.getElementById('misc_url').style.display = 'block';
		document.getElementById('misc_command').style.display = 'none';
		document.getElementById('misc_args').style.display = 'none';
		document.getElementById('misc_open').style.display = 'block';
		document.getElementById('misc_close').style.display = 'block';
	}
	else if(value == 'smartview.clear' || value == 'botkill.start' || value == 'botkill.stop' || value == 'botkill.once' || value == 'uninstall') //none
	{
		document.getElementById('misc_url').style.display = 'none';
		document.getElementById('misc_command').style.display = 'none';
		document.getElementById('misc_args').style.display = 'none';
		document.getElementById('misc_open').style.display = 'none';
		document.getElementById('misc_close').style.display = 'none';
	}
	else if(value == 'shell') // command
	{
		document.getElementById('misc_url').style.display = 'none';
		document.getElementById('misc_command').style.display = 'block';
		document.getElementById('misc_args').style.display = 'none';
		document.getElementById('misc_open').style.display = 'none';
		document.getElementById('misc_close').style.display = 'none';
	}
}