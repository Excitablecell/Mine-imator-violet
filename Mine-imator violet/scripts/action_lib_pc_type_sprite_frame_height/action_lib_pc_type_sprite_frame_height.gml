/// action_lib_pc_type_sprite_frame_height(value, add)
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
	history_set_var(action_lib_pc_type_sprite_frame_height, ptype_edit.sprite_frame_height, ptype_edit.sprite_frame_height * add + val, true)
}

with (ptype_edit)
{
	sprite_frame_height = sprite_frame_height * add + val
	ptype_update_sprite_vbuffers()
}

tab_template_editor_particles_preview_restart()
