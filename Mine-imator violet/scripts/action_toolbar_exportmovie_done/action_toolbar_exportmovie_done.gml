/// action_toolbar_exportmovie_done()

var fn;

render_free()

if (exportmovie_format != "png")
{
	movie_done()
	buffer_delete(exportmovie_buffer)
}

surface_free(exportmovie_surface)
exportmovie_surface = null
window_state = ""

render_watermark = false
render_background = true
render_hidden = false

timeline_marker = exportmovie_marker_previous

if (exportmovie_format = "png")
	fn = filename_new_ext(exportmovie_filename, "") + "_1.png"
else
	fn = exportmovie_filename

alert_show(text_get("alertexportmovietitle"), "", icons.SAVE_SMALL, "alertexportmoviebutton", fn, 5000)
