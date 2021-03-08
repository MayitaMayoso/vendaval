width = room_width;
height = room_height;
#macro CAMERA view_camera[0]

function ScaleCanvas(width, height) {
	/// @function                  scale_canvas(width, height);
	/// @param {int}    width      The new width of the canvas of the game
	/// @param {int}    height     The new height of the canvas of the game

	window_set_size(width, height);		
	window_center();
	surface_resize(application_surface, width, height);
}