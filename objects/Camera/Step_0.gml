
// End game
if (keyboard_check_pressed(vk_escape)) game_end();

// Move the camera
var GamepadLookDirSpd = -(Input.CheckValue("ViewRight") - Input.CheckValue("ViewLeft")) * gamepadSensitivity;
var GamepadLookPitchSpd = (Input.CheckValue("ViewUp") - Input.CheckValue("ViewDown")) * gamepadSensitivity;
var MouseLookDirSpd = 0//-(window_mouse_get_x() - window_get_width() / 2) * mouseSensitivity;
var MouseLookPitchSpd = 0//-(window_mouse_get_y() - window_get_height() / 2) * mouseSensitivity;
display_mouse_set(window_get_width() / 2, window_get_height() / 2);
window_set_cursor(cr_none);

look_dir += (abs(GamepadLookDirSpd)>abs(MouseLookDirSpd))?GamepadLookDirSpd:MouseLookDirSpd;
look_pitch += (abs(GamepadLookPitchSpd)>abs(MouseLookPitchSpd))?GamepadLookPitchSpd:MouseLookPitchSpd;

look_dir = look_dir - floor( look_dir / 360 ) * 360;
look_pitch = clamp(look_pitch, -89, 89);

Input.SetConfiguration("Camera");
var sideDir = Input.CheckValue("Right") - Input.CheckValue("Left");
var frontalDir = Input.CheckValue("Up") - Input.CheckValue("Down");
var verticalDir = Input.CheckValue("Above") - Input.CheckValue("Below");

sideSpd = lerp(sideSpd, sideDir* maxSpd, acceleration);
frontalSpd = lerp(frontalSpd, frontalDir* maxSpd, acceleration);
verticalSpd = lerp(verticalSpd, verticalDir* maxSpd, acceleration);

view.x += frontalSpd*dcos(look_dir) + sideSpd*dcos(look_dir-90);
view.z += frontalSpd*dsin(look_dir) + sideSpd*dsin(look_dir-90);
view.y += verticalSpd;

view.xto = view.x + dcos(look_dir)*dcos(look_pitch);
view.yto = view.y + dsin(look_pitch);
view.zto = view.z + dsin(look_dir)*dcos(look_pitch);

// Update the structs of port and view
port.Update();
view.Update();