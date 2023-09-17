// action_toolbar_model_import()
// @desc launch model_import
var fn = "";
fn = working_directory
execute(model_import, fn, true)//run converter.exe
fn = import_object + "importmodel.mimodel"
log("Createing extra model from model import", fn)
asset_load(fn)//load model