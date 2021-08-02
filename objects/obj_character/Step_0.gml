
#region ANIMATION

	for(var i=0; i<array_length(skeleton.joints); i++) {
		skeleton.joints[i].keyframe = DQ_IDENTITY;
	}
	var spd = 1000;
	if (state == "Run") {
		skeleton.GetJoint("Marina.Waist").keyframe = new DualQuaternion(VECTOR_SIDE, Wave(-15, -25, spd, spd/2), VECTOR_ZERO);
		
		skeleton.GetJoint("Marina.Leg1.L").keyframe = new DualQuaternion(VECTOR_SIDE, Wave(-40, 40, spd), VECTOR_ZERO);
		skeleton.GetJoint("Marina.Leg1.R").keyframe = new DualQuaternion(VECTOR_SIDE, Wave(-40, 40, -spd), VECTOR_ZERO);
		
		skeleton.GetJoint("Marina.Leg2.L").keyframe = new DualQuaternion(VECTOR_SIDE, Wave(0, 40, spd), VECTOR_ZERO);
		skeleton.GetJoint("Marina.Leg2.R").keyframe = new DualQuaternion(VECTOR_SIDE, Wave(0, 40, -spd), VECTOR_ZERO);
		
		skeleton.GetJoint("Marina.Foot.L").keyframe = new DualQuaternion(VECTOR_SIDE, Wave(0, 60, spd), VECTOR_ZERO);
		skeleton.GetJoint("Marina.Foot.R").keyframe = new DualQuaternion(VECTOR_SIDE, Wave(0, 60, -spd), VECTOR_ZERO);
		
		
		skeleton.GetJoint("Marina.Arm1.L").keyframe = new DualQuaternion(VECTOR_SIDE, Wave(-80, 80, -spd), VECTOR_ZERO);
		skeleton.GetJoint("Marina.Arm1.R").keyframe = new DualQuaternion(VECTOR_SIDE, Wave(-80, 80, spd), VECTOR_ZERO);
		
		skeleton.GetJoint("Marina.Arm2.L").keyframe = new DualQuaternion(VECTOR_SIDE, Wave(-40, 0, -spd), VECTOR_ZERO);
		skeleton.GetJoint("Marina.Arm2.R").keyframe = new DualQuaternion(VECTOR_SIDE, Wave(-40, 0, spd), VECTOR_ZERO);
	} else if (state=="Hit") {
		skeleton.GetJoint("Marina.Arm1.R").keyframe = new DualQuaternion(VECTOR_SIDE, Wave(-90, 20, spd), VECTOR_ZERO);
		skeleton.GetJoint("Marina.Arm2.R").keyframe = new DualQuaternion(VECTOR_SIDE, Wave(-90, 0, spd), VECTOR_ZERO);
		skeleton.GetJoint("Harpoon").keyframe = new DualQuaternion(VECTOR_SIDE, Wave(100, 0, spd), VECTOR_ZERO);
	} else if (state=="Idle") {
		skeleton.GetJoint("Marina.Arm1.R").keyframe = new DualQuaternion(VECTOR_FRONT, Wave(-10, 10, spd), VECTOR_ZERO);
		skeleton.GetJoint("Marina.Arm1.L").keyframe = new DualQuaternion(VECTOR_FRONT, Wave(-10, 10, -spd), VECTOR_ZERO);
	}

	skeleton.Update();
	
#endregion

#region FSM
	if (Camera.mode=="Character") {
		Input.SetConfiguration("Camera");
		var sideDir = Input.CheckValue("Right") - Input.CheckValue("Left");
		var frontalDir = Input.CheckValue("Up") - Input.CheckValue("Down");
		switch(state) {
			case "Idle":
				if (abs(sideDir) || abs(frontalDir)) state = "Run";
				if (mouse_check_button_pressed(mb_left)) {
					state = "Hit";
					hitTimer = current_time + 1000;
					if (instance_exists(obj_bear)) {
						var bear = instance_nearest(x, z, obj_bear);
						if (point_distance(x, z, bear.x, bear.z)<2) {
							bear.hp -= 10;
							bear.offhit = 1.5;
						}
					}
					if (instance_exists(obj_snake)) {
						var bear = instance_nearest(x, z, obj_snake);
						if (point_distance(x, z, bear.x, bear.z)<2) {
							bear.hp -= 10;
							bear.offhit = 1.5;
						}
					}
				}
				break;
			
			case "Run":
				x += -Camera.frontalSpd*dcos(Camera.look_dir) + -Camera.sideSpd*dcos(Camera.look_dir-90);
				z += -Camera.frontalSpd*dsin(Camera.look_dir) + -Camera.sideSpd*dsin(Camera.look_dir-90);
				
				if !(abs(sideDir) || abs(frontalDir)) state = "Idle";
				if (mouse_check_button_pressed(mb_left)) {
					state = "Hit";
					hitTimer = current_time + 1000;
					if (instance_exists(obj_snake)) {
						var bear = instance_nearest(x, z, obj_snake);
						if (point_distance(x, z, bear.x, bear.z)<2) {
							bear.hp -= 10;
							bear.offhit = 1.5;
						}
					}
					if (instance_exists(obj_bear)) {
						var bear = instance_nearest(x, z, obj_bear);
						if (point_distance(x, z, bear.x, bear.z)<2) {
							bear.hp -= 10;
							bear.offhit = 1.5;
						}
					}
				}
				break;
				
			case "Hit":
				if (current_time>hitTimer) {
					if (abs(sideDir) || abs(frontalDir)) state = "Run";
					else state = "Idle"
				}
				break;
			default:
				state = "Idle";
				break;
		}
	} else {
		if (keyboard_check_pressed(ord("1"))) state = "None";
		if (keyboard_check_pressed(ord("2"))) state = "Idle";
		if (keyboard_check_pressed(ord("3"))) state = "Run";
		if (keyboard_check_pressed(ord("4"))) state = "Hit";
	}

#endregion