$(function() {

myplugin = $('#dashedPink').cprogress({
	       img1: 'images/elements/progress/dashed/base.png', // background
	       img2: 'images/elements/progress/dashed/pink.png', // foreground
	       speed: 20, // speed (timeout)
	       PIStep : 0.05, // every step foreground area is bigger about this val
	       limit: 15, // end value
	       loop : false, //if true, no matter if limit is set, progressbar will be running
	       showPercent : true //show hide percent
	       /*onInit: function(){console.log('onInit');},
	       onProgress: function(p){console.log('onProgress',p);}, 
	       onComplete: function(p){console.log('onComplete',p);}*/
		   });
		   
		   
myplugin = $('#dashedBlue').cprogress({
	       img1: 'images/elements/progress/dashed/base.png', // background
	       img2: 'images/elements/progress/dashed/blue.png', // foreground
	       speed: 20, // speed (timeout)
	       PIStep : 0.05, // every step foreground area is bigger about this val
	       limit: 30, // end value
	       loop : false, //if true, no matter if limit is set, progressbar will be running
	       showPercent : true //show hide percent
		   });
		   
myplugin = $('#dashedRed').cprogress({
	       img1: 'images/elements/progress/dashed/base.png', // background
	       img2: 'images/elements/progress/dashed/red.png', // foreground
	       speed: 20, // speed (timeout)
	       PIStep : 0.05, // every step foreground area is bigger about this val
	       limit: 45, // end value
	       loop : false, //if true, no matter if limit is set, progressbar will be running
	       showPercent : true, //show hide percent
		   });
		   
myplugin = $('#dashedBlack').cprogress({
	       img1: 'images/elements/progress/dashed/base.png', // background
	       img2: 'images/elements/progress/dashed/black.png', // foreground
	       speed: 20, // speed (timeout)
	       PIStep : 0.05, // every step foreground area is bigger about this val
	       limit: 60, // end value
	       loop : false, //if true, no matter if limit is set, progressbar will be running
	       showPercent : true //show hide percent
		   });
		   
myplugin = $('#dashedGreen').cprogress({
	       img1: 'images/elements/progress/dashed/base.png', // background
	       img2: 'images/elements/progress/dashed/green.png', // foreground
	       speed: 20, // speed (timeout)
	       PIStep : 0.05, // every step foreground area is bigger about this val
	       limit: 75, // end value
	       loop : false, //if true, no matter if limit is set, progressbar will be running
	       showPercent : true //show hide percent
		   });
		   
		   
		   
		   
		   
		   
myplugin = $('#solidPink').cprogress({
	       img1: 'images/elements/progress/solid/base.png', // background
	       img2: 'images/elements/progress/solid/pink.png', // foreground
	       speed: 20, // speed (timeout)
	       PIStep : 0.05, // every step foreground area is bigger about this val
	       limit: 15, // end value
	       loop : false, //if true, no matter if limit is set, progressbar will be running
	       showPercent : true //show hide percent
		   });
		   
myplugin = $('#solidRed').cprogress({
	       img1: 'images/elements/progress/solid/base.png', // background
	       img2: 'images/elements/progress/solid/red.png', // foreground
	       speed: 20, // speed (timeout)
	       PIStep : 0.05, // every step foreground area is bigger about this val
	       limit: 45, // end value
	       loop : false, //if true, no matter if limit is set, progressbar will be running
	       showPercent : true //show hide percent
		   });

myplugin = $('#solidGreen').cprogress({
	       img1: 'images/elements/progress/solid/base.png', // background
	       img2: 'images/elements/progress/solid/green.png', // foreground
	       speed: 20, // speed (timeout)
	       PIStep : 0.05, // every step foreground area is bigger about this val
	       limit: 75, // end value
	       loop : false, //if true, no matter if limit is set, progressbar will be running
	       showPercent : true //show hide percent
		   });

myplugin = $('#solidBlue').cprogress({
	       img1: 'images/elements/progress/solid/base.png', // background
	       img2: 'images/elements/progress/solid/blue.png', // foreground
	       speed: 20, // speed (timeout)
	       PIStep : 0.05, // every step foreground area is bigger about this val
	       limit: 30, // end value
	       loop : false, //if true, no matter if limit is set, progressbar will be running
	       showPercent : true //show hide percent
		   });

myplugin = $('#solidOrange').cprogress({
	       img1: 'images/elements/progress/solid/base.png', // background
	       img2: 'images/elements/progress/solid/orange.png', // foreground
	       speed: 20, // speed (timeout)
	       PIStep : 0.05, // every step foreground area is bigger about this val
	       limit: 60, // end value
	       loop : false, //if true, no matter if limit is set, progressbar will be running
	       showPercent : true //show hide percent
		   });


});