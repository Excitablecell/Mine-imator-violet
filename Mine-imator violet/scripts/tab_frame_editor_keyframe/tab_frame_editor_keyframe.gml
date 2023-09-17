/// tab_frame_editor_keyframe()

// Transition
var text = text_get("transition"+tl_edit.value[e_value.TRANSITION]);
tab_control(40)
draw_button_menu("frameeditortransition", e_menu.TRANSITION_LIST, dx, dy-15, dw, 70, tl_edit.value[e_value.TRANSITION], text, action_tl_frame_transition, transition_texture_small_map[?tl_edit.value[e_value.TRANSITION]])
tab_next()

// EXcai's bezier scale coefficient

if (tl_edit.value[e_value.TRANSITION] == "easebezier"){


	var capwid = text_caption_width("projectbezier")
	tab_control_meter()

	draw_meter("projectbezier", dx, dy+10, dw,tl_edit.value[e_value.BEZIER], 60, 0, 1, 0, 0.1, tab.keyframe.tbx_bezier, action_tl_frame_bezierconfig)
	tab_next()

	var capwid = text_caption_width("projectbeziery")
	tab_control_meter()
	draw_meter("projectbeziery", dx, dy+10, dw,tl_edit.value[e_value.BEZIERY], 60, -1, 1, 0, 0.1, tab.keyframe.tbx_bezier_y, action_tl_frame_bezieryconfig)
	tab_next()

	var capwid = text_caption_width("projectbezier2x")
	tab_control_meter()
	draw_meter("projectbezier2x", dx, dy+10, dw,tl_edit.value[e_value.BEZIER2X], 60, 0, 1, 0, 0.1, tab.keyframe.tbx_bezier_2x, action_tl_frame_bezier2xconfig)
	tab_next()

	var capwid = text_caption_width("projectbezier2y")
	tab_control_meter()
	draw_meter("projectbezier2y", dx, dy+10, dw,tl_edit.value[e_value.BEZIER2Y], 60, 0, 2, 0, 0.1, tab.keyframe.tbx_bezier_2y, action_tl_frame_bezier2yconfig)
	tab_next()
	if(tl_edit.value[e_value.BEZIER] != last_bezier || 
	tl_edit.value[e_value.BEZIERY] != last_bezier_y ||
	tl_edit.value[e_value.BEZIER2X] != last_bezier_2x ||
	tl_edit.value[e_value.BEZIER2Y] != last_bezier_2y
	){

		update_easebezier_transition_texture(transition_texture_map, 65, 65, 12);
		update_easebezier_transition_texture(transition_texture_small_map, 36, 36, 2);
		last_bezier = tl_edit.value[e_value.BEZIER];
		last_bezier_y = tl_edit.value[e_value.BEZIERY];
		last_bezier_2x = tl_edit.value[e_value.BEZIER2X];
		last_bezier_2y = tl_edit.value[e_value.BEZIER2Y];
		
	}
}


// Visible
tab_control_checkbox()
draw_checkbox("frameeditorvisible", dx, dy+10, tl_edit.value[e_value.VISIBLE], action_tl_frame_visible)
tab_next()
