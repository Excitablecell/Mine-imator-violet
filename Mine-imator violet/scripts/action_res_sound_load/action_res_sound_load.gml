/// action_res_sound_load(filenmae)
/// @arg filename

if (history_undo)
{
	with (history_data)
		history_destroy_loaded()
}
else
{
	var fn, res;
	
	if (history_redo)
		fn = history_data.filename
	else
		fn = argument0
		
	res = new_res(fn, e_res_type.SOUND)
	res.loaded = true
	with (res)
		res_load()
		
	if (!history_redo && !res.replaced)
	{
		with (history_set(action_res_sound_load))
		{
			filename = fn
			history_save_loaded()
		}
	}
}

project_reset_loaded()
