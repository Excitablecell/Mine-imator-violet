/// window_draw_load_assets()

if (!minecraft_assets_load())
{
	error("errorloadassets")
	game_end()
	return 0
}

// Background
draw_clear(setting_color_interface)

if (load_assets_stage = "done")
{
	load_assets_stage = "exit"
	return 0
}
else if (load_assets_stage = "exit")
{
	window_state = ""
	app_startup_interface()
	
	// Deactivate instances for better performance
	instance_deactivate_object(obj_deactivate)
	
	return 0
}

content_x = 25
content_y = 25
content_width = window_width - 50
content_height = window_height - 50

// To keep the user somewhat entertained
//draw_image(spr_load_assets, 0, content_x + content_width / 2, content_y+2)
if(current_hour < 18 && current_hour > 7){
	draw_clear(c_white)
	//draw_clear(setting_color_interface)
	draw_image(spr_load_assets, 0, content_x + content_width / 2, content_y+2)
}
else{
	//draw_clear(spr_load_assets)
	draw_clear(c_black)
	//draw_clear(setting_color_interface)
	draw_image(spr_load_assets, 1, content_x + content_width / 2, content_y+2)
}
// Loading
draw_loading_bar(content_x, content_y + content_height - 40, content_width, 40, load_assets_progress, text_get("loadassets" + load_assets_stage, app.setting_minecraft_assets_version))

//if (load_assets_block_name != "")
//{
//	var label = test(text_exists("block" + load_assets_block_name), text_get("block" + load_assets_block_name), load_assets_block_name);
//	
//	draw_label(text_get("loadassetsloadingblock") + ": " + label, content_x, content_y + content_height - 60)
//}

current_step++