/// temp_copy(to)
/// @arg to
/// @desc Copies all the variables into the given object.

var to = argument0;

to.type = type
to.name = name

to.model = model
to.model_tex = model_tex
to.model_name = model_name
to.model_state = array_copy_1d(model_state)
to.model_part_name = model_part_name

to.banner_base_color = banner_base_color
to.banner_pattern_list = array_copy_1d(banner_pattern_list)
to.banner_color_list = array_copy_1d(banner_color_list)
to.banner_skin = sprite_duplicate(banner_skin)

to.item_tex = item_tex
to.item_slot = item_slot
to.item_3d = item_3d
to.item_face_camera = item_face_camera
to.item_bounce = item_bounce
to.item_spin = item_spin

to.block_name = block_name
to.block_state = array_copy_1d(block_state)
to.block_tex = block_tex

to.scenery = scenery

to.block_repeat_enable = block_repeat_enable
to.block_repeat = array_copy_1d(block_repeat)

to.shape_tex = shape_tex
to.shape_tex_mapped = shape_tex_mapped
to.shape_tex_hoffset = shape_tex_hoffset
to.shape_tex_voffset = shape_tex_voffset
to.shape_tex_hrepeat = shape_tex_hrepeat
to.shape_tex_vrepeat = shape_tex_vrepeat
to.shape_tex_hmirror = shape_tex_hmirror
to.shape_tex_vmirror = shape_tex_vmirror
to.shape_closed = shape_closed
to.shape_invert = shape_invert
to.shape_detail = shape_detail
to.shape_face_camera = shape_face_camera

to.text_font = text_font
to.text_3d = text_3d
to.text_face_camera = text_face_camera

if (type = e_temp_type.PARTICLE_SPAWNER)
	temp_particles_copy(to)
