/// action_lib_pc_type_rot_random_max(value, add)
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
	history_set_var(action_lib_pc_type_rot_random_max, ptype_edit.rot_random_max[axis_edit], ptype_edit.rot_random_max[axis_edit] * add + val, true)
}

ptype_edit.rot_random_max[axis_edit] = ptype_edit.rot_random_max[axis_edit] * add + val
