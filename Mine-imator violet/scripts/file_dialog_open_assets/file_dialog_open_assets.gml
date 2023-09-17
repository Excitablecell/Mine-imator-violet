/// file_dialog_open_assets()

var formats = "*miobject;*.miframes;*.zip;*.schematic;*.miproject;*.miparticles;*.mimodel;";
formats += "*.png;*.jpg;*.json;*.ttf;"
formats += "*.mp3;*.wav;*.ogg;*.flac;*.wma;*.m4a;"
formats += "*.object;*.keyframes;*.particles;*.mproj;*.mani;*.blocks";

return get_open_filenames_ext(text_get("filedialogopenasset") + "|" + formats, "", "", text_get("filedialogopenassetcaption"))
