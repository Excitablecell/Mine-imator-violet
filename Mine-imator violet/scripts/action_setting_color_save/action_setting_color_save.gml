/// action_setting_color_save()

var fn = file_dialog_save_color("");

if (fn = "")
	return 0

fn = filename_new_ext(fn, ".micolor")

json_save_start(fn)
json_save_object_start()
settings_save_colors()
json_save_object_done()
json_save_done()