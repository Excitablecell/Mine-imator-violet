/// action_lib_shape_closed(closed)
/// @arg closed

var closed;

if (history_undo)
	closed = history_data.old_value
else if (history_redo)
	closed = history_data.new_value
else
{
	closed = argument0
	history_set_var(action_lib_shape_closed, temp_edit.shape_closed, closed, false)
}
	
with (temp_edit)
{
	shape_closed = closed
	temp_update_shape()
}
lib_preview.update = true
