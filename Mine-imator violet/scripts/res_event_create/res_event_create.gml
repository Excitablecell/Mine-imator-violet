/// res_event_create()
/// @desc Create event of a resource.

save_id = ""
save_id = save_id_create()
loaded = false
creator = res_creator

replaced = false
ready = true

type = null
filename = ""
display_name = ""
count = 0
copied = false

model_file = null
model_format = null
model_texture = null
model_texture_map = null
model_block_map = null
model_texture_name_map = null
model_shape_texture_name_map = null
model_color_name_map = null
model_color_map = null
model_shape_hide_list = null
model_shape_vbuffer_map = null
model_shape_alpha_map = null
player_skin = false
pack_format = e_minecraft_pack.LATEST

block_sheet_texture = null
block_sheet_ani_texture = null
block_sheet_depth_list = null
block_sheet_ani_depth_list = null
block_preview_texture = null

colormap_grass_texture = null
colormap_foliage_texture = null
color_grass = null
color_foliage = null
color_water = null
sun_texture = null
moonphases_texture = null
moon_texture[0] = null
clouds_texture = null

item_sheet_texture = null
item_sheet_size = vec2(item_sheet_width, item_sheet_height)

particles_texture[0] = null
particles_texture[1] = null

particle_texture_map = null

block_vbuffer = null
scenery_tl_add = null
scenery_tl_list = null
scenery_size = vec3(0)

texture = null

font = null
font_preview = null
font_no_aa = null
font_minecraft = false

sound_buffer = null
sound_index = null

load_stage = ""
load_audio_sample = 0