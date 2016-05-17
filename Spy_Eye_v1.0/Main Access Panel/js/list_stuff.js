function list_stuff(dvname, aname) {
  var dv = document.getElementById(dvname);
  var ael = document.getElementById(aname);
  if (ael.innerHTML == '+') {
    ael.innerHTML = '-';
    dv.style.display = 'block';
  }
  else {
    ael.innerHTML = '+';
    dv.style.display = 'none';
  }
}