/// shader_color_correction_set()

render_set_uniform("uContrast", render_camera.value[e_value.CAM_CONTRAST] + 1)
render_set_uniform("uBrightness", render_camera.value[e_value.CAM_BRIGHTNESS])
render_set_uniform("uSaturation", render_camera.value[e_value.CAM_SATURATION])
render_set_uniform("uVibrance", render_camera.value[e_value.CAM_VIBRANCE])
render_set_uniform("uTemperature", render_camera.value[e_value.CAM_TEMPERATURE])
render_set_uniform("uHeightFogStart", render_camera.value[e_value.CAM_FOG_HEIGHT])
render_set_uniform("uHeightFogEnd", render_camera.value[e_value.CAM_FOG_HEIGHT_END])
render_set_uniform_color("uColorBurn", render_camera.value[e_value.CAM_COLOR_BURN], 1)