/// action_lib_scenery(resource)
/// @arg resource
/// @desc Sets the scenery of the given library item.

var res, hobj;
hobj = null

if (history_undo)
	res = history_undo_res()
else if (history_redo)
	res = history_redo_res()
else
{
	var fn = "";
	res = argument0
	if (res = e_option.IMPORT_WORLD)
	{
		fn = project_folder + "\\world.schematic"
		file_delete_lib(fn)
		execute(test(setting_64bit_import, import64_file, import32_file), fn, true)
		if (!file_exists_lib(fn))
			return 0
			
		res = new_res(fn, e_res_type.FROM_WORLD)
		with (res)
			res_load()
	}
	else if (res = e_option.BROWSE)
	{
		fn = file_dialog_open_scenery()
		
		if (!file_exists_lib(fn))
			return 0
			
		res = new_res(fn, e_res_type.SCHEMATIC)
		if (res.replaced)
		{
			res_edit = res
			action_res_replace(fn)
		}
		else
			with (res)
				res_load()
	}

	hobj = history_set_res(action_lib_scenery, fn, temp_edit.scenery, res)
	with (hobj)
	{
		part_amount = 0
		part_child_amount = 0
		history_save_tl_select()
	}
}

tl_deselect_all()

with (temp_edit)
	temp_set_scenery(res, !app.history_undo, hobj)

// Restore old timelines
if (history_undo)
	with (history_data)
		history_restore_parts()

tl_update_length()
tl_update_list()
tl_update_matrix()

app_update_tl_edit()

lib_preview.update = true
