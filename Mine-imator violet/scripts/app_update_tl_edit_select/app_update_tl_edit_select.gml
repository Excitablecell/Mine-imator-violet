/// app_update_tl_edit_select()

with (frame_editor)
{
	position.show = false
	position.enabled = false
	rotation.show = false
	rotation.enabled = false
	scale.enabled = false
	bend.show = false
	bend.enabled = false
	color.enabled = false
	particles.enabled = false
	light.enabled = false
	light.has_spotlight = false
	camera.show = false
	camera.enabled = false
	camera.video_template = null
	texture.enabled = false
	sound.enabled = false
	text.enabled = false
	item.enabled = false
	keyframe.enabled = false
}

with (timeline_editor)
{
	graphics.enabled = false
	audio.enabled = false
}

select_kf_amount = 0
select_kf_single = null

timeline_settings = false
timeline_settings_import_loop_tl = null
timeline_settings_walk_fn = ""
timeline_settings_run_fn = ""
timeline_settings_keyframes = false
timeline_settings_keyframes_export = false

var checkwalk, checkexport, checkexportobj;
checkwalk = true
checkexport = true
checkexportobj = null

with (obj_timeline)
{
	if (!selected)
		continue
		
	// Show duplicate & remove settings?
	if (part_of = null)
		app.timeline_settings = true
		
	if (keyframe_select != null)
	{
		// Show walk setting?
		if (checkwalk)
		{
			checkwalk = false
			app.timeline_settings_import_loop_tl = null
			if (type = e_tl_type.CHARACTER)
			{
				if (keyframe_select_amount = 1 && keyframe_select != null && ds_list_find_index(keyframe_list, keyframe_select) < ds_list_size(keyframe_list) - 1)
				{
					checkwalk = true
					app.timeline_settings_import_loop_tl = id
				}
			}
		}
	
		// Show keyframe settings?
		app.timeline_settings_keyframes = true
		
		// Show export button?
		if (checkexport)
		{
			var obj = test((part_of != null), part_of, id);
			if (checkexportobj = null)
			{
				checkexportobj = obj
				app.timeline_settings_keyframes_export = true
			}
			else if (checkexportobj != obj)
			{
				checkexport = false
				app.timeline_settings_keyframes_export = false
			}
		}
	}
		
	// Set enabled
	if (value_type[e_value_type.POSITION])
		app.frame_editor.position.enabled = true
		
	if (value_type[e_value_type.ROTATION])
		app.frame_editor.rotation.enabled = true
		
	if (value_type[e_value_type.SCALE])
		app.frame_editor.scale.enabled = true
		
	if (value_type[e_value_type.BEND])
		app.frame_editor.bend.enabled = true
		
	if (value_type[e_value_type.COLOR])
		app.frame_editor.color.enabled = true
		
	if (value_type[e_value_type.PARTICLES])
		app.frame_editor.particles.enabled = true
		
	if (value_type[e_value_type.LIGHT])
		app.frame_editor.light.enabled = true
		
	if (value_type[e_value_type.SPOTLIGHT])
		app.frame_editor.light.has_spotlight = true
		
	if (value_type[e_value_type.CAMERA])
		app.frame_editor.camera.enabled = true
		
	if (value_type[e_value_type.TEXTURE])
		app.frame_editor.texture.enabled = true
		
	if (value_type[e_value_type.SOUND])
		app.frame_editor.sound.enabled = true
		
	if (value_type[e_value_type.TEXT])
		app.frame_editor.text.enabled = true
		
	if (value_type[e_value_type.ITEM])
		app.frame_editor.item.enabled = true
		
	if (value_type[e_value_type.KEYFRAME])
		app.frame_editor.keyframe.enabled = true
		
	if (value_type[e_value_type.GRAPHICS])
		app.timeline_editor.graphics.enabled = true
		
	if (value_type[e_value_type.AUDIO])
		app.timeline_editor.audio.enabled = true
		
	// Set shown
	if (value_type_show[e_value_type.POSITION])
		app.frame_editor.position.show = true
		
	if (value_type_show[e_value_type.ROTATION])
		app.frame_editor.rotation.show = true
	
	if (value_type_show[e_value_type.SCALE])
		app.frame_editor.scale.show = true
		
	if (value_type_show[e_value_type.BEND])
		app.frame_editor.bend.show = true
		
	if (value_type_show[e_value_type.CAMERA])
		app.frame_editor.camera.show = true
}

if (timeline_settings_import_loop_tl != null)
{
	// Use walk/run cycles based on model file name, if they don't exist, use cycles based on model
	var name = timeline_settings_import_loop_tl.temp.model_file.name;
	timeline_settings_walk_fn = load_assets_startup_dir + mc_loops_directory + name + "_walk.miframes"
	timeline_settings_run_fn = load_assets_startup_dir + mc_loops_directory + name + "_run.miframes"
	
	if (!file_exists(timeline_settings_walk_fn))
	{
		name = timeline_settings_import_loop_tl.temp.model_name
		timeline_settings_walk_fn = load_assets_startup_dir + mc_loops_directory + name + "_walk.miframes"
	}
	
	if (!file_exists(timeline_settings_run_fn))
	{
		name = timeline_settings_import_loop_tl.temp.model_name
		timeline_settings_run_fn = load_assets_startup_dir + mc_loops_directory + name + "_run.miframes"
	}
}
