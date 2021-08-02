draw_set_halign(fa_middle);
if (Camera.mode=="Character") {
	var off = 400 * hp/100;
	draw_rectangle(10, 10, 10 + off, 30, false);
} else {
	if (Camera.mode=="Orbit") {
		draw_text_transformed(display_get_gui_width()/2, 50, "Animation: " + state, 2, 2, 0)
	};
}
