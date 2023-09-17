/// tl_value_default(valueid)
/// @arg valueid

switch (argument0)
{
	case e_value.SCA_X:
	case e_value.SCA_Y:
	case e_value.SCA_Z: return 1
	case e_value.ALPHA: return 1
	case e_value.GLOW_COLOR:
	case e_value.RGB_MUL:
	case e_value.HSB_MUL: return c_white
	case e_value.SPAWN: return true
	case e_value.FREEZE: return false
	case e_value.CLEAR: return false
	case e_value.CUSTOM_SEED: return false
	case e_value.SEED: return ceil(random(32000))
	case e_value.FORCE: return 1
	case e_value.LIGHT_COLOR: return c_white
	case e_value.LIGHT_RANGE: return 250
	case e_value.LIGHT_FADE_SIZE: return 0.5
	case e_value.LIGHT_SPOT_RADIUS: return 50
	case e_value.LIGHT_SPOT_SHARPNESS: return 0.5
	case e_value.CAM_FOV: return 45
	case e_value.CAM_F: return 50
	case e_value.CAM_F_ENABLE: return true
	case e_value.CAM_BLADE_AMOUNT: return 0
	case e_value.CAM_BLADE_ANGLE: return 0
	case e_value.CAM_ROTATE_DISTANCE: return 100
	case e_value.CAM_SHAKE_STRENGTH: return .25
	case e_value.CAM_SHAKE_VERTICAL_OFFSET:
	case e_value.CAM_SHAKE_HORIZONTAL_OFFSET: return 0
	case e_value.CAM_SHAKE_VERTICAL_SPEED:
	case e_value.CAM_SHAKE_HORIZONTAL_SPEED: return 1
	case e_value.CAM_SHAKE_VERTICAL_STRENGTH:
	case e_value.CAM_SHAKE_HORIZONTAL_STRENGTH: return 1
	case e_value.CAM_DOF_RANGE: return 200
	case e_value.CAM_DOF_FADE_SIZE: return 100
	case e_value.CAM_DOF_BLUR_SIZE: return .01
	case e_value.CAM_DOF_BLUR_RATIO: return 0
	case e_value.CAM_DOF_BIAS: return 0
	case e_value.CAM_DOF_THRESHOLD: return 0
	case e_value.CAM_DOF_GAIN: return 0
	case e_value.CAM_DOF_FRINGE_RED:
	case e_value.CAM_DOF_FRINGE_GREEN:
	case e_value.CAM_DOF_FRINGE_BLUE: return 1
	case e_value.CAM_DOF_FRINGE_ANGLE_RED: return 90
	case e_value.CAM_DOF_FRINGE_ANGLE_GREEN: return -135
	case e_value.CAM_DOF_FRINGE_ANGLE_BLUE: return -45
	case e_value.CAM_BLOOM_THRESHOLD: return .85
	case e_value.CAM_BLOOM_INTENSITY: return .4
	case e_value.CAM_BLOOM_RADIUS: return 1
	case e_value.CAM_BLOOM_RATIO: return 0
	case e_value.CAM_BLOOM_BLEND: return c_white
	case e_value.CAM_LENS_DIRT_BLOOM: return true
	case e_value.CAM_LENS_DIRT_GLOW: return true
	case e_value.CAM_LENS_DIRT_RADIUS: return .5
	case e_value.CAM_LENS_DIRT_INTENSITY: return .8
	case e_value.CAM_LENS_DIRT_POWER: return 1.5
	case e_value.CAM_COLOR_CORRECTION: return false
	case e_value.CAM_CONTRAST: return 0
	case e_value.CAM_BRIGHTNESS: return 0
	case e_value.CAM_SATURATION: return 1
	case e_value.CAM_VIBRANCE: return 0
	case e_value.CAM_TEMPERATURE: return 0
	case e_value.CAM_FOG_HEIGHT: return -30
	case e_value.CAM_FOG_HEIGHT_END: return 1000
	case e_value.CAM_COLOR_BURN: return c_white
	case e_value.CAM_GRAIN_STRENGTH: return .10
	case e_value.CAM_GRAIN_SATURATION: return .10
	case e_value.CAM_GRAIN_SIZE: return 1
	case e_value.CAM_VIGNETTE_RADIUS: return 1
	case e_value.CAM_VIGNETTE_SOFTNESS: return 0.5
	case e_value.CAM_VIGNETTE_STRENGTH: return 1
	case e_value.CAM_VIGNETTE_COLOR: return c_black
	case e_value.CAM_CA_BLUR_AMOUNT: return 0.05
	case e_value.CAM_CA_RED_OFFSET: return .12
	case e_value.CAM_CA_GREEN_OFFSET: return .08
	case e_value.CAM_CA_BLUE_OFFSET: return .04
	case e_value.CAM_DISTORT_AMOUNT: return .05
	case e_value.CAM_WIDTH: return 1280
	case e_value.CAM_HEIGHT: return 720
	case e_value.CAM_SIZE_USE_PROJECT: return true
	case e_value.CAM_SIZE_KEEP_ASPECT_RATIO: return true
	case e_value.BG_IMAGE_SHOW: return app.background_image_show
	case e_value.BG_IMAGE_ROTATION: return app.background_image_rotation
	case e_value.BG_SKY_MOON_PHASE: return app.background_sky_moon_phase
	case e_value.BG_SKY_TIME: return app.background_sky_time
	case e_value.BG_SKY_ROTATION: return app.background_sky_rotation
	case e_value.BG_SUNLIGHT_RANGE: return app.background_sunlight_range
	case e_value.BG_SUNLIGHT_FOLLOW: return app.background_sunlight_follow
	case e_value.BG_SUNLIGHT_STRENGTH: return app.background_sunlight_strength
	case e_value.BG_DESATURATE_NIGHT: return app.background_desaturate_night
	case e_value.BG_DESATURATE_NIGHT_AMOUNT: return app.background_desaturate_night_amount
	case e_value.BG_SKY_CLOUDS_SHOW: return app.background_sky_clouds_show
	case e_value.BG_SKY_CLOUDS_SPEED: return app.background_sky_clouds_speed
	case e_value.BG_SKY_CLOUDS_Z: return app.background_sky_clouds_z
	case e_value.BG_SKY_CLOUDS_OFFSET: return app.background_sky_clouds_offset
	case e_value.BG_GROUND_SHOW: return app.background_ground_show
	case e_value.BG_GROUND_SLOT: return app.background_ground_slot
	case e_value.BG_SKY_COLOR: return app.background_sky_color
	case e_value.BG_SKY_CLOUDS_COLOR: return app.background_sky_clouds_color
	case e_value.BG_SUNLIGHT_COLOR: return app.background_sunlight_color
	case e_value.BG_AMBIENT_COLOR: return app.background_ambient_color
	case e_value.BG_NIGHT_COLOR: return app.background_night_color
	case e_value.BG_GRASS_COLOR: return app.background_grass_color
	case e_value.BG_FOLIAGE_COLOR: return app.background_foliage_color
	case e_value.BG_WATER_COLOR: return app.background_water_color
	case e_value.BG_FOG_SHOW: return app.background_fog_show
	case e_value.BG_FOG_SKY: return app.background_fog_sky
	case e_value.BG_FOG_CUSTOM_COLOR: return app.background_fog_color_custom
	case e_value.BG_FOG_COLOR: return app.background_fog_color
	case e_value.BG_FOG_CUSTOM_OBJECT_COLOR: return app.background_fog_object_color_custom
	case e_value.BG_FOG_OBJECT_COLOR: return app.background_fog_object_color
	case e_value.BG_FOG_DISTANCE: return app.background_fog_distance
	case e_value.BG_FOG_SIZE: return app.background_fog_size
	case e_value.BG_FOG_HEIGHT: return app.background_fog_height
	case e_value.BG_FOG_START: return app.background_fog_start
	case e_value.BG_FOG_DENSITY: return app.background_fog_density
	case e_value.BG_FOG_END: return app.background_fog_end
	case e_value.BG_WIND: return app.background_wind
	case e_value.BG_WIND_SPEED: return app.background_wind_speed
	case e_value.BG_WIND_STRENGTH: return app.background_wind_strength
	case e_value.BG_TEXTURE_ANI_SPEED: return app.background_texture_animation_speed
	case e_value.ATTRACTOR:
	case e_value.TEXTURE_OBJ:
	case e_value.SOUND_OBJ:
	case e_value.TEXT_FONT: return null
	case e_value.SOUND_VOLUME: return 1
	case e_value.VISIBLE: return true
	case e_value.TEXT: 
	case e_value.ITEM_NAME: return ""
	case e_value.TEXT_HALIGN:
	case e_value.TEXT_VALIGN: return "center"
	case e_value.TRANSITION: return "linear"
	case e_value.BEZIERCONFIG: return 3
	case e_value.BEZIER: return 0
	case e_value.BEZIERY: return 0
	case e_value.BEZIER2X: return 1
	case e_value.BEZIER2Y: return 1
	case e_value.NOISETHRESHOLD: return app.v_fog_threshold
	case e_value.VFOGBOTTOM: return app.v_fog_bottom
	case e_value.VFOGTOP: return app.v_fog_top
	case e_value.VFOGWIDE: return app.v_fog_wide
	case e_value.VFOG_DENSITY: return app.v_fog_density
	case e_value.VFOGSIZE: return app.v_fog_size
	case e_value.VFOG_POS_X: return app.v_fog_pos_x
	case e_value.VFOG_POS_Y: return app.v_fog_pos_y
	case e_value.VFOG_POS_Z: return app.v_fog_pos_z
	case e_value.FOG_OFF_X: return app.fog_off_x
	case e_value.FOG_OFF_Y: return app.fog_off_y
	case e_value.FOG_OFF_Z: return app.fog_off_z
}

return 0
