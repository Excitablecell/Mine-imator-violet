/// render_high_bloom(basesurf)
/// @arg basesurf

var prevsurf, thresholdsurf, resultsurf, lensprev;
prevsurf = argument0
render_surface[0] = surface_require(render_surface[0], render_width, render_height)
thresholdsurf = render_surface[0]

// Apply Bloom
resultsurf = render_high_get_apply_surf()

// Bloom threshold
surface_set_target(thresholdsurf)
{
	draw_clear_alpha(c_black, 1)
	gpu_set_texfilter(true)
	gpu_set_texrepeat(false)
		
	render_shader_obj = shader_map[?shader_high_bloom_threshold]
	with (render_shader_obj)
	{
		shader_set(shader)
		shader_high_bloom_threshold_set()
	}
	draw_surface_exists(prevsurf, 0, 0)
	with (render_shader_obj)
		shader_clear()
			
	gpu_set_texfilter(false)
	gpu_set_texrepeat(true)
}
surface_reset_target()

// Repeat for each blade
var blades, bladerot, bladestrength;
blades = max(1, render_camera.value[e_value.CAM_BLADE_AMOUNT]/2)
blades = test(frac(blades) > 0, render_camera.value[e_value.CAM_BLADE_AMOUNT], blades)

for (var b = 0; b < blades; b++)
{
	bladerot = degtorad((180/blades) * b)
	
	// Blur
	var bloomsurf, bloomsurftemp;
	render_surface[1] = surface_require(render_surface[1], render_width, render_height)
	bloomsurf = render_surface[1]
	render_surface[2] = surface_require(render_surface[2], render_width, render_height)
	bloomsurftemp = render_surface[2]
	
	render_shader_obj = shader_map[?shader_blur]
	with (render_shader_obj)
		shader_set(shader)
	
	// Radius changes based on the render height to make it consistant with the size of the render
	var baseradius = ((render_camera.value[e_value.CAM_BLOOM_RADIUS] * 10) * render_height / 500);
	gpu_set_tex_repeat(false)
	gpu_set_texfilter(true)

	for (var i = 0; i < 3; i++)
	{
		var radius = baseradius / (1 + 1.333 * i);
		
		// Horizontal
		surface_set_target(bloomsurftemp)
		{
			draw_clear_alpha(c_black, 1)
				
			var rot = ((pi*2)/(360/render_camera.value[e_value.CAM_BLADE_ANGLE]));
			var xoff, yoff;
			xoff = lerp(1, cos(bladerot + rot), render_camera.value[e_value.CAM_BLOOM_RATIO])
			yoff = lerp(0, sin(bladerot + rot), render_camera.value[e_value.CAM_BLOOM_RATIO])
				
			with (render_shader_obj)
				shader_blur_set(render_width, render_height, radius, xoff, yoff)
				
			if (i = 0)
				draw_surface_exists(thresholdsurf, 0, 0)
			else
				draw_surface_exists(bloomsurf, 0, 0)
		}
		surface_reset_target()
		
		// Vertical
		surface_set_target(bloomsurf)
		{
			var xoff, yoff;
			xoff = lerp(0, 0, render_camera.value[e_value.CAM_BLOOM_RATIO])
			yoff = lerp(1, 0, render_camera.value[e_value.CAM_BLOOM_RATIO])
				
			with (render_shader_obj)
				shader_blur_set(render_width, render_height, radius, xoff, yoff)
			
			draw_surface_exists(bloomsurftemp, 0, 0)
		}
		surface_reset_target()
	}
	
	with (render_shader_obj)
		shader_clear()
		
	gpu_set_tex_repeat(true)
	gpu_set_texfilter(false)
	
	// Add to surface
	if (b = 0)
		bladestrength = lerp(1, 1/blades, render_camera.value[e_value.CAM_BLOOM_RATIO])
	else
		bladestrength = lerp(0, 1/blades, render_camera.value[e_value.CAM_BLOOM_RATIO])

	bladestrength *= render_camera.value[e_value.CAM_BLOOM_INTENSITY]
	
	surface_set_target(resultsurf)
	{
		draw_clear_alpha(c_black, 0)
		
		render_shader_obj = shader_map[?shader_add]
		with (render_shader_obj)
		{
			shader_set(shader)
			shader_add_set(bloomsurf, bladestrength, render_camera.value[e_value.CAM_BLOOM_BLEND])
		}
		draw_surface_exists(prevsurf, 0, 0)
		with (render_shader_obj)
			shader_clear()
	}
	surface_reset_target()
	
	// Add to lens
	if (render_camera_lens_dirt_bloom)
	{
		render_surface[3] = surface_require(render_surface[3], render_width, render_height)
		lensprev = render_surface[3]
		
		surface_set_target(lensprev)
		{
			draw_clear_alpha(c_black, 0)
			draw_surface(render_surface_lens, 0, 0)
		}
		surface_reset_target()
		
		surface_set_target(render_surface_lens)
		{
			render_shader_obj = shader_map[?shader_add]
			with (render_shader_obj)
			{
				shader_set(shader)
				shader_add_set(bloomsurf, render_camera.value[e_value.CAM_BLOOM_INTENSITY], render_camera.value[e_value.CAM_BLOOM_BLEND])
			}
			draw_surface_exists(lensprev, 0, 0)
			with (render_shader_obj)
				shader_clear()
		}
		surface_reset_target()
	}
	
	// Update previous surface for next blades
	if (b < blades)
	{
		surface_set_target(prevsurf)
		{
			draw_clear_alpha(c_black, 0)
			draw_surface_exists(resultsurf, 0, 0)
		}
		surface_reset_target()
	}
}

return resultsurf
