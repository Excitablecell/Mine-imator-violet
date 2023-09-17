/// tl_value_clamp(valueid, value)
/// @arg valueid
/// @arg value

var vid, val;
vid = argument0
val = argument1

if (app.setting_unlimited_values)
{
	if (tl_value_is_string(vid) || tl_value_is_bool(vid))
		return val
	else if (tl_value_is_color(vid))
		return clamp(val, c_black, c_white)
	else
		return clamp(val, -no_limit, no_limit)
}

switch (vid)
{
	case e_value.POS_X:
	case e_value.POS_Y:
	case e_value.POS_Z: return clamp(val, -world_size, world_size)
	case e_value.SCA_X:
	case e_value.SCA_Y:
	case e_value.SCA_Z: return max(val, 0.0001)
	case e_value.BG_SUNLIGHT_STRENGTH:
	case e_value.ALPHA:
	case e_value.MIX_PERCENT:
	case e_value.BRIGHTNESS:
	case e_value.CAM_BLOOM_THRESHOLD:
	case e_value.CAM_CONTRAST:
	case e_value.CAM_VIGNETTE_RADIUS:
	case e_value.CAM_VIGNETTE_SOFTNESS:
	case e_value.CAM_VIGNETTE_STRENGTH:
	case e_value.CAM_CA_RED_OFFSET:
	case e_value.CAM_CA_GREEN_OFFSET:
	case e_value.CAM_CA_BLUE_OFFSET: return clamp(val, 0, 1)
	case e_value.RGB_ADD:
	case e_value.RGB_SUB:
	case e_value.RGB_MUL:
	case e_value.HSB_ADD:
	case e_value.HSB_SUB:
	case e_value.HSB_MUL:
	case e_value.MIX_COLOR:
	case e_value.GLOW_COLOR:
	case e_value.LIGHT_COLOR:
	case e_value.CAM_BLOOM_BLEND:
	case e_value.CAM_COLOR_BURN:
	case e_value.CAM_VIGNETTE_COLOR:
	case e_value.BG_SKY_COLOR: 
	case e_value.BG_SKY_CLOUDS_COLOR:
	case e_value.BG_SUNLIGHT_COLOR:
	case e_value.BG_AMBIENT_COLOR:
	case e_value.BG_NIGHT_COLOR:
	case e_value.BG_GRASS_COLOR:
	case e_value.BG_FOLIAGE_COLOR:
	case e_value.BG_WATER_COLOR:
	case e_value.BG_FOG_COLOR:
	case e_value.BG_FOG_OBJECT_COLOR: return clamp(val, c_black, c_white)
	case e_value.BEND_ANGLE_X:
	case e_value.BEND_ANGLE_Y:
	case e_value.BEND_ANGLE_Z: return clamp(val, -180, 180)
	case e_value.CAM_FOV: return clamp(val, 1, 170)
	case e_value.CAM_BLADE_AMOUNT: return clamp(val, 0, 32)
	case e_value.CAM_BLADE_ANGLE: return clamp(val, 0, 360)
	case e_value.CAM_ROTATE_DISTANCE: return max(1, val)
	case e_value.CAM_ROTATE_ANGLE_Z: return clamp(val, -89.9, 89.9)
	case e_value.CAM_SHAKE_VERTICAL_SPEED:
	case e_value.CAM_SHAKE_HORIZONTAL_SPEED: return clamp(val, 0, 8)
	case e_value.CAM_SHAKE_VERTICAL_STRENGTH:
	case e_value.CAM_SHAKE_HORIZONTAL_STRENGTH: return clamp(val, 0, 8)
	case e_value.CAM_WIDTH:
	case e_value.CAM_HEIGHT: return max(1, val)
	case e_value.BG_SKY_MOON_PHASE: return clamp(val, 0, 7)
	case e_value.BG_FOG_DISTANCE: return clamp(val, 10, world_size)
	case e_value.BG_FOG_SIZE: return clamp(val, 10, world_size)
	case e_value.BG_FOG_HEIGHT: return clamp(val, 10, 2000)
	case e_value.BG_WIND_SPEED: return clamp(val, 0, 1)
	case e_value.BG_WIND_STRENGTH: return clamp(val, 0, 8)
	case e_value.BG_TEXTURE_ANI_SPEED: return max(val, 0)
	case e_value.SOUND_VOLUME: return clamp(val, 0, 1)
	case e_value.SOUND_START: return max(val, 0)
	case e_value.TEXT:
	case e_value.TEXT_HALIGN:
	case e_value.TEXT_VALIGN:
	case e_value.TRANSITION: return val
}

return clamp(val, -no_limit, no_limit)
