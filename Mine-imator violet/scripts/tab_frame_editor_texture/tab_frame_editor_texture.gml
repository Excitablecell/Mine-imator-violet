/// tab_frame_editor_texture()

var texobj, name, tex;
tex = null

if (tl_edit.temp = null)
	return 0
	
switch (tl_edit.type)
{
	case e_tl_type.CHARACTER:
	case e_tl_type.SPECIAL_BLOCK:
	case e_tl_type.MODEL:
	case e_tl_type.BODYPART:
	{
		name = "frameeditor" + tl_type_name_list[|tl_edit.type] + "tex"
		
		var modelfile = tl_edit.temp.model_file;
		if (tl_edit.type = e_temp_type.BODYPART)
			modelfile = tl_edit.model_part
		
		with (tl_edit.temp)
		{
			texobj = temp_get_model_texobj(tl_edit.value[e_value.TEXTURE_OBJ])
			tex = temp_get_model_tex_preview(texobj, modelfile)
		}
		
		break
	}
	
	case e_tl_type.BLOCK:
	case e_tl_type.SCENERY:
	{
		name = "frameeditorblocktex"
		with (tl_edit.temp)
			texobj = temp_get_block_texobj(tl_edit.value[e_value.TEXTURE_OBJ])
		tex = texobj.block_preview_texture
		break
	}
	
	default: // Shapes
	{
		name = "frameeditorshapetex"
		with (tl_edit.temp)
			texobj = temp_get_shape_texobj(tl_edit.value[e_value.TEXTURE_OBJ])
		
		if (texobj != null && texobj.type != e_tl_type.CAMERA) // Don't preview cameras
			tex = texobj.texture
		break
	}
}

// Text to display
var text;
if (texobj != null)
	text = texobj.display_name
else
	text = text_get("listnone")

if (tl_edit.value[e_value.TEXTURE_OBJ] = null)
	text = text_get("listdefault", text)

tab_control(40)
draw_button_menu(name, e_menu.LIST, dx, dy, dw, 40, tl_edit.value[e_value.TEXTURE_OBJ], text, action_tl_frame_texture_obj, tex)
tab_next()
