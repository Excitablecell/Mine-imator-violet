/// render_high_distort(basesurf)
/// @arg basesurf

var prevsurf, resultsurf;
prevsurf = argument0
resultsurf = render_high_get_apply_surf()
	
surface_set_target(resultsurf)
{
	draw_clear_alpha(c_black, 0)
		
	render_shader_obj = shader_map[?shader_distort]
	with (render_shader_obj)
		shader_use()
	draw_surface_exists(prevsurf, 0, 0)
	with (render_shader_obj)
		shader_clear()
}
surface_reset_target()

return resultsurf
