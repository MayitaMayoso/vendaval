camera_destroy(CAMERA);

if (browser_width != width || browser_height != height){
    width = browser_width;
    height = browser_height;
    ScaleCanvas(width, height);
}

CAMERA = camera_create_view(0, 0, width, height);