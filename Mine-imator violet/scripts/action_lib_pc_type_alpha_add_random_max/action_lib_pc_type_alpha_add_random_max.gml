/// action_lib_pc_type_alpha_add_random_max(value, add)
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
	history_set_var(action_lib_pc_type_alpha_add_random_max, ptype_edit.alpha_add_random_max * 100, ptype_edit.alpha_add_random_max * add * 100 + val, true)
}

ptype_edit.alpha_add_random_max = ptype_edit.alpha_add_random_max * add + val / 100
