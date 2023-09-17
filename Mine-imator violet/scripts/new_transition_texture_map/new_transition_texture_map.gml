/// new_transition_texture_map(width, height, padding)
/// @arg width
/// @arg height
/// @arg padding

var w, h, wp, hp, padding, surf, map, isbezier;
w = argument0
h = argument1
padding = argument2
isbezier = argument3

map = ds_map_create()
if(isbezier == 1){
	map = init_surface_map
}
surf = surface_create(w, h)
surface_set_target(surf)
{
	draw_set_color(c_white)

	wp = w - padding * 2
	hp = h - padding * 2

	for (var t = 0; t < ds_list_size(transition_list); t++)
	{
		if(isbezier == 0){
			draw_clear_alpha(c_black, 0)
			for (var xx = 0; xx <= 1; xx += 1/wp)
			{
				draw_line(padding + floor((xx - 1/wp) * wp), 
					  padding + floor((1 - ease(transition_list[|t], xx - 1 / wp)) * hp), 
					  padding + floor(xx * wp), 
					  padding + floor((1 - ease(transition_list[|t], xx)) * hp))
			}
			map[?transition_list[|t]] = texture_surface(surf)
		}
	}
}
surface_reset_target()
surface_free(surf)

globalvar init_surface_map

if(isbezier == 0){
	init_surface_map = map
}

return map
