/// action_bench_model_part_name(name)
/// @arg name

var name = argument0;

with (bench_settings)
{
	if (model_part_name = name)
		return 0
		
	model_part_name = name
	temp_update_model_part()
	temp_update_model_shape()
	model_shape_update_color()
	
	with (preview)
		update = true
}