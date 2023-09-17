/// temp_update_model_timeline_tree([historyobject])
/// @arg [historyobject]
/// @desc Update timelines of the changed model.

var hobj;
if (argument_count > 0)
	hobj = argument[0]
else
	hobj = null
	
with (obj_timeline)
{
	if (temp != other.id || part_list = null)
		continue
	
	// Save indices of children
	if (hobj != null)
	{
		for (var p = 0; p < ds_list_size(part_list); p++)
		{
			with (part_list[|p])
			{
				for (var t = 0; t < ds_list_size(tree_list); t++)
				{
					with (tree_list[|t])
					{
						if (part_of != null)
							break
					
						with (hobj)
						{
							part_child_save_id[part_child_amount] = save_id_get(other.id)
							part_child_parent_save_id[part_child_amount] = save_id_get(other.parent)
							part_child_parent_tree_index[part_child_amount] = t
							part_child_amount++
						}
					}
				}
			}
		}
	}
	
	// Remove empty timelines and set others to root
	for (var p = 0; p < ds_list_size(part_list); p++)
	{
		with (part_list[|p])
		{
			// Check if unused
			if (ds_list_size(keyframe_list) = 0)
			{
				var unused = true;
				
				// Check if not hidden and exists in the new model
				if (temp.model_file != null && ds_list_find_index(temp.model_hide_list, model_part_name) = -1)
				{
					for (var mp = 0; mp < ds_list_size(temp.model_file.file_part_list); mp++)
					{
						if (temp.model_file.file_part_list[|mp].name = model_part_name)
						{
							unused = false
							break
						}
					}
				}
				
				if (unused)
				{
					// Move children to root
					for (var t = 0; t < ds_list_size(tree_list); t++)
					{
						with (tree_list[|t])
						{
							if (part_of != null)
								break
							
							tl_set_parent(other.part_of)
							t--
						}
					}
					
					p--
					instance_destroy()
					continue
				}
			}
			
			model_part = null
			tl_set_parent(other.id)
			tl_update_value_types()
			tl_update_type_name()
			tl_update_display_name()
		}
	}
	
	// Construct new list of parts (re-add old timelines that had keyframes)
	if (temp.model_file != null)
	{
		ds_list_clear(part_list)
		for (var mp = 0; mp < ds_list_size(temp.model_file.file_part_list); mp++)
		{
			// Check if there is a previously existing timeline with the part name
			var part, tlexists;
			part = temp.model_file.file_part_list[|mp]
			tlexists = false
		
			// Hidden?
			if (ds_list_find_index(temp.model_hide_list, part.name) > -1)
				continue
		
			with (obj_timeline)
			{
				if (part_of = other.id && model_part_name = part.name)
				{
					ds_list_add(other.part_list, id)
					lock_bend = part.lock_bend
					part_mixing_shapes = part.part_mixing_shapes
					value_type_show[e_value_type.POSITION] = part.show_position
					tlexists = true
					break
				}	
			}
		
			// Otherwise create a timeline for it
			if (!tlexists)
				ds_list_add(part_list, tl_new_part(part))
		}
		
		tl_update_part_list(temp.model_file, id)
	}
	
	tl_update_type_name()
	tl_update_display_name()
	update_matrix = true
}