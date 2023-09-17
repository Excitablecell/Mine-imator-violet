/// action_lib_pc_type_color_mix(color)
/// @arg color

var col;

if (history_undo)
	col = history_data.old_value
else if (history_redo)
	col = history_data.new_value
else
{
	col = argument0
	history_set_var(action_lib_pc_type_color_mix, ptype_edit.color_mix, col, true)
}

ptype_edit.color_mix = col
