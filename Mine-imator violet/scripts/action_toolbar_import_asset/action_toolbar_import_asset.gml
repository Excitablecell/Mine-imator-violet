/// action_toolbar_import_asset()
/// Multiple selected files added
var fn = file_dialog_open_assets();
var path_array = string_split(fn, "\n");
var path_array_count = array_length_1d(path_array);
if (path_array_count==0){
	return ;
}

for(var i = 0; i<path_array_count; i+=1){
	if (path_array[i] == "" || !file_exists_lib(path_array[i]))
		return;
	
	asset_load(path_array[i]);
}

