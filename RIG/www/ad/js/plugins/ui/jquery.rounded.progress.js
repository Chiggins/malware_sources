/*
 * 	CProgress v1.0.2 - jQuery plugin
 *	written by Artur Tomaszewski
 *	http://p.ar2oor.pl/cprogress/
 *
 *	Copyright (c) 2011 Artur Tomaszewski (http://ar2oor.pl)
 *	Distributed under the MIT License
 *
 *	Built for jQuery library
 *	http://jquery.com
 *
 */

(function ( $ ) {
     if (!$.ns) {
	  $.ns = {};
     };

     $.ns.cprogress = function ( el, options) {
	  var base = this;
	  // Access to jQuery and DOM 
	  base.$el = $(el);
	  base.el = el;
	  base.$el.data( "ns.cprogress" , base );

	  base.options = $.extend({}, $.ns.cprogress.defaultOptions, options);

	  base.methods = {
	       init: function () {

		    //Images
		    base.img1 = new Image();
		    base.img1.src = base.options.img1;
		    base.img2 = new Image();
		    base.img2.src = base.options.img2;

		    base.width = base.img1.width;
		    base.height = base.img1.height;

		    //main cprogress div
		    base.$progress = $('<div />').addClass('jCProgress');
		    mt = parseInt(base.$progress.css('marginTop').replace("ems",""));
		    ml = parseInt(base.$progress.css('marginLeft').replace("ems",""));
		    base.$progress.css('marginLeft',(base.$el.width()-base.width)/2+ml).css('marginTop',(base.$el.height()-base.height)/2+mt).css('opacity','0.0');

		    //percent div
		    base.$percent = $('<div />').addClass('percent');
		    //hide?
		    
		    //canvas area
		    base.$ctx = $('<canvas />');
		    base.$ctx.attr('width',base.width);
		    base.$ctx.attr('height',base.height);

		    //append to target
		    base.$el.prepend(base.$progress);
		    base.$progress.append(base.$percent);
		    base.$progress.append(base.$ctx);

		    //effect
		    base.$progress.animate({
			 opacity: 1.0
		    }, 500, function() {
			 });

		    //Canvas
		    base.ctx = base.$ctx[0].getContext('2d');
		    //Pie color/alpha
		    base.ctx.fillStyle = "rgba(0,0,0,0.0)";
		   
		    //others
		    base.i=0;
		    base.j=0;
		    base.stop = 0;
		    
		    //call draw method
		    base.options.onInit();
		    base.methods.draw();

		    
	       },
	       reloadImages : function(){

		    //Images
		    base.img1 = new Image();
		    base.img1.src = base.options.img1;
		    base.img2 = new Image();
		    base.img2.src = base.options.img2;

		    base.width = base.img1.width;
		    base.height = base.img1.height;

		    base.$progress.css('marginLeft',(base.$el.width()-base.width)/2+ml).css('marginTop',(base.$el.height()-base.height)/2+mt);

		    base.$ctx.attr('width',base.width);
		    base.$ctx.attr('height',base.height);

		    base.ctx = base.$ctx[0].getContext('2d');
		    base.ctx.fillStyle = "rgba(0,0,0,0.0)";


	       },
	       coreDraw : function(){



		    
		    base.ctx.clearRect(0,0,base.width,base.height);
		    base.ctx.save();
		    base.ctx.drawImage(base.img1,0,0);
		    base.ctx.beginPath();
		    base.ctx.lineWidth = 5;
		    base.ctx.arc(base.width/2,base.height/2,base.height/2,base.i-Math.PI/2,base.j-Math.PI/2,true);
		    base.ctx.lineTo(base.width/2,base.height/2);
		    base.ctx.closePath();
		    base.ctx.fill();
		    base.ctx.clip();
		    base.ctx.drawImage(base.img2,0,0);
		    base.ctx.restore();
		    
	       }
	       ,
	       draw : function () {
		    if(base){

			 if(base.width==0 || base.height==0){
			      base.methods.reloadImages();
			 }
		    
			 if(base.options.showPercent==false){
			      base.$percent.hide();
			 }
			 else{
			      base.$percent.show();

			 }

			 if(base.stop!=1 && (base.options.percent-1)<=base.options.limit){

			      if(base.options.loop==true){
				   base.options.limit=121;
			      }
			      if(base.options.percent>=100 && base.options.percent<=base.options.limit){
				   base.i=0;
				   base.options.limit=base.options.limit-100;
			      }
		    
			      base.methods.coreDraw();

			      base.i=base.i+base.options.PIStep;

			      base.options.percent = base.i*100/(Math.PI*2);
			      
			      if(base.options.percent<=base.options.limit){
				   setTimeout(base.methods.draw,base.options.speed);
				   base.$percent.html(base.options.percent.toFixed(0));

				   base.options.onProgress(base.options.percent.toFixed(0));
			      }else{
				   base.$percent.html(base.options.limit);
				   base.methods.coreDraw();
				   base.options.onProgress(base.options.limit);
				   base.options.onComplete(base.options.limit);
			      }
			      
			      base.options.percent++;
			 }
		    }

	       },
	       destroy: function(){
		    base.$progress.animate({
			 opacity: 0.0
		    }, 500, function() {
			 base.$progress.remove();
			 base.stop = 1;
			 base = null;
		    });
	       }
	  };

	  base.public_methods = {
	       start : function(){
		    base.stop = 0;
		    base.methods.draw();
	       },
	       stop : function(){
		    base.stop = 1;

	       },
	       reset : function(){
		    base.options.percent =0;
		    base.i=0;
		    base.methods.draw();
	       },
	       destroy : function(){
		    base.methods.destroy();
	       },
	       options: function(options){
		    base.options = $.extend({}, base.options, options);
		    if(options.img1 || options.img2 || options.img3){
			 base.methods.reloadImages();
			 base.methods.coreDraw();
		    }
		    base.methods.draw();
		    return base.options;
	       }
	  };

	  base.methods.init();


     };

     $.ns.cprogress.defaultOptions = {
	  percent :0,
	  //Variables
	  img1: 'v1.png',
	  img2: 'v2.png',
	  speed: 50,
	  limit : 48,
	  loop : false,
	  showPercent : true,
	  PIStep : 0.05,
	  //Funs
	  onInit : function(){},
	  onProgress : function(percent){},
	  onComplete : function(){}
     };
     
     $.fn.cprogress = function( options) {
	  var cprogress = (new $.ns.cprogress(this, options));
	  return cprogress.public_methods;
     };

})( jQuery );
