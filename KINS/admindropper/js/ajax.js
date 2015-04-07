var xmlHttp = createXmlHttpRequestObject();
// creates an XMLHttpRequest instance
function createXmlHttpRequestObject() 
{
  // will store the reference to the XMLHttpRequest object
  var xmlHttp;
  // this should work for all browsers except IE6 and older
  try{
    // try to create XMLHttpRequest object
    xmlHttp = new XMLHttpRequest();
  }catch(e){
    // assume IE6 or older
    var XmlHttpVersions = new Array("MSXML2.XMLHTTP.6.0",
                                    "MSXML2.XMLHTTP.5.0",
                                    "MSXML2.XMLHTTP.4.0",
                                    "MSXML2.XMLHTTP.3.0",
                                    "MSXML2.XMLHTTP",
                                    "Microsoft.XMLHTTP");
    // try every prog id until one works
    for (var i=0; i<XmlHttpVersions.length && !xmlHttp; i++){
      try{ 
        // try to create XMLHttpRequest object
        xmlHttp = new ActiveXObject(XmlHttpVersions[i]);
      } 
      catch (e) {}
    }
  }
  // return the created object or display an error message
  if (!xmlHttp)
    alert("Error creating the XMLHttpRequest object.");
  else 
    return xmlHttp;
}

function fileadd_show_options(a) {
    if (a == 0) {
        $("#fileversion").hide(250);
        $("#connectedwith").hide(250);
        $("#arguments").hide(250);
        $("#wheretoinject").hide(250);
    }
    else if (a == 1) {
        $("#fileversion").show(250);
        $("#connectedwith").hide(250);
        $("#arguments").hide(250);
        $("#wheretoinject").hide(250);
    }
    else if (a == 2) {
        $("#fileversion").show(250);
        $("#connectedwith").hide(250);
        $("#arguments").hide(250);
        $("#wheretoinject").show(250);
    }
    else if (a == 3) {
        $("#fileversion").show(250);
        $("#connectedwith").show(250);
        $("#arguments").show(250);
        $("#wheretoinject").show(250);
    }
}
