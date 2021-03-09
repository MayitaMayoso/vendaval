
// The port struct keeps all the properties and methods
// of everything related to displaying the game in the
// different platforms. Here we change the resolution,
// the parameters of the window, etc...
port = {
	// Properties
    width : 1280,
    height : 720,
    aspect : 1,
    
    // Variables
    center : false,
    
    // Update the canvas every step
    Update : function() {
    	// Calculating the aspect ratio
        aspect = width / height;
        
        // Centering the canvas
        if ( center ) {
            window_center();
            center = false;
        }
        
        // Resizing the desktop canvas
        if ( DESKTOP ) {
            if ( window_get_width() != width || window_get_height() != height ) {
                window_set_size(width, height);
                surface_resize(application_surface, width, height);
                center = true;
            }
        }
        
        // Resizing the browser canvas
        if ( BROWSER ) {
            if ( browser_width != width || browser_width != height ) {
                width = browser_width; height = browser_height;
                window_set_size(width, height);
                surface_resize(application_surface, width, height);
                center = true;
            }
        }
    }
};

// The view is the portion of the room displayed on the
// port. In this struct we can change the position, size,
/// rotation, scaling, etc...
view = {
	// Properties
    x : METER,
    y : METER,
    z : METER,
    width : 480,
    height : 270,
    aspect : 1,
    scale : 1,
    fov : 60,
	enablePerspective : true,
	xto : 0,
	yto : 0,
	zto : 0,
	
	// Variables
	fixedWidth : 1,
	fixedHeight : 1,
    
    // Update the view every step
    Update : function() {
        // Resize the view
        aspect = Camera.port.width / Camera.port.height;
        if ( aspect > 1 ) {
            fixedWidth = width;
            fixedHeight = width / aspect;
        } else {
            fixedHeight = height;
            fixedWidth = height * aspect;
        }
        
        var cam = view_camera[0];
        
        var lookMat, projMat;
        if (!enablePerspective) {
	        lookMat = matrix_build_lookat(x, y, z, x, y, z + 1, 0, -METER, 0);
	        projMat = matrix_build_projection_ortho(-fixedWidth * scale, -fixedHeight * scale, 0.001, 10000);
        } else {
        	lookMat = matrix_build_lookat(x, y, z, xto, yto, zto, 0, 1, 0);
			projMat = matrix_build_projection_perspective_fov(-fov, -aspect, 0.001, 10000);
        }
        camera_set_view_mat(cam, lookMat);
        camera_set_proj_mat(cam, projMat);
        camera_apply(cam);
    }
};

game_set_speed(60, gamespeed_fps);
gpu_set_texfilter(false);

// Move the camera
look_dir = 225;
look_pitch = 0;
maxSpd = 2.5;
acceleration = 0.1;
mouseSensitivity = 0.08;
gamepadSensitivity = 2.5;
sideSpd = 0 ;
frontalSpd = 0;
verticalSpd = 0;