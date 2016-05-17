/** 
 * Author and Version Information {{{
 * author: Antonio Ramirez http://webeaters.blogspot.com
 *
 * class: AutoComplete for Prototype 1.6.0
 *
 * version: 1.2.1 - 2007-11-11 
 * 		(based on AutoSuggest 2.1.3 - 2007-07-19)
 * version: 1.3.0 - 2008-01-03 by Andrew Nicols <andrew@nicols.co.uk>
 *  - Fixed incorrect title-casing - CSS is Case Sensitive!!!
 *  - Adjusted the way in which the Notifier images are loaded.
 *  - Changed json code to pass all json variables back instead of just id, value and name
 *  - Fixed 'GMAIL' code such that if valueSep is undefined, it is ignored
 *  - Changed the default for valueSep to null
 *  - Fixed the resetTimeout function
 *
 * REFERENCES AND THANKS 
 * this class is based on the work in AutoSuggest.js of
 * Timothy Groves - http://www.brandspankingnew.net
 * and adapted for use with prototype 1.6.0
 *
 * UPDATED by RŽéda HADJOUTI
 * GMAIL like AutoComplete (semicolon separator) Update
 *
 }}}*/

var AutoComplete = Class.create();

AutoComplete.prototype = { // {{{
  Version: '1.3.0',
  REQUIRED_PROTOTYPE: '1.6.0',

  initialize: function (id, param) { // {{{
  	// check whether we have the appropiate javascript libraries
  	this.PROTOTYPE_CHECK();
	
    // Get the field we're watching.
    // It needs to be a valid field so throw an error if it's not valid or can't be found.
    this.fld = $(id);
    if (!this.fld)
    {
      throw("AutoComplete requires a field id to initialize");
    }
	
    // Init variables
    this.sInp 	= ""; // input value 
    this.nInpC 	= 0;	// input value length
    this.aSug 	= []; // suggestions array 
    this.iHigh 	= 0;	// level of list selection 
	
  // Parameter Handling {{{
	// Set the use specified options
	this.options = param ? param : {};
	// These are the default settings {{{
  var k, def = {
    valueSep:null,
    minchars:1,
    meth:"get",
    varname:"input",
    className:"autocomplete",
    timeout:3000,
    delay:500,
    offsety:-5,
    shownoresults: true,
    noresults: "No results were found.",
    maxheight: 250,
    cache: true,
    maxentries: 25,
    onAjaxError:null,
    setWidth: false,
    minWidth: 100,
    maxWidth: 200,
    useNotifier: true
  };
  //}}}
  // Overlay any values which weren't user specified.
	for (k in def) 
	{
		if (typeof(this.options[k]) != typeof(def[k]))
			this.options[k] = def[k];
	}
  // End of Parameter Handling }}}

  // Not everyone wants to use the Notifier. Give them the option	
	if (this.options.useNotifier)
  {
    this.fld.addClassName('ac_field');
  }

	// set keyup handler for field
	// and prevent AutoComplete from client
	var p = this;
	
	// NOTE: not using addEventListener because UpArrow fired twice in Safari
	this.fld.onkeypress 	= function(ev){ return p.onKeyPress(ev); };
	this.fld.onkeyup      = function(ev){ return p.onKeyUp(ev); };
  // ARN-DEBUG Chances are we want to reset the timeout when they lose focus, at least that's what I prefer
	this.fld.onblur			  = function(ev){ p.resetTimeout(); return true; };	
  // ARN-DEBUG Not sure what this is about!
	this.fld.setAttribute("AutoComplete","off");

  }, //}}}

  convertVersionString: function (versionString){ // {{{
      var r = versionString.split('.');
      return parseInt(r[0])*100000 + parseInt(r[1])*1000 + parseInt(r[2]);
  }, // }}}

  PROTOTYPE_CHECK: function() { // {{{
    if((typeof Prototype=='undefined') || 
       (typeof Element == 'undefined') || 
       (typeof Element.Methods=='undefined') ||
       (this.convertVersionString(Prototype.Version) < 
        this.convertVersionString(this.REQUIRED_PROTOTYPE)))
       throw("AutoComplete requires the Prototype JavaScript framework >= " +
        this.REQUIRED_PROTOTYPE);
  }, // }}}

  // set responses to keypress events in the field
  // this allows the user to use the arrow keys to scroll through the results
  // ESCAPE clears the list
  // RETURN sets the current highlighted value
  // UP/DOWN move around the list

  onKeyPress: function (e) { // {{{
  	if (!e) e = window.event;
  	var key	= e.keyCode || e.wich;
  	

    switch(key)
    {
      case Event.KEY_RETURN:
        this.setHighlightedValue();
        Event.stop(e);
        break;
      case Event.KEY_TAB:
        this.setHighlightedValue();
        //Event.stop(e);
        break;
      case Event.KEY_ESC:
        this.clearSuggestions();
        break;
    }
    return true;
  }, //}}}

  onKeyUp: function (e) { // {{{
  	if (!e) e = window.event;
  	
  	var key = e.keyCode || e.wich;
  	
  	if (key == Event.KEY_UP || key == Event.KEY_DOWN) 
  	{
  		this.changeHighlight(key);
  		Event.stop(e);
  	}
  	else this.getSuggestions(this.fld.value);
  	
	return true;
  }, //}}}

  getSuggestions: function(val) { // {{{
  	// input the same? do nothing
  	if(val==this.sInp) return false;
  	
  	// kill the old list
  	if($(this.acID)) $(this.acID).remove();
  	
  	this.sInp = val;
  	
  	// input length is less than the min required to trigger a request
  	// do nothing
  	if (val.length < this.options.minchars)
  	{
  		this.aSug 	= [];
  		this.nInpC	= val.length; 
  		return false;
  	}

  	// Here we will detect if there is a comma and the splitted value has a value to check
  	// comma stars a new search and val is converted to the new value after the comma
  	var ol	= this.nInpC; // old length
  	this.nInpC	= val.length ? val.length : 0;
  	
  	// if caching enabled, and we didn't receive the maxentries value
    // and user is typing (ie. length of input is increasing)
  	// filter results out of suggestions from last request
  	var l = this.aSug.length;
  	if( this.options.cache && ( this.nInpC > ol ) && l && ( l < this.options.maxentries ) )
  	{
  		var arr = new Array();
  		for (var i=0;i<l;i++) {
  			if (this.aSug[i].value.toLowerCase().indexOf(val.toLowerCase()) != -1)
        {
  				arr.push(this.aSug[i]);
        }
  		}
  		this.aSug = arr;
  		
  		// recreate the list
  		this.createList(this.aSug);
  	} else {
  		// do new request
  		var p = this;
  		//var input	= this.sInp; // send the converted new value (comma)
  		clearTimeout(this.ajID); // ajax id timer
  		this.ajID = setTimeout( function () {p.doAjaxRequest(p.sInp)}, this.options.delay);
  	}
    document.helper = this;	
  	return false;
  }, // }}}

  getLastInput : function(str) { // {{{
  	var ret = str;
  	if (undefined != this.options.valueSep) {
  		var idx = ret.lastIndexOf(this.options.valueSep);
      ret = idx == -1 ? ret : ret.substring(idx + 1, ret.length);
  	}
  	
  	return ret;
  }, // }}}

  doAjaxRequest: function (input) { // {{{
  	// we have to check here if there is a new splitted value (, or ;)
  	// always check against the last part of the comma and then check
  	// saved input is still the value of the field
  	if (input != this.fld.value) 
  		return false;
  	
  	// Gmail like : get only the last user's input
  	this.sInp = this.getLastInput(this.sInp);
 	
  	// create ajax request
  	// do we need to call a function to recreate the url?
  	if (typeof this.options.script == 'function')
  		var url = this.options.script(encodeURIComponent(this.sInp));
  	else
  		var url = this.options.script+this.options.varname+'='+encodeURIComponent(this.sInp);
  	
  	if(!url) return false;
  	
  	var p = this;
  	var m = this.options.meth;  // get or post?
    if( this.options.useNotifier )
    {
      this.fld.removeClassName('ac_field');
	    this.fld.addClassName('ac_field_busy');
    };
  	
  	var options = {
  		method: m,
  		onSuccess: function (req) { // {{{
        if( p.options.useNotifier )
        {
          p.fld.removeClassName('ac_field_busy');
          p.fld.addClassName('ac_field');
        };
        p.setSuggestions(req,input);
  		}, // }}}

  		onFailure: (typeof p.options.onAjaxError == 'function')? function (status) { // {{{
        if (p.options.useNotifier)
        {
          p.fld.removeClassName('ac_field_busy');
          p.fld.addClassName('ac_field');
        }
        p.options.onAjaxError(status)
      } : // }}}

      function (status) { // {{{
        if (p.options.useNotifier)
        {
          p.fld.removeClassName('ac_field_busy');
          p.fld.addClassName('ac_field');
        }
        alert("AJAX error: "+status); 
      } // }}}
    }
  	// make new ajax request
  	new Ajax.Request(url, options);
  }, // }}}

  setSuggestions: function (req, input) { // {{{
	  // if field input no longer matches what was passed to the request
	  // don't show the suggestions
	  // here we need to check against the splitted values if any (, or ;)
    if (input != this.fld.value)
      return false;
	
    this.aSug = [];
	
    if(this.options.json) 
    { // response in json format?
      var jsondata = eval('(' + req.responseText + ')');
      this.aSug = jsondata.results;
    } else {
      // response in xml format?
      var results = req.responseXML.getElementsByTagName('results')[0].childNodes;
    
      for(var i=0;i<results.length;i++)
      {
        if(results[i].hasChildNodes())
          this.aSug.push(  { 'id':results[i].getAttribute('id'), 'value':results[i].childNodes[0].nodeValue, 'info':results[i].getAttribute('info') }  );
      }
    }
    this.acID = 'ac_'+this.fld.id;
    this.createList(this.aSug);
  }, // }}}

  createDOMElement: function ( type, attr, cont, html ) { // {{{
    var ne = document.createElement( type );
	
    if (!ne)
      return 0;
      
    for (var a in attr)
      ne[a] = attr[a];
    
    var t = typeof(cont);
    
    if (t == "string" && !html)
      ne.appendChild( document.createTextNode(cont) );
    else if (t == "string" && html)
      ne.innerHTML = cont;
    else if (t == "object")
      ne.appendChild( cont );

    return ne;
  }, // }}}

  createList:	function(arr) { // {{{
    // get rid of the old list if any  
  	if($(this.acID)) $(this.acID).remove();
  	
  	// clear list removal timeout
  	this.killTimeout();
  	
  	// if no results, and showNoResults is false, do nothing
  	if (arr.length == 0 && !this.options.shownoresults) return false;
  	
  	// create holding div
  	var div	= this.createDOMElement('div', {id:this.acID, className:this.options.className});
  	
  	// create div header
  	var hcorner = this.createDOMElement('div', {className: 'ac_corner'});
  	var hbar	= this.createDOMElement('div', {className: 'ac_bar'});
  	var header	= this.createDOMElement('div', {className: 'ac_header'});
  	header.appendChild(hcorner);
  	header.appendChild(hbar);
  	div.appendChild(header);
  	
    // create and populate ul
    var ul	= this.createDOMElement('ul', {id:'ac_ul'});
    var p 	= this; // pointer that we will need later on
    // no results?
    if (arr.length == 0 && this.options.shownoresults)
    {
      var li = this.createDOMElement('li', {className: 'ac_warning'}, this.options.noresults );
      ul.appendChild(li);
    } else {
      // loop through arr of suggestions creating an LI element for each of them
      for (var i=0,l = arr.length; i<l; i++)
      {
        // format output with the input enclosed in a EM elementFromPoint
        // (as HTML not DOM)
        var val 	= arr[i].value;
        var st 		= val.toLowerCase().indexOf(this.sInp.toLowerCase()); // HERE WE CHECK AGAINST THE SPLITTED VALUE IF ANY***
        var output 	= val.substring(0,st) + '<em>' + val.substring(st,st+this.sInp.length) + '</em>' + val.substring(st+this.sInp.length);
			
        var span	= this.createDOMElement('span',{},output,true); // type of, properties, output, isHTML?
			
        if(arr[i].info != '') // do we need to add extra info?
        {
          var br	= this.createDOMElement('br',{});
          span.appendChild(br);
          
          var small = this.createDOMElement('small',{}, arr[i].info);
          span.appendChild(small);
        }
        var a 	= this.createDOMElement('a',{href:'#'});
        
        var tl	= this.createDOMElement('span',{className:'tl'},'&nbsp;',true);
        var tr	= this.createDOMElement('span',{className:'tr'},'&nbsp;',true);
        
        a.appendChild(tl);
        a.appendChild(tr);
        a.appendChild(span); // add the object span into the link
			
        a.name = i+1;
        
        a.onclick 		= function () { // {{{
          p.setHighlightedValue();
          return false; 
        }; // }}}
        a.onmouseover	= function () { // {{{
          p.setHighlight(this.name); 
        }; // }}} 
			
        var li = this.createDOMElement('li', {}, a); // add the link element to a li element
        
        // finally add the newly created li element to the ul element 
        ul.appendChild(li);
      }
    }
    
    div.appendChild(ul); // add the newly created list to the div element
    
    // create div footer
    var fcorner = this.createDOMElement('div', {className: 'ac_corner'});
  	var fbar	= this.createDOMElement('div', {className: 'ac_bar'});
  	var footer	= this.createDOMElement('div', {className: 'ac_footer'});
  	footer.appendChild(fcorner);
  	footer.appendChild(fbar);
  	div.appendChild(footer);
  	
  	// get position of target textfield
    // position holding div below it
    // set width of holding div to width of field 
    // if 
    
    var pos         = this.fld.cumulativeOffset();
    div.style.left 	= pos[0] + "px";
    div.style.top 	= pos[1] + this.fld.offsetHeight + "px";
    
    var w = 
    (
      this.options.setWidth && this.fld.offsetWidth < this.options.minWidth
    )
    ? this.options.minWidth : 
    (
      this.options.setWidth && this.fld.offsetWidth > this.options.maxWidth
    )
    ? this.options.maxWidth : 
    this.fld.offsetWidth;

    
    div.style.width 	= w + "px";
    
    // set mouseover functions for div
    // when mouse pointer leaves div, set a timeout to remove the list after an interval
    // when mouse enters div, kill the timeout so the list won't be removed
    //
    div.onmouseover 	= function(){ p.killTimeout() };
    div.onmouseout 		= function(){ p.resetTimeout() };
    
    // add DIV to document
    document.getElementsByTagName("body")[0].appendChild(div);
    
    // highlight first item
    this.iHigh = 1;
    this.setHighlight(1);
    
    // remove list after interval
    this.toID	= setTimeout(
      function () {
        p.clearSuggestions() 
      }, this.options.timeout
    );
	
  }, // }}}

  changeHighlight:	function(key) { // {{{
  	var list = $("ac_ul");
    if (!list)
      return false;
	
    var n;

    n = (key == Event.KEY_DOWN || key == Event.KEY_TAB)? this.iHigh + 1 : this.iHigh - 1; // false assumed to be Event.KEY_UP
    
    n = (n > list.childNodes.length)? list.childNodes.length : ((n < 1)? 1 : n);	
    
    this.setHighlight(n);
  }, // }}}

  setHighlight:		function(n) { // {{{
  	var list = $('ac_ul');
  	
  	if (!list) return false;
  	
  	if (this.iHigh > 0) this.clearHighlight();
  	
  	this.iHigh = Number(n);
  	
  	list.childNodes[this.iHigh-1].className = 'ac_highlight';
  	
  	this.killTimeout();
  }, // }}}

  clearHighlight:	function() { // {{{
  	var list = $('ac_ul');
  	
  	if(!list) return false;
  	
  	if(this.iHigh > 0)
  	{
  		list.childNodes[this.iHigh-1].className = '';
  		this.iHigh = 0;
  	}
  	
  }, // }}}

  setHighlightedValue:	function() { // {{{
  	if (this.iHigh)
  	{
  		// HERE WE NEED TO IMPLEMENT THE GMAIL LIKE SPLITTED VALUE
  		if (!this.aSug[this.iHigh - 1]) return;
  		
  		// Gmail like
      if (undefined != this.options.valueSep) {
        var str = this.getLastInput(this.fld.value);
        var idx = this.fld.value.lastIndexOf(str);
        str = this.aSug[ this.iHigh -1 ].value + this.options.valueSep;
        this.sInp = this.fld.value = idx == -1 ? str : this.fld.value.substring(0, idx) + str;
      } else {
        var str = this.getLastInput(this.fld.value);
        var idx = this.fld.value.lastIndexOf(str);
        str = this.aSug[ this.iHigh -1 ].value;
        this.sInp = this.fld.value = idx == -1 ? str : this.fld.value.substring(0, idx) + str;
      }
  		
  		// move cursor to end of input (safari)
  		this.fld.focus();
  		if(this.fld.selectionStart)
  			this.fld.setSelectionRange(this.sInp.length, this.sInp.length);
  			
  		this.clearSuggestions();
  		
  		// pass selected object to callback function, if exists
  		if (typeof this.options.callback == 'function')
  			this.options.callback(this.aSug[this.iHigh-1]); // the object has the properties we want, it will depend of
  	}
  }, // }}}

  killTimeout:	function() { // {{{
  	clearTimeout(this.toID);
  }, // }}}

  resetTimeout:	function() { // {{{
  	this.killTimeout();
  	var p = this;
  	this.toID = setTimeout(
      function () { 
        p.clearSuggestions();
      }, p.options.timeout
    );
    // ARN-DEBUG Added p.options.timeout back :|
  }, // }}}

  clearSuggestions:	function () { // {{{
	
    this.killTimeout();
    if ($(this.acID))
    {
      this.fadeOut(300,function () {
        $(this.acID).remove();
      } );
    }
  }, // }}}

  fadeOut:	function (milliseconds, callback) { // {{{
  	this._fadeFrom 	= 1;
  	this._fadeTo	= 0;
  	this._afterUpdateInternal = callback;
  	
  	this._fadeDuration	= milliseconds;
  	this._fadeInterval = 50;
  	this._fadeTime = 0;
  	var p = this;
  	this._fadeIntervalID = setInterval(
      function() {
        p._changeOpacity()
      }, this._fadeInterval
    );
  
  }, // }}}

  _changeOpacity: function() { // {{{
 
    if (!$(this.acID))
    {
  		this._fadeIntervalID=clearInterval(this._fadeIntervalID);
  		return;
  	} 
  	this._fadeTime += this._fadeInterval;
  	
  	var ieop = Math.round( (this._fadeFrom + ((this._fadeTo - this._fadeFrom) * (this._fadeTime/this._fadeDuration))) * 100)
  	var op = ieop / 100;
 
  	var el = $(this.acID);
  	if (el.filters) // internet explorer
  	{
      try {
        el.filters.item("DXImageTransform.Microsoft.Alpha").opacity = ieop;
      } catch (e) { 
        // If it is not set initially, the browser will throw an error.
        // This will set it if it is not set yet.
        el.style.filter = 'progid:DXImageTransform.Microsoft.Alpha(opacity='+ieop+')';
      }
    } else	{
      el.style.opacity = op;
    }
	
    if (this._fadeTime >= this._fadeDuration)
    {
      clearInterval( this._fadeIntervalID );
      if (typeof this._afterUpdateInternal == 'function')
        this._afterUpdateInternal();
    }

  } // }}}
 
} // }}}

// vim: set filetype=javascript foldmethod=marker foldlevel=5:
