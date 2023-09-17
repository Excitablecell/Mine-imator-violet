/// tab_frame_editor_particles()

var text, capwid;

// Spawn
tab_control_checkbox()
draw_checkbox("frameeditorspawn", dx, dy, tl_edit.value[e_value.SPAWN], action_tl_frame_spawn)
tab_next()

// Freeze
tab_control_checkbox()
draw_checkbox("frameeditorfreeze", dx, dy, tl_edit.value[e_value.FREEZE], action_tl_frame_freeze)
tab_next()

// Clear
tab_control_checkbox()
draw_checkbox("frameeditorclear", dx, dy, tl_edit.value[e_value.CLEAR], action_tl_frame_clear)
tab_next()

// Custom seed
tab_control_checkbox()
draw_checkbox("frameeditorcustomseed", dx, dy, tl_edit.value[e_value.CUSTOM_SEED], action_tl_frame_custom_seed)
tab_next()

if (tl_edit.value[e_value.CUSTOM_SEED])
{
	// Seed
	tab_control_dragger()
	draw_dragger("frameeditorseed", dx, dy, dw, tl_edit.value[e_value.SEED], 0.1, 0, 32000, 0, 1, tab.particles.tbx_seed, action_tl_frame_seed)
	tab_next()
}

// Attractor
capwid = text_caption_width("frameeditorattractor", "frameeditorforce")
if (tl_edit.value[e_value.ATTRACTOR] != null)
	text = tl_edit.value[e_value.ATTRACTOR].display_name
else
	text = text_get("listnone")
	
tab_control(32)
draw_button_menu("frameeditorattractor", e_menu.TIMELINE, dx, dy, dw, 32, tl_edit.value[e_value.ATTRACTOR], text, action_tl_frame_attractor, null, null, capwid)
tab_next()

// Force
if (tl_edit.value[e_value.ATTRACTOR])
{
	tab_control_dragger()
	draw_dragger("frameeditorforce", dx, dy, dw, tl_edit.value[e_value.FORCE], 1 / 50, -no_limit, no_limit, 1, 0, tab.particles.tbx_force, action_tl_frame_force, capwid)
	tab_next()
}

