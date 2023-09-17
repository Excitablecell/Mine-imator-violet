/// project_load_background(map)
/// @arg map

var map = argument0;

if (!ds_map_valid(map))
	return 0

background_loaded = true

background_image_show = value_get_real(map[?"image_show"], background_image_show)
if (background_image != null)
	background_image.count--
background_image = value_get_save_id(map[?"image"], background_image)
background_image_type = value_get_string(map[?"image_type"], background_image_type)
background_image_stretch = value_get_real(map[?"image_stretch"], background_image_stretch)
background_image_box_mapped = value_get_real(map[?"image_box_mapped"], background_image_box_mapped)
background_image_rotation = value_get_real(map[?"image_rotation"], background_image_rotation)

background_sky_sun_tex.count--
background_sky_sun_tex = value_get_save_id(map[?"sky_sun_tex"], background_sky_sun_tex)
background_sky_moon_tex.count--
background_sky_moon_tex = value_get_save_id(map[?"sky_moon_tex"], background_sky_moon_tex)
background_sky_moon_phase = value_get_real(map[?"sky_moon_phase"], background_sky_moon_phase)

background_sky_time = value_get_real(map[?"sky_time"], background_sky_time)
background_sky_rotation = value_get_real(map[?"sky_rotation"], background_sky_rotation)
background_sunlight_range = value_get_real(map[?"sunlight_range"], background_sunlight_range)
background_sunlight_follow = value_get_real(map[?"sunlight_follow"], background_sunlight_follow)
background_sunlight_strength = value_get_real(map[?"sunlight_strength"], background_sunlight_strength)

background_desaturate_night = value_get_real(map[?"desaturate_night"], background_desaturate_night)
background_desaturate_night_amount = value_get_real(map[?"desaturate_night_amount"], background_desaturate_night_amount)

background_sky_clouds_show = value_get_real(map[?"sky_clouds_show"], background_sky_clouds_show)
background_sky_clouds_flat = value_get_real(map[?"sky_clouds_flat"], background_sky_clouds_flat)
background_sky_clouds_story_mode = value_get_real(map[?"sky_clouds_story_mode"], background_sky_clouds_story_mode)
background_sky_clouds_tex.count--
background_sky_clouds_tex = value_get_save_id(map[?"sky_clouds_tex"], background_sky_clouds_tex)
background_sky_clouds_speed = value_get_real(map[?"sky_clouds_speed"], background_sky_clouds_speed)
background_sky_clouds_z = value_get_real(map[?"sky_clouds_z"], background_sky_clouds_z)
background_sky_clouds_size = value_get_real(map[?"sky_clouds_size"], background_sky_clouds_size)
background_sky_clouds_height = value_get_real(map[?"sky_clouds_height"], background_sky_clouds_height)
background_sky_clouds_offset = value_get_real(map[?"sky_clouds_offset"], background_sky_clouds_offset)

background_ground_show = value_get_real(map[?"ground_show"], background_ground_show)
background_ground_name = value_get_string(map[?"ground_name"], background_ground_name)

if (load_format < e_project.FORMAT_120_PRE_1)
{
	background_ground_name = string_replace(background_ground_name, "blocks/", "block/")
	var newname = ds_map_find_key(legacy_block_texture_name_map, background_ground_name);
	if (!is_undefined(newname))
		background_ground_name = newname
}

background_ground_slot = ds_list_find_index(mc_assets.block_texture_list, background_ground_name)
if (background_ground_slot < 0) // Animated
	background_ground_slot = ds_list_size(mc_assets.block_texture_list) + ds_list_find_index(mc_assets.block_texture_ani_list, background_ground_name)
background_ground_tex.count--
background_ground_tex = value_get_save_id(map[?"ground_tex"], background_ground_tex)

background_biome = find_biome(value_get_string(map[?"biome"], background_biome.name))

background_sky_color = value_get_color(map[?"sky_color"], background_sky_color)
background_sky_clouds_color = value_get_color(map[?"sky_clouds_color"], background_sky_clouds_color)
background_sunlight_color = value_get_color(map[?"sunlight_color"], background_sunlight_color)
background_ambient_color = value_get_color(map[?"ambient_color"], background_ambient_color)
background_night_color = value_get_color(map[?"night_color"], background_night_color)

background_grass_color = value_get_color(map[?"grass_color"], background_grass_color)
background_foliage_color = value_get_color(map[?"foliage_color"], background_foliage_color)
background_water_color = value_get_color(map[?"water_color"], background_water_color)

background_fog_show = value_get_real(map[?"fog_show"], background_fog_show)
background_fog_sky = value_get_real(map[?"fog_sky"], background_fog_sky)
background_fog_color_custom = value_get_real(map[?"fog_color_custom"], background_fog_color_custom)
background_fog_color = value_get_color(map[?"fog_color"], background_fog_color)
background_fog_object_color_custom = value_get_real(map[?"fog_object_color_custom"], background_fog_object_color_custom)
background_fog_object_color = value_get_color(map[?"fog_object_color"], background_fog_object_color)
background_fog_distance = value_get_real(map[?"fog_distance"], background_fog_distance)
background_fog_size = value_get_real(map[?"fog_size"], background_fog_size)
background_fog_height = value_get_real(map[?"fog_height"], background_fog_height)
background_fog_start = value_get_real(map[?"fog_start"], background_fog_start)
background_fog_end = value_get_real(map[?"fog_end"], background_fog_end)
background_fog_density = value_get_real(map[?"fog_density"], background_fog_density)

v_fog_wide = value_get_real(map[?"vfog_wide"], v_fog_wide)
v_fog_bottom = value_get_real(map[?"vfog_bottom"], v_fog_bottom)
v_fog_top = value_get_real(map[?"vfog_top"], v_fog_top)
v_fog_threshold = value_get_real(map[?"vfog_noisethreshold"], v_fog_threshold)

v_fog_density = value_get_real(map[?"vfog_density"], v_fog_density)
v_fog_size = value_get_real(map[?"vfog_size"], v_fog_size)
v_fog_pos_x = value_get_real(map[?"vfog_pos_x"], v_fog_pos_x)
v_fog_pos_y = value_get_real(map[?"vfog_pos_y"], v_fog_pos_y)
v_fog_pos_z = value_get_real(map[?"vfog_pos_z"], v_fog_pos_z)
fog_off_x = value_get_real(map[?"fog_off_x"], fog_off_x)
fog_off_y = value_get_real(map[?"fog_off_y"], fog_off_y)
fog_off_z = value_get_real(map[?"fog_off_z"], fog_off_z)

background_wind = value_get_real(map[?"wind"], background_wind)
background_wind_speed = value_get_real(map[?"wind_speed"], background_wind_speed)
background_wind_strength = value_get_real(map[?"wind_strength"], background_wind_strength)

background_opaque_leaves = value_get_real(map[?"opaque_leaves"], background_opaque_leaves)
background_texture_animation_speed = value_get_real(map[?"texture_animation_speed"], background_texture_animation_speed)
