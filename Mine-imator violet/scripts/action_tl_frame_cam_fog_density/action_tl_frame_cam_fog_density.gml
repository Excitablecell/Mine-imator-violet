/// action_tl_frame_cam_fog_density(value, add)
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
		tl_value_set_start(action_tl_frame_cam_fog_density, true)
		tl_value_set(e_value.BG_FOG_DENSITY, val, add)
		tl_value_set_done()
		return 0
	}
	
	history_set_var(action_tl_frame_cam_fog_density, background_fog_density, background_fog_density * add + val, true)
}

background_fog_density = background_fog_density * add + val