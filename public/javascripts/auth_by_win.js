alert("load_win");
var wshshell=new ActiveXObject("wscript.shell");
var username=wshshell.ExpandEnvironmentStrings("%username%");
alert("load_win");
window.location.replace("/login_by_win/"+username+"_"+location.pathname)

