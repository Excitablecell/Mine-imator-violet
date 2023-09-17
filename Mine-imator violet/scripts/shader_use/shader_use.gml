/// shader_use()
/// @desc Sets the shader and defines the common uniforms

shader_set(shader)

// Default color
shader_blend_color = c_white
shader_blend_alpha = 1
render_set_uniform_color("uBlendColor", c_white, 1)

// Set wind
if (!is_undefined(uniform_map[?"uTime"]) && uniform_map[?"uTime"] > -1)
{
	render_set_uniform("uTime", current_step)
	render_set_uniform("uWindEnable", 0)
	render_set_uniform("uWindTerrain", 1)
	render_set_uniform("uWindSpeed", app.background_wind * app.background_wind_speed)
	render_set_uniform("uWindStrength", app.background_wind_strength) 
}

// Set fog
if (!is_undefined(uniform_map[?"uFogShow"]) && uniform_map[?"uFogShow"] > -1)
{
	var fog = (render_lights && app.background_fog_show);
	render_set_uniform_int("uFogShow", bool_to_float(fog))

	if (fog)
	{
		render_set_uniform_color("uFogColor", app.background_fog_object_color_final, 1)
		render_set_uniform("uFogDistance", app.background_fog_distance)
		render_set_uniform("uFogSize", app.background_fog_size + (app.background_fog_size * 3 * max(app.background_sunrise_alpha, app.background_sunset_alpha)))
		render_set_uniform("uFogHeight", app.background_fog_height)
		render_set_uniform("uHeightFogStart", app.background_fog_start)
		render_set_uniform("uHeightFogEnd", app.background_fog_end)
		render_set_uniform("uDensity_Decrease", app.background_fog_density)
		
		render_set_uniform("uNoiseThreshold", app.v_fog_threshold)
		render_set_uniform("uVFogBottom", app.v_fog_bottom)
		render_set_uniform("uVFogTop", app.v_fog_top)
		render_set_uniform("uVFogWide", app.v_fog_wide)
		
		render_set_uniform("uVFogDensity", app.v_fog_density)
		render_set_uniform("uVFogPositionX", app.v_fog_pos_x)
		render_set_uniform("uVFogSize",app.v_fog_size)
		render_set_uniform("uVFogPositionY", app.v_fog_pos_y)
		render_set_uniform("uVFogPositionZ", app.v_fog_pos_z)
		render_set_uniform("uOffx", app.fog_off_x)
		render_set_uniform("uOffy", app.fog_off_y)
		render_set_uniform("uOffz", app.fog_off_z)
	}else if(app.background_fog_show)
	{
		render_set_uniform("uNoiseThreshold", app.v_fog_threshold)
		render_set_uniform("uVFogBottom", app.v_fog_bottom)
		render_set_uniform("uVFogTop", app.v_fog_top)
		render_set_uniform("uVFogWide", app.v_fog_wide)
		render_set_uniform("uVFogSize",app.v_fog_size)
		render_set_uniform("uVFogDensity", app.v_fog_density)
		render_set_uniform("uVFogPositionX", app.v_fog_pos_x)
		render_set_uniform("uVFogPositionY", app.v_fog_pos_y)
		render_set_uniform("uVFogPositionZ", app.v_fog_pos_z)
		render_set_uniform("uOffx", app.fog_off_x)
		render_set_uniform("uOffy", app.fog_off_y)
		render_set_uniform("uOffz", app.fog_off_z)
	}
}


// Set camera position
if (!is_undefined(uniform_map[?"uCameraPosition"]) && uniform_map[?"uCameraPosition"] > -1)
	render_set_uniform_vec3("uCameraPosition", cam_from[X], cam_from[Y], cam_from[Z])

// Block brightness
if (!is_undefined(uniform_map[?"uBlockBrightness"]) && uniform_map[?"uBlockBrightness"] > -1)
	render_set_uniform("uBlockBrightness", app.setting_block_brightness)
	
// Block brightness threshold
if (!is_undefined(uniform_map[?"uGlowThreshold"]) && uniform_map[?"uGlowThreshold"] > -1)
	render_set_uniform("uGlowThreshold", app.setting_block_glow_threshold)
	
// Light bleeding
if (!is_undefined(uniform_map[?"uLightBleed"]) && uniform_map[?"uLightBleed"] > -1)
	render_set_uniform("uLightBleed", bool_to_float(app.setting_light_bleeding))

// Texture drawing
render_set_uniform("uMask", bool_to_float(shader_mask))

// Init script
if (script > -1)
	script_execute(script)