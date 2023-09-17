/// filename_new_ext(filename, newextension)
/// @arg filename
/// @arg newextension
/// @desc Changes the filename extension, accepting a new value with a leading dot, eg. ".png"

var fn, newext, p;
fn = argument0
newext = argument1

for (p = string_length(fn); p >= 0; p--)
{
	var c = string_char_at(fn, p);
	
	if (p = 0 || c = "\\" || c = "/")
		return fn + newext
		
	if (c = ".")
		break
}

return string_copy(fn, 1, p - 1) + newext
