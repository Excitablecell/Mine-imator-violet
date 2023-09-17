/// model_part_fill_shape_vbuffer_map(part, vbuffermap, alphamap, bend)
/// @arg part
/// @arg vbuffermap
/// @arg alphamap
/// @arg bend
/// @desc Clears and fills the given map with vbuffers for the 3D shapes, bent by a rotation vector.

var part, vbufmap, alphamap, bend, isbent;
part = argument0
vbufmap = argument1
alphamap = argument2
bend = argument3
isbent = !vec3_equals(bend, vec3(0))

// Clamp
for (var i = X; i <= Z; i++)
	bend[X + i] = clamp(bend[X + i], part.bend_direction_min[i], part.bend_direction_max[i])

if (part.shape_list = null)
	return 0
	
for (var s = 0; s < ds_list_size(part.shape_list); s++)
{
	with (part.shape_list[|s])
	{
		vbufmap[? id] = vbuffer_default
		if (type = "block" && isbent && bend_shape)
			vbufmap[? id] = model_shape_generate_block(bend)
		else if (type = "plane")
		{
			if (is3d)
			{
				if (ds_map_valid(alphamap))
					vbufmap[? id] = model_shape_generate_plane_3d(bend, alphamap[?id])
			}
			else if (isbent && bend_shape)
				vbufmap[? id] = model_shape_generate_plane(bend)
		}
	}
}