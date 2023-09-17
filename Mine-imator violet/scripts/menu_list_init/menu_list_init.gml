/// menu_list_init()
/// @desc Runs when a list menu is created.

// Model state
if (menu_model_current != null)
{
	for (var i = 0; i < menu_model_state.value_amount; i++)
		menu_add_item(menu_model_state.value_name[i], minecraft_asset_get_name("modelstatevalue", menu_model_state.value_name[i]))
		
	return 0
}

// Block state
if (menu_block_current != null)
{
	for (var i = 0; i < menu_block_state.value_amount; i++)
		menu_add_item(menu_block_state.value_name[i], minecraft_asset_get_name("blockstatevalue", menu_block_state.value_name[i]))
		
	return 0
}
			
switch (menu_name)
{
	// Skin
	case "benchskin":
	case "benchspblocktex":
	case "benchbodypartskin":
	case "libraryskin":
	case "libraryspblocktex":
	case "librarybodypartskin":
	{
		var temp;
		if (string_contains(menu_name, "bench"))
			temp = bench_settings
		else
			temp = temp_edit
		
		// Import from file
		menu_add_item(e_option.BROWSE, text_get("listbrowse"), null, icons.BROWSE)
		
		// Download from user
		if (temp.model_file != null && temp.model_file.player_skin)
			menu_add_item(e_option.DOWNLOAD_SKIN, text_get("libraryskindownload"), null, icons.DOWNLOAD_SKIN)
		
		// Default
		var tex;
		with (mc_res)
			tex = res_get_model_texture(model_part_get_texture_name(temp.model_file, temp.model_texture_name_map))
		menu_add_item(mc_res, mc_res.display_name, tex)
		
		// Add existing resources
		for (var i = 0; i < ds_list_size(res_list.display_list); i++)
		{
			var res = res_list.display_list[|i];
			if (res = mc_res)
				continue
				
			with (res)
				tex = res_get_model_texture(model_part_get_texture_name(temp.model_file, temp.model_texture_name_map))
			
			if (tex != null)
				menu_add_item(res, res.display_name, tex)
		}
			
		break
	}
	
	// Model texture
	case "benchmodeltex":
	case "librarymodeltex":
	{
		var temp;
		if (string_contains(menu_name, "bench"))
			temp = bench_settings
		else
			temp = temp_edit
		
		// Import from file
		menu_add_item(e_option.BROWSE, text_get("listbrowse"), null, icons.BROWSE)
		
		// Download from user
		if (temp.model_file != null && temp.model_file.player_skin)
			menu_add_item(e_option.DOWNLOAD_SKIN, text_get("libraryskindownload"), null, icons.DOWNLOAD_SKIN)
		
		// Default
		var texobj = temp.model
		if (texobj != null)
		{
			if (texobj.model_format = e_model_format.BLOCK)
			{
				if (texobj.model_texture_map = null && texobj.block_sheet_texture = null) // Model has no texture, use Minecraft
					texobj = mc_res
			}
			else
			{
				if (texobj.model_texture_map = null && texobj.model_texture = null) // Model has no texture, use Minecraft
					texobj = mc_res
			}
		}
		
		if (texobj != null)
		{
			var tex;
			with (temp)
				tex = temp_get_model_tex_preview(texobj, model_file)
			menu_add_item(null, text_get("listdefault", texobj.display_name), tex)
		}
		else
			menu_add_item(null, text_get("listdefault", text_get("listnone")))
			
		// Add existing resources
		for (var i = 0; i < ds_list_size(res_list.display_list); i++)
		{
			var res = res_list.display_list[|i];
			if (res = temp.model || res = texobj)
				continue
			
			var tex;
			with (temp)
				tex = temp_get_model_tex_preview(res, model_file)
			
			if (tex != null)
				menu_add_item(res, res.display_name, tex)
		}
		
		break
	}
	
	// Terrain
	case "benchscenery":
	case "libraryscenery":
	{
		// None
		menu_add_item(null, text_get("listnone"))
		
		// Import from world
		menu_add_item(e_option.IMPORT_WORLD, text_get("librarysceneryimport"), null, icons.IMPORT_FROM_WORLD)
		
		// Import from file
		menu_add_item(e_option.BROWSE, text_get("listbrowse"), null, icons.BROWSE)
		
		// Add existing resources
		for (var i = 0; i < ds_list_size(res_list.display_list); i++)
		{
			var res = res_list.display_list[|i];
			if (res.type = e_res_type.SCHEMATIC)
				menu_add_item(res, res.display_name)
		}
		
		break
	}
	
	// Block texture
	case "benchblocktex":
	case "libraryblocktex":
	{
		// Import from file
		menu_add_item(e_option.BROWSE, text_get("listbrowse"), null, icons.BROWSE)
		
		// Default
		menu_add_item(mc_res, mc_res.display_name, mc_res.block_preview_texture)
		
		// Add existing resources
		for (var i = 0; i < ds_list_size(res_list.display_list); i++)
		{
			var res = res_list.display_list[|i];
			if (res != mc_res && res.block_sheet_texture != null)
				menu_add_item(res, res.display_name, res.block_preview_texture)
		}
		
		break
	}
	
	// Item texture
	case "benchitemtex":
	case "libraryitemtex":
	{
		// Import from file
		menu_add_item(e_option.BROWSE, text_get("listbrowse"), null, icons.BROWSE)
		
		// Default
		menu_add_item(mc_res, mc_res.display_name, mc_res.block_preview_texture)
		
		// Add existing resources
		for (var i = 0; i < ds_list_size(res_list.display_list); i++)
		{
			var res = res_list.display_list[|i];
			if (res = mc_res)
				continue
				
			if (res.type = e_res_type.TEXTURE)
				menu_add_item(res, res.display_name, res.texture)
			else if (res.item_sheet_texture != null)
				menu_add_item(res, res.display_name, res.block_preview_texture)
		}
		
		break
	}
	
	// Body part
	case "benchbodypart":
	{
		for (var p = 0; p < ds_list_size(bench_settings.model_file.file_part_list); p++)
		{
			var part = bench_settings.model_file.file_part_list[|p];
			menu_add_item(part.name, minecraft_asset_get_name("modelpart", part.name))
		}
		
		break
	}
		
	// Body part
	case "templateeditorbodypart":
	{
		for (var p = 0; p < ds_list_size(temp_edit.model_file.file_part_list); p++)
		{
			var part = temp_edit.model_file.file_part_list[|p];
			menu_add_item(part.name, minecraft_asset_get_name("modelpart", part.name))
		}
		
		break
	}
		
	// Text font
	case "benchtextfont":
	case "librarytextfont":
	{
		// Import from file
		menu_add_item(e_option.BROWSE, text_get("listbrowse"), null, icons.BROWSE)
		
		// Default
		menu_add_item(mc_res, mc_res.display_name)
		
		// Add existing resources
		for (var i = 0; i < ds_list_size(res_list.display_list); i++)
		{
			var res = res_list.display_list[|i];
			if (res != mc_res && font_exists(res.font))
				menu_add_item(res, res.display_name)
		}
		
		break
	}
	
	// Shape texture
	case "benchshapetex":
	case "libraryshapetex":
	{
		// None
		menu_add_item(null, text_get("listnone"))
		
		// Import from file
		menu_add_item(e_option.BROWSE, text_get("listbrowse"), null, icons.BROWSE)
		
		// Add existing resources
		for (var i = 0; i < ds_list_size(res_list.display_list); i++)
		{
			var res = res_list.display_list[|i];
			if (res.texture)
				menu_add_item(res, res.display_name, res.texture)
		}
		
		// Add existing cameras
		with (obj_timeline)
			if (type = e_tl_type.CAMERA)
				menu_add_item(id, display_name)
			
		break
	}
	
	// Model
	case "benchmodel":
	case "librarymodel":
	{
		// None
		menu_add_item(null, text_get("listnone"))
		
		// Browse
		menu_add_item(e_option.BROWSE, text_get("listbrowse"), null, icons.BROWSE)
		
		// Add resources
		for (var i = 0; i < ds_list_size(res_list.display_list); i++)
		{
			var res = res_list.display_list[|i];
			if (res.type = e_res_type.MODEL)
				menu_add_item(res, res.display_name)
		}
		
		break
	}
	
	// Particle editor spawn region type
	case "particleeditorspawnregiontype":
	{
		menu_add_item("sphere", text_get("particleeditorspawnregiontypesphere"), spr_icons, icons.SPHERE)
		menu_add_item("cube", text_get("particleeditorspawnregiontypecube"), spr_icons, icons.CUBE)
		menu_add_item("box", text_get("particleeditorspawnregiontypebox"), spr_icons, icons.BOX)
		
		break
	}
	
	// Particle editor type library source
	case "particleeditortypetemp":
	{
		menu_add_item(particle_template, text_get("particleeditortypetemplate"))
		menu_add_item(particle_sheet, text_get("particleeditortypespritesheet"))
		
		for (var i = 0; i < ds_list_size(lib_list.display_list); i++)
		{
			var temp = lib_list.display_list[|i];
			if (temp.type != e_temp_type.PARTICLE_SPAWNER)
				menu_add_item(temp, temp.display_name)
		}
		
		break
	}
	
	// Sprite sheet texture
	case "particleeditortypespritetex":
	{
		var img = ptype_edit.sprite_tex_image;
		
		// Add from file
		menu_add_item(e_option.BROWSE, text_get("listbrowse"), null, icons.BROWSE)
		
		// Default
		menu_add_item(mc_res, mc_res.display_name, mc_res.particles_texture[img])
		
		// Add existing resources
		for (var i = 0; i < ds_list_size(res_list.display_list); i++)
		{
			var res = res_list.display_list[|i];
			if (res != mc_res && res.particles_texture[0])
				menu_add_item(res, res.display_name, res.particles_texture[img])
		}
		
		break
	}
	
	// Sprite template pack
	case "particleeditortypespritetemplatepack":
	{
		var img = ptype_edit.sprite_tex_image;
		
		// Add from file
		menu_add_item(e_option.BROWSE, text_get("listbrowse"), null, icons.BROWSE)
		
		// Default
		menu_add_item(mc_res, mc_res.display_name, mc_res.block_preview_texture)
		
		// Add existing resources (Only packs allowed)
		for (var i = 0; i < ds_list_size(res_list.display_list); i++)
		{
			var res = res_list.display_list[|i];
			if (res != mc_res && res.type = e_res_type.PACK)
				menu_add_item(res, res.display_name, res.block_preview_texture)
		}
		
		break
	}
	
	// Sprite templates
	case "particleeditortypespritetemplate":
	{
		for (var i = 0; i < ds_list_size(particle_template_list); i++)
		{
			var temp = particle_template_list[|i];
			
			if (temp.animated)
				menu_add_item(temp.name, text_get("particleeditortypespritetemplate" + temp.name) + " " + text_get("particleeditortypespritetemplateframes", temp.frames))
			else
				menu_add_item(temp.name, text_get("particleeditortypespritetemplate" + temp.name))
			
		}
		break
	}
	
	// Background image
	case "backgroundimage":
	{
		// None
		menu_add_item(null, text_get("listnone"))
		
		// Import from file
		menu_add_item(e_option.BROWSE, text_get("listbrowse"), spr_icons, icons.BROWSE)
		
		// Add existing resources
		for (var i = 0; i < ds_list_size(res_list.display_list); i++)
		{
			var res = res_list.display_list[|i];
			if (res.texture)
				menu_add_item(res, res.display_name, res.texture)
		}
		
		break
	}
	
	// Background image type
	case "backgroundimagetype":
	{
		menu_add_item("image", text_get("backgroundimagetypeimage"))
		menu_add_item("sphere", text_get("backgroundimagetypesphere"))
		menu_add_item("box", text_get("backgroundimagetypebox"))
		
		break
	}
	
	// Background sky sun texture
	case "backgroundskysuntex":
	{
		// Import from file
		menu_add_item(e_option.BROWSE, text_get("listbrowse"), null, icons.BROWSE)
		
		// Default
		menu_add_item(mc_res, mc_res.display_name, mc_res.sun_texture)
		
		// Add existing resources
		for (var i = 0; i < ds_list_size(res_list.display_list); i++)
		{
			var res = res_list.display_list[|i];
			if (res = mc_res)
				continue
			if (res.sun_texture)
				menu_add_item(res, res.display_name, res.sun_texture)
			else if (res.texture)
				menu_add_item(res, res.display_name, res.texture)
		}
		
		break
	}
	
	// Background sky moon texture
	case "backgroundskymoontex":
	{
		// Import from file
		menu_add_item(e_option.BROWSE, text_get("listbrowse"), spr_icons, icons.BROWSE)
		
		// Default
		menu_add_item(mc_res, mc_res.display_name, mc_res.moon_texture[background_sky_moon_phase])
		
		// Add existing resources
		for (var i = 0; i < ds_list_size(res_list.display_list); i++)
		{
			var res = res_list.display_list[|i];
			if (res = mc_res)
				continue
			if (res.moon_texture[0])
				menu_add_item(res, res.display_name, res.moon_texture[background_sky_moon_phase])
			else if (res.texture)
				menu_add_item(res, res.display_name, res.texture)
		}
		
		break
	}
	
	// Background sky moon phase
	case "backgroundskymoonphase":
	{
		for (var p = 0; p < 8; p++)
			menu_add_item(p, text_get("backgroundskymoonphase" + string(p + 1)), background_sky_moon_tex.moon_texture[p])
		
		break
	}
	
	// Background sky clouds texture
	case "backgroundskycloudstex":
	{
		// Import from file
		menu_add_item(e_option.BROWSE, text_get("listbrowse"), spr_icons, icons.BROWSE)
		
		// Default
		menu_add_item(mc_res, mc_res.display_name, mc_res.clouds_texture)
		
		// Add existing resources
		for (var i = 0; i < ds_list_size(res_list.display_list); i++)
		{
			var res = res_list.display_list[|i];
			if (res = mc_res)
				continue
			if (res.clouds_texture)
				menu_add_item(res, res.display_name, res.clouds_texture)
			else if (res.texture)
				menu_add_item(res, res.display_name, res.texture)
		}
		
		break
	}
	
	// Background ground texture
	case "backgroundgroundtex":
	{
		// Import from file
		menu_add_item(e_option.BROWSE, text_get("listbrowse"), null, icons.BROWSE)
		
		// Default
		menu_add_item(mc_res, mc_res.display_name, mc_res.block_preview_texture)
		
		// Add existing resources
		for (var i = 0; i < ds_list_size(res_list.display_list); i++)
		{
			var res = res_list.display_list[|i];
			if (res != mc_res && res.block_sheet_texture != null)
				menu_add_item(res, res.display_name, res.block_preview_texture)
		}
		
		break
	}
	
	// Background biome
	case "backgroundbiome":
	{
		for (var b = 0; b < ds_list_size(biome_list); b++)
			menu_add_item(biome_list[|b], minecraft_asset_get_name("biome", biome_list[|b].name))

		break
	}
	
	// Background biome
	case "backgroundbiomevariant":
	{
		for (var v = 0; v < ds_list_size(background_biome.biome_variants); v++)
			menu_add_item(v, minecraft_asset_get_name("biome", background_biome.biome_variants[|v].name))
		
		break
	}
	
	// Resource pack preview image
	case "resourcespackimage":
	{
		menu_add_item("preview", text_get("resourcespackpreview"))
		menu_add_item("modeltextures", text_get("resourcespackmodeltextures"))
		menu_add_item("blocksheet", text_get("resourcespackblocksheet"))
		menu_add_item("colormap", text_get("resourcespackcolormap"))
		menu_add_item("itemsheet", text_get("resourcespackitemsheet"))
		menu_add_item("particlesheet", text_get("resourcespackparticlesheet"))
		menu_add_item("suntexture", text_get("resourcespacksuntexture"))
		menu_add_item("moontexture", text_get("resourcespackmoontexture"))
		menu_add_item("cloudtexture", text_get("resourcespackcloudtexture"))
		
		break
	}
	
	// Resource pack preview skin
	case "resourcespackimagemodeltexture":
	{
		for (var t = 0; t < ds_list_size(mc_assets.model_texture_list); t++)
			menu_add_item(mc_assets.model_texture_list[|t], mc_assets.model_texture_list[|t])
		
		break
	}
	
	// Timeline frame skin
	case "frameeditorchartex":
	case "frameeditorspblocktex":
	case "frameeditorbodyparttex":
	case "frameeditormodeltex":
	{
		var temp = tl_edit.temp;
		
		// Default
		var texobj = temp.model_tex;
		
		// Animatable special block in scenery
		if ((tl_edit.type = e_tl_type.SPECIAL_BLOCK || tl_edit.type = e_tl_type.BODYPART) && tl_edit.part_root != null)
		{
			if (tl_edit.part_root.type = e_tl_type.SCENERY)
			{
				with (tl_edit.part_root.temp)
				{
					if (block_tex.type = e_res_type.PACK)
						texobj = block_tex
					else
						texobj = model_tex
				}
			}
		}
		
		if (texobj = null)
		{
			texobj = temp.model
			if (texobj != null)
			{
				if (texobj.model_format = e_model_format.BLOCK)
				{
					if (texobj.model_texture_map = null && texobj.block_sheet_texture = null) // Model has no texture, use Minecraft
						texobj = mc_res
				}
				else
				{
					if (texobj.model_texture_map = null && texobj.model_texture = null) // Model has no texture, use Minecraft
						texobj = mc_res
				}
			}
		}
		
		if (texobj != null)
		{
			var modelfile = temp.model_file;
			if (tl_edit.type = e_temp_type.BODYPART)
				modelfile = tl_edit.model_part
				
			var tex;
			with (temp)
				tex = temp_get_model_tex_preview(texobj, modelfile)
			menu_add_item(null, text_get("listdefault", texobj.display_name), tex)
		}
		else
			menu_add_item(null, text_get("listdefault", text_get("listnone")), null)
		
		// Add existing resources
		for (var i = 0; i < ds_list_size(res_list.display_list); i++)
		{
			var res = res_list.display_list[|i];
			if ((temp.object_index != obj_timeline && res = temp.model) || res = texobj)
				continue
			
			var tex;
			with (temp)
				tex = temp_get_model_tex_preview(res, model_file)
			if (tex != null)
				menu_add_item(res, res.display_name, tex)
		}
		
		break
	}
	
	// Timeline frame block texture
	case "frameeditorblocktex":
	{	
		// Default
		var texobj = tl_edit.temp.block_tex;
		
		// Animatable block in scenery
		if (tl_edit.type = e_tl_type.BLOCK && tl_edit.part_of != null)
		{
			if (tl_edit.part_of.type = e_tl_type.SCENERY)
			{
				var temp = tl_edit.part_of.temp;
				
				with (temp)
				{
					if (block_tex.type = e_res_type.PACK || block_tex.type = e_res_type.BLOCK_SHEET)
						texobj = block_tex
				}
			}
		}
		
		menu_add_item(null, text_get("listdefault", texobj.display_name), texobj.block_preview_texture)
		
		// Add existing resources
		for (var i = 0; i < ds_list_size(res_list.display_list); i++)
		{
			var res = res_list.display_list[|i];
			if (res != texobj && res.block_sheet_texture != null)
				menu_add_item(res, res.display_name, res.block_preview_texture)
		}
		
		break
	}
	
	// Timeline frame item texture
	case "frameeditoritemitemtex":
	{
		// Default
		var texobj = tl_edit.temp.item_tex;
		menu_add_item(null, text_get("listdefault", texobj.display_name))
		
		// Add existing resources
		for (var i = 0; i < ds_list_size(res_list.display_list); i++)
		{
			var res = res_list.display_list[|i];
				
			if (res.type = e_res_type.TEXTURE)
				menu_add_item(res, res.display_name, res.texture)
			else if (res.item_sheet_texture != null)
				menu_add_item(res, res.display_name, res.block_preview_texture)
		}
		break
	}
	
	// Timeline frame shape texture
	case "frameeditorshapetex":
	{
		if (tl_edit.temp.shape_tex != null)
		{
			if (tl_edit.temp.shape_tex.object_index = obj_timeline)
				menu_add_item(null, text_get("listdefault", tl_edit.temp.shape_tex.display_name))
			else
				menu_add_item(null, text_get("listdefault", tl_edit.temp.shape_tex.display_name), tl_edit.temp.shape_tex.texture)
			menu_add_item(0, text_get("listnone"))
		}
		else
			menu_add_item(null, text_get("listdefault", text_get("listnone")))
		
		for (var i = 0; i < ds_list_size(res_list.display_list); i++)
		{
			var res = res_list.display_list[|i];
			if (res != tl_edit.temp.shape_tex && res.texture)
				menu_add_item(res, res.display_name, res.texture)
		}
		
		with (obj_timeline)
			if (id != tl_edit.temp.shape_tex && type = e_tl_type.CAMERA)
				menu_add_item(id, display_name)
			
		break
	}
	
	// Camera lens dirt texture
	case "frameeditorcameralensdirttexture":
	{
		menu_add_item(null, text_get("listdefault", text_get("listnone")))
		
		// Import from file
		menu_add_item(e_option.BROWSE, text_get("listbrowse"), spr_icons, icons.BROWSE, action_tl_frame_cam_lens_dirt_tex_browse)
		
		for (var i = 0; i < ds_list_size(res_list.display_list); i++)
		{
			var res = res_list.display_list[|i];
			if (res.texture)
				menu_add_item(res, res.display_name, res.texture)
		}
			
		break
	}
	
	// Sound
	case "frameeditorsound":
	{
		// Default
		menu_add_item(null, text_get("listnone"))
		
		// Add existing resources
		for (var i = 0; i < ds_list_size(res_list.display_list); i++)
		{
			var res = res_list.display_list[|i];
			if (res.type = e_res_type.SOUND)
				menu_add_item(res, res.display_name)
		}
		
		break
	}
	
	// Font
	case "frameeditortextfont":
	{
		// Default
		menu_add_item(null, text_get("listdefault", tl_edit.temp.text_font.display_name))
		
		// Add existing resources
		for (var i = 0; i < ds_list_size(res_list.display_list); i++)
		{
			var res = res_list.display_list[|i];
			if (res != tl_edit.temp.text_font && font_exists(res.font))
				menu_add_item(res, res.display_name)
		}
		break
	}
	
	// Minecraft version
	case "settingsminecraftversion":
	{
		var files = file_find(minecraft_directory, ".midata");
		for (var i = 0; i < array_length_1d(files); i++)
		{
			var name = filename_new_ext(filename_name(files[i]), "");
			menu_add_item(name, name)
		}
		break
	}
	
	// Shadow map detail
	case "settingsrendershadowssunbuffersize":
	case "settingsrendershadowsspotbuffersize":
	case "settingsrendershadowspointbuffersize":
	{
		menu_add_item(256, text_get("settingsrendershadowsbuffersize256") + " (256x256)", null, 0)
		menu_add_item(512, text_get("settingsrendershadowsbuffersize512") + " (512x512)", null, 0)
		menu_add_item(1024, text_get("settingsrendershadowsbuffersize1024") + " (1024x1024)", null, 0)
		menu_add_item(2048, text_get("settingsrendershadowsbuffersize2048") + " (2048x2048)", null, 0)
		menu_add_item(4096, text_get("settingsrendershadowsbuffersize4096") + " (4096x4096)", null, 0)
		menu_add_item(8192, text_get("settingsrendershadowsbuffersize8192") + " (8192x8192)", null, 0)
		
		break
	}
	
	// Watermark position
	case "settingsrenderwatermarkpositionx":
	{
		menu_add_item("left", text_get("settingsrenderwatermarkleft"), null, 0)
		menu_add_item("center", text_get("settingsrenderwatermarkcenter"), null, 0)
		menu_add_item("right", text_get("settingsrenderwatermarkright"), null, 0)
		
		break
	}
	
	case "settingsrenderwatermarkpositiony":
	{
		menu_add_item("top", text_get("settingsrenderwatermarktop"), null, 0)
		menu_add_item("center", text_get("settingsrenderwatermarkcenter"), null, 0)
		menu_add_item("bottom", text_get("settingsrenderwatermarkbottom"), null, 0)
		
		break
	}
	
	// Video size
	case "projectvideosize":
	case "exportmovievideosize":
	case "exportimageimagesize":
	case "frameeditorcameravideosize":
	{
		if (menu_name = "frameeditorcameravideosize")
			menu_add_item(null, text_get("frameeditorcameravideosizeuseproject"))
			
		for (var i = 0; i < ds_list_size(videotemplate_list); i++)
			with (videotemplate_list[|i])
				menu_add_item(id, text_get("projectvideosizetemplate" + id.name) + " (" + string(width) + "x" + string(height) + ")")
				
		menu_add_item(0, text_get("projectvideosizecustom"))
		
		break
	}
	
	// Export format
	case "exportmovieformat":
	{
		menu_add_item("mp4", text_get("exportmovieformatmp4"))
		menu_add_item("mov", text_get("exportmovieformatmov"))
		menu_add_item("wmv", text_get("exportmovieformatwmv"))
		menu_add_item("png", text_get("exportmovieformatpng"))
		
		break
	}
	
	// Video quality
	case "exportmovievideoquality":
	{
		for (var i = 0; i < ds_list_size(videoquality_list); i++)
			with (videoquality_list[|i])
				menu_add_item(id, text_get("exportmovievideoquality" + id.name))
			
		menu_add_item(0, text_get("exportmovievideoqualitycustom"))
		
		break
	}
	
	// Video framerate
	case "exportmovieframerate":
	{
		menu_add_item(24, "24")
		menu_add_item(30, "30")
		menu_add_item(60, "60")
		
		break
	}
	
	// Text alignment
	case "frameeditortexthalign":
	{
		menu_add_item("left", text_get("frameeditortextleft"), null, 0)
		menu_add_item("center", text_get("frameeditortextcenter"), null, 0)
		menu_add_item("right", text_get("frameeditortextright"), null, 0)
		
		break
	}
	
	case "frameeditortextvalign":
	{
		menu_add_item("top", text_get("frameeditortexttop"), null, 0)
		menu_add_item("center", text_get("frameeditortextcenter"), null, 0)
		menu_add_item("bottom", text_get("frameeditortextbottom"), null, 0)
		
		break
	}
	
	// Blend mode
	case "timelineeditorblendmode":
	{
		for (var i = 0; i < ds_list_size(blend_mode_list); i++)
			menu_add_item(blend_mode_list[|i], text_get("timelineeditorblendmode" + blend_mode_list[|i]))
		
		break
	}
}
