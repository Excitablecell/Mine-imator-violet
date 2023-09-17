/// app_event_create()
/// @desc Entry point of the application.

globalvar debug_indent, debug_timer;
debug_indent = 0
debug_info = false

globalvar last_bezier, last_bezier_y, last_bezier_2x, last_bezier_2y;

last_bezier = 0
last_bezier_y = 0
last_bezier_2x = 1
last_bezier_2y = 1
enums()
randomize()
gml_release_mode(true)

if (!app_startup())
{
	game_end()
	return 0
}