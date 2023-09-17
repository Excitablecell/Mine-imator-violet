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
		tl_value_set_start(action_v_fog_noiseSize, true)
		tl_value_set(e_value.VFOGSIZE, val, add)
		tl_value_set_done()
		return 0
	}
	history_set_var(action_v_fog_noiseSize, v_fog_size, v_fog_size * add + val, true)
}

v_fog_size = v_fog_size * add + val