/// settings_save()

log("Saving settings", settings_file)

json_save_start(settings_file)
json_save_object_start()
json_save_var("format", settings_format)

json_save_object_start("assets")

	json_save_var("version", setting_minecraft_assets_version)
	
	if (setting_minecraft_assets_new_version != "")
	{
		json_save_object_start("new")

			json_save_var("version", setting_minecraft_assets_new_version)
			json_save_var("format", setting_minecraft_assets_new_format)
			json_save_var("changes", json_string_encode(setting_minecraft_assets_new_changes))
			json_save_var("image", json_string_encode(setting_minecraft_assets_new_image))

		json_save_object_done()
	}
	
json_save_object_done()


json_save_array_start("recent_files")
	
	for (var i = 0; i < ds_list_size(recent_list); i++)
	{
		with (recent_list[|i])
		{
			json_save_object_start()
			json_save_var("filename", json_string_encode(filename))
			json_save_var("name", json_string_encode(name))
			json_save_var("author", json_string_encode(author))
			json_save_var("description", json_string_encode(description))
			json_save_object_done()
		}
	}
	
json_save_array_done()

json_save_array_start("closed_alerts")

	for (var i = 0; i < ds_list_size(closed_alert_list); i++)
		json_save_array_value(closed_alert_list[|i])
		
json_save_array_done()

json_save_object_start("program")

	json_save_var_bool("64bit_import", setting_64bit_import)
	json_save_var("fps", room_speed)
	json_save_var("project_folder", json_string_encode(setting_project_folder))
	json_save_var_bool("backup", setting_backup)
	json_save_var("backup_time", setting_backup_time)
	json_save_var("backup_amount", setting_backup_amount)
	json_save_var_bool("spawn_objects", setting_spawn_objects)
	json_save_var_bool("spawn_cameras", setting_spawn_cameras)
	json_save_var_bool("unlimited_values", setting_unlimited_values)

json_save_object_done()

json_save_object_start("interface")

	json_save_var_bool("tip_show", setting_tip_show)
	json_save_var("tip_delay", setting_tip_delay)

	json_save_var("view_grid_size_hor", setting_view_grid_size_hor)
	json_save_var("view_grid_size_ver", setting_view_grid_size_ver)
	json_save_var_bool("view_real_time_render", setting_view_real_time_render)
	json_save_var("view_real_time_render_time", setting_view_real_time_render_time)

	json_save_var("font_filename", json_string_encode(setting_font_filename))
	json_save_var("language_filename", json_string_encode(setting_language_filename))

	settings_save_colors()

	json_save_var_bool("timeline_autoscroll", setting_timeline_autoscroll)
	json_save_var_bool("timeline_compact", setting_timeline_compact)
	json_save_var_bool("timeline_select_jump", setting_timeline_select_jump)
	json_save_var_bool("z_is_up", setting_z_is_up)
	json_save_var_bool("smooth_camera", setting_smooth_camera)
	json_save_var_bool("search_variants", setting_search_variants)
	
	json_save_var("toolbar_location", toolbar_location)
	json_save_var("toolbar_size", toolbar_size)

	json_save_var("panel_left_bottom_size", panel_map[?"left_bottom"].size)
	json_save_var("panel_right_bottom_size", panel_map[?"right_bottom"].size)
	json_save_var("panel_bottom_size", panel_map[?"bottom"].size)
	json_save_var("panel_top_size", panel_map[?"top"].size)
	json_save_var("panel_left_top_size", panel_map[?"left_top"].size)
	json_save_var("panel_right_top_size", panel_map[?"right_top"].size)

	json_save_var("properties_location", properties.panel.location)
	json_save_var("ground_editor_location", ground_editor.panel.location)
	json_save_var("template_editor_location", template_editor.panel.location)
	json_save_var("timeline_location", timeline.panel.location)
	json_save_var("timeline_editor_location", timeline_editor.panel.location)
	json_save_var("frame_editor_location", frame_editor.panel.location)
	json_save_var_bool("frame_editor_color_advanced", frame_editor.color.advanced)
	json_save_var("settings_location", settings.panel.location)

	json_save_var("view_split", view_split)

	json_save_var_bool("view_main_controls", view_main.controls)
	json_save_var_bool("view_main_lights", view_main.lights)
	json_save_var_bool("view_main_particles", view_main.particles)
	json_save_var_bool("view_main_grid", view_main.grid)
	json_save_var_bool("view_main_aspect_ratio", view_main.aspect_ratio)
	json_save_var("view_main_location", view_main.location)

	json_save_var_bool("view_second_show", view_second.show)
	json_save_var_bool("view_second_controls", view_second.controls)
	json_save_var_bool("view_second_lights", view_second.lights)
	json_save_var_bool("view_second_particles", view_second.particles)
	json_save_var_bool("view_second_grid", view_second.grid)
	json_save_var_bool("view_second_aspect_ratio", view_second.aspect_ratio)
	json_save_var("view_second_location", view_second.location)
	json_save_var("view_second_width", view_second.width)
	json_save_var("view_second_height", view_second.height)
	
	json_save_var_bool("modelbench_popup_hidden", popup_modelbench.hidden)

json_save_object_done()

json_save_object_start("controls")

	json_save_var("key_new", setting_key_new)
	json_save_var_bool("key_new_control", setting_key_new_control)
	json_save_var("key_import_asset", setting_key_import_asset)
	json_save_var_bool("key_import_asset_control", setting_key_import_asset_control)
	json_save_var("key_open", setting_key_open)
	json_save_var_bool("key_open_control", setting_key_open_control)
	json_save_var("key_save", setting_key_save)
	json_save_var_bool("key_save_control", setting_key_save_control)
	json_save_var("key_undo", setting_key_undo)
	json_save_var_bool("key_undo_control", setting_key_undo_control)
	json_save_var("key_redo", setting_key_redo)
	json_save_var_bool("key_redo_control", setting_key_redo_control)
	json_save_var("key_play", setting_key_play)
	json_save_var_bool("key_play_control", setting_key_play_control)
	json_save_var("key_play_beginning", setting_key_play_beginning)
	json_save_var_bool("key_play_beginning_control", setting_key_play_beginning_control)
	json_save_var("key_move_marker_right", setting_key_move_marker_right)
	json_save_var_bool("key_move_marker_right_control", setting_key_move_marker_right_control)
	json_save_var("key_move_marker_left", setting_key_move_marker_left)
	json_save_var_bool("key_move_marker_left_control", setting_key_move_marker_left_control)
	json_save_var("key_render", setting_key_render)
	json_save_var_bool("key_render_control", setting_key_render_control)
	json_save_var("key_folder", setting_key_folder)
	json_save_var_bool("key_folder_control", setting_key_folder_control)
	json_save_var("key_select_timelines", setting_key_select_timelines)
	json_save_var_bool("key_select_timelines_control", setting_key_select_timelines_control)
	json_save_var("key_duplicate_timelines", setting_key_duplicate_timelines)
	json_save_var_bool("key_duplicate_timelines_control", setting_key_duplicate_timelines_control)
	json_save_var("key_remove_timelines", setting_key_remove_timelines)
	json_save_var_bool("key_remove_timelines_control", setting_key_remove_timelines_control)
	json_save_var("key_create_keyframes", setting_key_create_keyframes)
	json_save_var_bool("key_create_keyframes_control", setting_key_create_keyframes_control)
	json_save_var("key_copy_keyframes", setting_key_copy_keyframes)
	json_save_var_bool("key_copy_keyframes_control", setting_key_copy_keyframes_control)
	json_save_var("key_cut_keyframes", setting_key_cut_keyframes)
	json_save_var_bool("key_cut_keyframes_control", setting_key_cut_keyframes_control)
	json_save_var("key_paste_keyframes", setting_key_paste_keyframes)
	json_save_var_bool("key_paste_keyframes_control", setting_key_paste_keyframes_control)
	json_save_var("key_remove_keyframes", setting_key_remove_keyframes)
	json_save_var_bool("key_remove_keyframes_control", setting_key_remove_keyframes_control)
	json_save_var("key_spawn_particles", setting_key_spawn_particles)
	json_save_var_bool("key_spawn_particles_control", setting_key_spawn_particles_control)
	json_save_var("key_clear_particles", setting_key_clear_particles)
	json_save_var_bool("key_clear_particles_control", setting_key_clear_particles_control)
	json_save_var("key_forward", setting_key_forward)
	json_save_var("key_back", setting_key_back)
	json_save_var("key_left", setting_key_left)
	json_save_var("key_right", setting_key_right)
	json_save_var("key_ascend", setting_key_ascend)
	json_save_var("key_descend", setting_key_descend)
	json_save_var("key_roll_forward", setting_key_roll_forward)
	json_save_var("key_roll_back", setting_key_roll_back)
	json_save_var("key_roll_reset", setting_key_roll_reset)
	json_save_var("key_reset", setting_key_reset)
	json_save_var("key_fast", setting_key_fast)
	json_save_var("key_slow", setting_key_slow)
	json_save_var("move_speed", setting_move_speed)
	json_save_var("look_sensitivity", setting_look_sensitivity)
	json_save_var("fast_modifier", setting_fast_modifier)
	json_save_var("slow_modifier", setting_slow_modifier)

json_save_object_done()

json_save_object_start("graphics")

	json_save_var("bend_style", setting_bend_style)
	json_save_var_bool("schematic_remove_edges", setting_schematic_remove_edges)
	json_save_var_bool("liquid_animation", setting_liquid_animation)
	json_save_var_bool("noisy_grass_water", setting_noisy_grass_water)
	json_save_var_bool("texture_filtering", setting_texture_filtering)
	json_save_var_bool("transparent_block_texture_filtering", setting_transparent_block_texture_filtering)
	json_save_var("texture_filtering_level", setting_texture_filtering_level)
	json_save_var("block_brightness", setting_block_brightness)
	json_save_var("block_glow_threshold", setting_block_glow_threshold)
	json_save_var_bool("block_glow", setting_block_glow)
	json_save_var_bool("light_bleeding", setting_light_bleeding)

json_save_object_done()

json_save_object_start("render")

	json_save_var_bool("render_camera_effects", setting_render_camera_effects)
	json_save_var("render_dof_quality", setting_render_dof_quality)
	
	json_save_var_bool("render_ssao", setting_render_ssao)
	json_save_var("render_ssao_radius", setting_render_ssao_radius)
	json_save_var("render_ssao_power", setting_render_ssao_power)
	json_save_var("render_ssao_blur_passes", setting_render_ssao_blur_passes)
	json_save_var_color("render_ssao_color", setting_render_ssao_color)
	
	json_save_var_bool("render_shadows", setting_render_shadows)
	json_save_var("render_shadows_sun_buffer_size", setting_render_shadows_sun_buffer_size)
	json_save_var("render_shadows_spot_buffer_size", setting_render_shadows_spot_buffer_size)
	json_save_var("render_shadows_point_buffer_size", setting_render_shadows_point_buffer_size)
	json_save_var("render_shadows_blur_quality", setting_render_shadows_blur_quality)
	json_save_var("render_shadows_blur_size", setting_render_shadows_blur_size)
	
	json_save_var_bool("render_glow", setting_render_glow)
	json_save_var("render_glow_radius", setting_render_glow_radius)
	json_save_var("render_glow_intensity", setting_render_glow_intensity)
	json_save_var_bool("render_glow_falloff", setting_render_glow_falloff)
	json_save_var("render_glow_falloff_radius", setting_render_glow_falloff_radius)
	json_save_var("render_glow_falloff_intensity", setting_render_glow_falloff_intensity)
	
	json_save_var_bool("render_aa", setting_render_aa)
	json_save_var("render_aa_power", setting_render_aa_power)
	
	json_save_var_bool("render_watermark", setting_render_watermark)
	json_save_var("render_watermark_filename", json_string_encode(setting_render_watermark_filename))
	json_save_var("render_watermark_anchor_x", setting_render_watermark_anchor_x)
	json_save_var("render_watermark_anchor_y", setting_render_watermark_anchor_y)
	json_save_var("render_watermark_scale", setting_render_watermark_scale)
	json_save_var("render_watermark_alpha", setting_render_watermark_alpha)
	
	json_save_var("exportmovie_format", popup_exportmovie.format)
	json_save_var("exportmovie_frame_rate", popup_exportmovie.frame_rate)
	json_save_var("exportmovie_bit_rate", popup_exportmovie.bit_rate)
	json_save_var_bool("exportmovie_include_audio", popup_exportmovie.include_audio)
	json_save_var_bool("exportmovie_remove_background", popup_exportmovie.remove_background)
	json_save_var_bool("exportmovie_include_hidden", popup_exportmovie.include_hidden)
	json_save_var_bool("exportmovie_high_quality", popup_exportmovie.high_quality)
	json_save_var_bool("exportimage_remove_background", popup_exportimage.remove_background)
	json_save_var_bool("exportimage_include_hidden", popup_exportimage.include_hidden)
	json_save_var_bool("exportimage_high_quality", popup_exportimage.high_quality)

json_save_object_done()

json_save_object_start("checkbox_expand")

	json_save_var_bool("settings_ssso", checkbox_expand_settings_ssao)
	json_save_var_bool("settings_shadows", checkbox_expand_settings_shadows)
	json_save_var_bool("settings_glow", checkbox_expand_settings_glow)
	json_save_var_bool("settings_aa", checkbox_expand_settings_aa)
	json_save_var_bool("settings_watermark", checkbox_expand_settings_watermark)
	json_save_var_bool("background_clouds", checkbox_expand_background_clouds)
	json_save_var_bool("backgound_ground", checkbox_expand_background_ground)
	json_save_var_bool("background_fog", checkbox_expand_background_fog)
	json_save_var_bool("background_wind", checkbox_expand_background_wind)
	json_save_var_bool("frameeditor_rotatepoint", checkbox_expand_frameeditor_rotatepoint)
	json_save_var_bool("frameeditor_camshake", checkbox_expand_frameeditor_camshake)
	json_save_var_bool("frameeditor_dof", checkbox_expand_frameeditor_dof)
	json_save_var_bool("frameeditor_bloom", checkbox_expand_frameeditor_bloom)
	json_save_var_bool("frameeditor_lensdirt", checkbox_expand_frameeditor_lensdirt)
	json_save_var_bool("frameeditor_clrcor", checkbox_expand_frameeditor_clrcor)
	json_save_var_bool("frameeditor_grain", checkbox_expand_frameeditor_grain)
	json_save_var_bool("frameeditor_vignette", checkbox_expand_frameeditor_vignette)
	json_save_var_bool("frameeditor_ca", checkbox_expand_frameeditor_ca)
	json_save_var_bool("frameeditor_distort", checkbox_expand_frameeditor_distort)
	json_save_var_bool("frameeditor_itemslot", checkbox_expand_frameeditor_itemslot)

json_save_object_done()

json_save_object_done()
json_save_done()

debug("Saved settings")