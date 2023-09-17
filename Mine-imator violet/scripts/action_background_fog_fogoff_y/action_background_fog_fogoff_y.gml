/// action_background_fog_fogoff_y(value, add)
/// @arg value
/// @arg add

var val, add;
add = false

if (history_undo)
	val = history_data.old_value
else if (history_redo)
	val = history_data.new_value
else
{
	val = argument0
	add = argument1
	if (action_tl_select_single(null, e_tl_type.BACKGROUND))
	{
		tl_value_set_start(action_background_fog_fogoff_y, true)
		tl_value_set(e_value.FOG_OFF_Y, val, add)
		tl_value_set_done()
		return 0
	}
	history_set_var(action_background_fog_fogoff_y, fog_off_y, fog_off_y * add + val, true)
}

fog_off_y = fog_off_y * add + val
