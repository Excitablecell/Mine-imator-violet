/// render_high_fog()

var resultsurf;

render_surface[2] = surface_require(render_surface[2], render_width, render_height)
resultsurf = render_surface[2]
surface_set_target(resultsurf)
{
	draw_clear(c_black)
	render_world_start()
	render_world(e_render_mode.HIGH_FOG)
	render_world_done()
}
surface_reset_target()

return resultsurf
