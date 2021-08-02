
image_alpha = 0;
// The port struct keeps all the properties and methods
// of everything related to displaying the game in the
// different platforms. Here we change the resolution,
// the parameters of the window, etc...
port = {
	// Properties
	/* 
    width : 1920,
    height : 1080,
    fullscreen : true,
    
    /*/ 
    width : 1280,
    height : 720,
    fullscreen : false,
    //*/
    
    // Variables
    aspect : 1,
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
            
            if (window_get_fullscreen() != fullscreen) {
            	window_set_fullscreen(fullscreen);
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
    x :  4,
    y : 1,
    z : 4,
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
	        lookMat = matrix_build_lookat(x, y, z, x, y, z + 1, 0, -1, 0);
	        projMat = matrix_build_projection_ortho(-fixedWidth * scale, -fixedHeight * scale, 0.001, 10000);
        } else {
        	lookMat = matrix_build_lookat(x, y, z, xto, yto, zto, 0, 1, 0);
			projMat = matrix_build_projection_perspective_fov(-fov, -aspect, 0.01, 10000);
        }
        camera_set_view_mat(cam, lookMat);
        camera_set_proj_mat(cam, projMat);
        camera_apply(cam);
    }
};

// Move the camera
look_dir = 180;
look_pitch = 0;
maxSpd = 0.25;
acceleration = 0.1;
mouseSensitivity = 0.08;
gamepadSensitivity = 2.5;
browserSensitivity = 0.16;
sideSpd = 0 ;
frontalSpd = 0;
verticalSpd = 0;

prevX = display_mouse_get_x();
prevY = display_mouse_get_y();

mode = "Free";
dist = 1;
targd = 3;