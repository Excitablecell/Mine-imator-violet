/// tl_new_part(part)
/// @arg part

var part = argument0;

with (new(obj_timeline))
{
	type = e_tl_type.BODYPART
	temp = other.temp
	
	model_part = part
	model_part_name = part.name
	
	part_of = other.id
	inherit_alpha = true
	inherit_color = true
	inherit_texture = true
	inherit_rot_point = true
	scale_resize = false
	lock_bend = part.lock_bend
	part_mixing_shapes = part.part_mixing_shapes
	colors_ext = part_mixing_shapes
	
	value_type_show[e_value_type.POSITION] = part.show_position
	part_parent_save_id = ""
	
	depth = part.depth
	
	tl_set_parent(other.id)
	tl_update_depth()
	tl_value_spawn()
	
	return id
}