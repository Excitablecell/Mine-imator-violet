// update_easebezier_transition_texture(transition_texture_map, width, height, padding)
/// @arg transition_texture_map
/// @arg width
/// @arg height
/// @arg padding

map = argument0
w = argument1
h = argument2
padding = argument3


surf = surface_create(w, h)
surface_set_target(surf)
{
	draw_set_color(c_white)

	wp = w - padding * 2
	hp = h - padding * 2

	draw_clear_alpha(c_black, 0)
	for (var xx = 0; xx <= 1; xx += 1/wp)
	{
		draw_line(padding + floor((xx - 1/wp) * wp), 
					padding + floor((1 - bezier_generate(xx - 1 / wp, 
						tl_edit.value[e_value.BEZIER],
						tl_edit.value[e_value.BEZIERY],
						tl_edit.value[e_value.BEZIER2X],
						tl_edit.value[e_value.BEZIER2Y]
						)) * hp), 
					padding + floor(xx * wp), 
					padding + floor((1 - bezier_generate(xx, 
						tl_edit.value[e_value.BEZIER],
						tl_edit.value[e_value.BEZIERY],
						tl_edit.value[e_value.BEZIER2X],
						tl_edit.value[e_value.BEZIER2Y]
						)) * hp))
		draw_line(	padding, 
					padding + hp, 
					padding + floor(tl_edit.value[e_value.BEZIER] * wp), 
					padding + floor((1 - tl_edit.value[e_value.BEZIERY]) * hp))
		draw_line(	padding + hp, 
					padding, 
					padding + floor(tl_edit.value[e_value.BEZIER2X] * wp), 
					padding + floor((1 - tl_edit.value[e_value.BEZIER2Y]) * hp))
		draw_circle(padding + floor(tl_edit.value[e_value.BEZIER] * wp),padding + floor((1 - tl_edit.value[e_value.BEZIERY]) * hp),2,true)
		draw_circle(padding + floor((tl_edit.value[e_value.BEZIER2X]) * wp),padding + floor((1 - tl_edit.value[e_value.BEZIER2Y]) * hp),2,true)
	}
	
	map[?"easebezier"] = texture_surface(surf)
	
}
surface_reset_target()
surface_free(surf)