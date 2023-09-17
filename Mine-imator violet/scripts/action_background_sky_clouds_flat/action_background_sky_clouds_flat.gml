/// action_background_sky_clouds_flat(flat)
/// @arg flat

var flat;

if (history_undo)
	flat = history_data.old_value
else if (history_redo)
	flat = history_data.new_value
else
{
	flat = argument0
	history_set_var(action_background_sky_clouds_flat, background_sky_clouds_flat, flat, false)
}

background_sky_clouds_flat = flat
background_sky_update_clouds()
