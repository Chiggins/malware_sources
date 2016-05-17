var gAlrmElts = new Array();
function displayAlrmElts ()
{
  for (var i = 0; i < gAlrmElts.length; i++) {
    if (!gAlrmElts[i]) continue;
    (gAlrmElts[i].style.backgroundColor != "red") ? gAlrmElts[i].style.backgroundColor = "red" : gAlrmElts[i].style.backgroundColor = "black";
  }
  setTimeout("displayAlrmElts()", 333);
}
displayAlrmElts();