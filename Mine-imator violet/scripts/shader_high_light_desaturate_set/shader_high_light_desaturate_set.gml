/// shader_high_light_desaturate_set(shadowsurf, amount)
/// @arg shadowsurf
/// @arg amount

var shadowsurf, amount;
shadowsurf = argument0
amount = 1 - (argument1 * app.background_night_alpha)

texture_set_stage(sampler_map[?"uShadowBuffer"], surface_get_texture(shadowsurf))
render_set_uniform("uAmount", amount)
