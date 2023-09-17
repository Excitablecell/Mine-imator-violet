/// shader_high_bloom_threshold_set()
/// @arg depthbuffer

render_set_uniform("uThreshold", render_camera.value[e_value.CAM_BLOOM_THRESHOLD])
render_set_uniform("uBrightness",render_camera.value[e_value.CAM_BRIGHTNESS])