  function GetPos(elem){
   var offTrial=document.getElementById(elem);
   var offL=0;
   var offT=0;
   while(offTrial){
    offL+=offTrial.offsetLeft;
    offT+=offTrial.offsetTop;
    offTrial=offTrial.offsetParent;
   }
   if (navigator.userAgent.indexOf("Mac")!=-1 && typeof document.body.leftMargin!="undefined") {
    offL+=document.body.leftMargin;
    offT+=document.body.topMargin;
   }
   return {x:offL , y:offT}
  }

  function GetPosObj(obj){
   var offL=0;
   var offT=0;
   while(obj){
    offL+=obj.offsetLeft;
    offT+=obj.offsetTop;
    obj=obj.offsetParent;
   }
   if (navigator.userAgent.indexOf("Mac")!=-1 && typeof document.body.leftMargin!="undefined") {
    offL+=document.body.leftMargin;
    offT+=document.body.topMargin;
   }
   return {x:offL , y:offT}
  }

  function scrollIt(elfrom, elto){
   if (elfrom) elposfrom = GetPos(elfrom);
   elposto = GetPos(elto);
   if (elfrom) yfrom = elposfrom.y;
   else yfrom = 0;
   if (!yfrom) yfrom = 0;
   yto = elposto.y;

   /* if (yfrom >= yto){
    for (i = yfrom; i >= yto; i = (i / 2)-1){
     self.scroll(0,i);
    }

    for (j = i * 2; j >= yto; j--){
     self.scroll(0,j);
    }
   } else {
    ystep = (yto - yfrom) / 2;
    for (i = yfrom; i <= yto-1; i = i + ystep){
     self.scroll(0,i);
     if (ystep > 100) {ystep = (ystep / 2) + 1;} else {ystep = 50;}
    }
    for (j = i; j <= yto-1; j++){
     self.scroll(0,j);
    }
   } */
   
   moves = 10;
   step = (yto - yfrom) / moves;
   for (i = 0; i < moves; i++) {
		step *= (100 - 5 / moves) / 100;
		yfrom += step;
		self.scroll(0, yfrom);
   }
   self.scroll(0, yto);
   
  }