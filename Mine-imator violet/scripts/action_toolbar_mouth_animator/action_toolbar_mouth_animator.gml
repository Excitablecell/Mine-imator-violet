// action_toolbar_mouth_animator()
// @desc launch mouth animatior
var fn = "";
fn = working_directory
execute(mouth_animator, fn, true)//run converter.exe
fn = mouth_object + "output.miobject"
log("Createing mouth's animation", fn)
asset_load(fn)//load mouth.miobject