// End game
if (keyboard_check(vk_escape)) game_end();
if (keyboard_check_pressed(vk_space)) {
	if (room_exists(room_next(room)))
		room_goto_next();
	else
		room_goto(rm_world);
}
// Update the structs of port and view
port.Update();
view.Update();

// Movement of the camera
mouseLookDirSpd = -(window_mouse_get_x() - window_get_width() / 2) * mouseSensitivity;
mouseLookPitchSpd = (window_mouse_get_y() - window_get_height() / 2) * mouseSensitivity;
window_mouse_set(window_get_width() / 2, window_get_height() / 2);
window_set_cursor(cr_none);

Input.SetConfiguration("Camera");
var sideDir = Input.CheckValue("Right") - Input.CheckValue("Left");
var frontalDir = Input.CheckValue("Up") - Input.CheckValue("Down");
var verticalDir = Input.CheckValue("Above") - Input.CheckValue("Below");

switch(mode) {
	case "Free":
		look_dir += mouseLookDirSpd;
		look_pitch += -mouseLookPitchSpd;
	
		look_dir = look_dir - floor( look_dir / 360 ) * 360;
		look_pitch = clamp(look_pitch, -89, 89);
	
		sideSpd = lerp(sideSpd, sideDir* maxSpd, acceleration);
		frontalSpd = lerp(frontalSpd, frontalDir* maxSpd, acceleration);
		verticalSpd = lerp(verticalSpd, verticalDir* maxSpd, acceleration);
	
		view.x += frontalSpd*dcos(look_dir) + sideSpd*dcos(look_dir-90);
		view.z += frontalSpd*dsin(look_dir) + sideSpd*dsin(look_dir-90);
		view.y += verticalSpd;
	
		view.xto = view.x + dcos(look_dir)*dcos(look_pitch);
		view.yto = view.y + dsin(look_pitch);
		view.zto = view.z + dsin(look_dir)*dcos(look_pitch);
		break;
	
	case "Orbit":
		look_dir += mouseLookDirSpd;
		look_pitch += mouseLookPitchSpd;
	
		look_dir = look_dir - floor( look_dir / 360 ) * 360;
		look_pitch = clamp(look_pitch, 0, 89);
	
		view.xto = 0;
		view.zto = 0;
		view.yto = 1;
	
		targd = max(targd -(mouse_wheel_up() - mouse_wheel_down())*.25, 1);
		dist = lerp(dist, targd, 0.1);
		view.x = view.xto + dcos(look_dir)*dcos(look_pitch)*dist;
		view.y = view.yto + dsin(look_pitch)*dist+.5;
		view.z = view.zto + dsin(look_dir)*dcos(look_pitch)*dist;	
		break;
	
	case "Character":
		look_dir += mouseLookDirSpd;
		look_pitch += mouseLookPitchSpd;
	
		look_dir = look_dir - floor( look_dir / 360 ) * 360;
		look_pitch = clamp(look_pitch, 0, 45);
	
		sideSpd = lerp(sideSpd, sideDir* maxSpd, acceleration);
		frontalSpd = lerp(frontalSpd, frontalDir* maxSpd, acceleration);
		verticalSpd = lerp(verticalSpd, verticalDir* maxSpd, acceleration);
		
		dist = 3;
		
		view.x = obj_character.x + dcos(look_dir)*dcos(look_pitch) * dist;
		view.y = obj_character.y + dsin(look_pitch) * dist + 2;
		view.z = obj_character.z + dsin(look_dir)*dcos(look_pitch) * dist;
		view.xto = obj_character.x;
		view.yto = obj_character.y + 1;
		view.zto = obj_character.z;
		break;
}