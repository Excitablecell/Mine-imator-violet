/// block_texture_get_blend(name, resource)
/// @arg name
/// @arg resource

var texname, res, col;
texname = argument0
res = argument1
col = mc_assets.block_texture_color_map[?texname]

if (!is_undefined(col))
{
	if (!res.ready)
		res = mc_res
	
	if (is_real(col))
		return col
	else if (col = "grass")
		return res.color_grass
	else if (col = "leaves")
		return res.color_foliage
	else if (col = "water")
		return res.color_water
}
	
return c_white