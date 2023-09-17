/// action_bench_block_name(block)
/// @arg block
/// @desc Sets the block name of the workbench settings.

with (bench_settings)
{
	if (block_name = argument0)
		return 0
		
	block_name = argument0
	block_state = array_copy_1d(mc_assets.block_name_map[?block_name].default_state)
	temp_update_block()
	
	preview.update = true
}