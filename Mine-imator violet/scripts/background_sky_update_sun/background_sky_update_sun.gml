// background_sky_update_sun()

background_light_data[0] = lengthdir_x(background_sunlight_range, background_sky_rotation - 90) * lengthdir_x(1, background_sky_time + 90) + cam_from[X] * background_sunlight_follow
background_light_data[1] = lengthdir_y(background_sunlight_range, background_sky_rotation - 90) * lengthdir_x(1, background_sky_time + 90) + cam_from[Y] * background_sunlight_follow
background_light_data[2] = lengthdir_z(background_sunlight_range, background_sky_time + 90)
if (background_sky_time = 0)
	background_light_data[0] += 0.1
background_light_data[3] = background_sunlight_range / 2
background_light_data[4] = color_get_red(background_sunlight_color_final) / 255
background_light_data[5] = color_get_green(background_sunlight_color_final) / 255
background_light_data[6] = color_get_blue(background_sunlight_color_final) / 255
background_light_data[7] = background_sunlight_range * 2