/// file_dialog_save_particles(filename)
/// @arg filename

return file_dialog_save(text_get("filedialogsaveparticles") + " (*.miparticles)|*.miparticles", filename_get_valid(argument0), particles_directory, text_get("filedialogsaveparticlescaption"))
