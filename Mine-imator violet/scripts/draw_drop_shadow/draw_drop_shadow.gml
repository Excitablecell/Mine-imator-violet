/// draw_drop_shadow(x, y, width, height)
/// @arg x
/// @arg y
/// @arg width
/// @arg height

var xx, yy, wid, hei;
xx = argument0
yy = argument1
wid = argument2
hei = argument3

draw_gradient(xx + wid, yy, shadow_size, shadow_size, c_black, 0, 0, 0, shadow_alpha)
draw_gradient(xx + wid, yy + shadow_size, shadow_size, hei - shadow_size, c_black, shadow_alpha, 0, 0, shadow_alpha)
draw_gradient(xx + wid, yy + hei, shadow_size, shadow_size, c_black, shadow_alpha, 0, 0, 0)
draw_gradient(xx + shadow_size, yy + hei, wid - shadow_size, shadow_size, c_black, shadow_alpha, shadow_alpha, 0, 0)
draw_gradient(xx, yy + hei, shadow_size, shadow_size, c_black, 0, shadow_alpha, 0, 0)
