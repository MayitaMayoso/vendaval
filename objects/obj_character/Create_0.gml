
// MESH AND SKELETON
bodyParts = LoadOBJ("models/Marina.obj");
skeleton = new Skeleton();

#region SKELETON HARDCODED

	// BODY PARTS
	//	0	Marina.Hand.L
	//	1	Marina.Head
	//	2	Marina.Hip
	//	3	Marina.Hand.R
	//	4	Marina.Foot.R
	//	5	Marina.Foot.L
	//	6	Chara.Torso
	//	7	Chara.Waist
	//	8	Harpoon
	//	9	Marina.Arm1.L
	//	10	Marina.Arm2.L
	//	11	Marina.Arm1.R
	//	12	Marina.Arm2.R
	//	13	Marina.Leg1.L
	//	14	Marina.Leg2.L
	//	15	Marina.Leg1.R
	//	16	Marina.Leg2.R

	var i;
	var len = .08;
	// ---------------------- MAIN BODY
	// Hip
	i = 2;
	var hip = new Joint(	bodyParts[i].name,
						new DualQuaternion(VECTOR_SIDE, 0, new Vector3(0, .9, 0)),
						-1, bodyParts[i]);
						
	array_push(skeleton.joints, hip);
	skeleton.root = hip;
	
	// Waist
	i = 7;
	var waist = new Joint(	bodyParts[i].name,
						new DualQuaternion(VECTOR_SIDE, 0, new Vector3(0, len, 0)),
						hip, bodyParts[i]);
						
	array_push(skeleton.joints, waist);
	
	// Torso
	i = 6;
	var torso = new Joint(	bodyParts[i].name,
						new DualQuaternion(VECTOR_SIDE, 0, new Vector3(0, len*1.8, 0)),
						waist, bodyParts[i]);
						
	array_push(skeleton.joints, torso);
	
	// Neck
	var neck = new Joint(	bodyParts[i].name,
						new DualQuaternion(VECTOR_SIDE, 0, new Vector3(0, len*3, 0)),
						torso);
						
	array_push(skeleton.joints, neck);
	
	// Head
	i = 1;
	var head = new Joint(	bodyParts[i].name,
						new DualQuaternion(VECTOR_SIDE, 0, new Vector3(0, len, 0)),
						neck, bodyParts[i]);
						
	array_push(skeleton.joints, head);
	
	// ---------------------- LEFT ARM
	// Shoulder L
	var shoL = new Joint(	bodyParts[i].name,
						new DualQuaternion(VECTOR_FRONT, 0, new Vector3(len, len, 0)),
						torso);
						
	array_push(skeleton.joints, shoL);
	
	// Arm 1 L
	i = 9;
	var a1L = new Joint(	bodyParts[i].name,
						new DualQuaternion(VECTOR_FRONT, -135, new Vector3(len*1.8, 0, 0)),
						shoL, bodyParts[i]);
						
	array_push(skeleton.joints, a1L);
	
	// Arm 2 L
	i = 10;
	var a2L = new Joint(	bodyParts[i].name,
						new DualQuaternion(VECTOR_FRONT, 0, new Vector3(0, len*2, len*.5)),
						a1L, bodyParts[i]);
						
	array_push(skeleton.joints, a2L);
	
	// Hand L
	i = 3;
	var handL = new Joint(	bodyParts[i].name,
						new DualQuaternion(VECTOR_FRONT, 0, new Vector3(0, len*3.5, -len*.5)),
						a2L, bodyParts[i]);
						
	array_push(skeleton.joints, handL);
	
	// ---------------------- RIGHT ARM
	// Shoulder R
	var shoR = new Joint(	bodyParts[i].name,
						new DualQuaternion(VECTOR_FRONT, 0, new Vector3(-len, len, 0)),
						torso);
						
	array_push(skeleton.joints, shoR);
	
	// Arm 1 R
	i = 11;
	var a1R = new Joint(	bodyParts[i].name,
						new DualQuaternion(VECTOR_FRONT, 135, new Vector3(-len*1.8, 0, 0)),
						shoR, bodyParts[i]);
						
	array_push(skeleton.joints, a1R);
	
	// Arm 2 R
	i = 12;
	var a2R = new Joint(	bodyParts[i].name,
						new DualQuaternion(VECTOR_FRONT, 0, new Vector3(0, len*2, len*.5)),
						a1R, bodyParts[i]);
						
	array_push(skeleton.joints, a2R);
	
	// Hand R
	i = 0;
	var handR = new Joint(	bodyParts[i].name,
						new DualQuaternion(VECTOR_FRONT, 0, new Vector3(0, len*3.5, -len*.5)),
						a2R, bodyParts[i]);
						
	array_push(skeleton.joints, handR);
	
	// Harpoon
	i = 8;
	var harpoon = new Joint(	bodyParts[i].name,
						new DualQuaternion(VECTOR_SIDE, -90, new Vector3(0, len*0.5, 0)),
						handR, bodyParts[i]);
						
	array_push(skeleton.joints, harpoon);
	
	
	// ---------------------- LEFT LEG
	// Shoulder L
	var hipL = new Joint(	bodyParts[i].name,
						new DualQuaternion(VECTOR_FRONT, 0, new Vector3(len, -len, 0)),
						hip);
						
	array_push(skeleton.joints, hipL);
	
	// Leg 1 L
	i = 13;
	var l1L = new Joint(	bodyParts[i].name,
						new DualQuaternion(VECTOR_FRONT, -170, new Vector3(0, len*1, 0)),
						hipL, bodyParts[i]);
						
	array_push(skeleton.joints, l1L);
	
	// Leg 2 L
	i = 14;
	var l2L = new Joint(	bodyParts[i].name,
						new DualQuaternion(VECTOR_FRONT, -0, new Vector3(0, len*4.5, 0)),
						l1L, bodyParts[i]);
						
	array_push(skeleton.joints, l2L);
	
	// Foot L
	i = 5;
	var footL = new Joint(	bodyParts[i].name,
						new DualQuaternion(VECTOR_FRONT, -0, new Vector3(0, len*6, len*.5)),
						l2L, bodyParts[i]);
						
	array_push(skeleton.joints, footL);
	
	// ---------------------- RIGHT LEG
	// Shoulder R
	var hipR = new Joint(	bodyParts[i].name,
						new DualQuaternion(VECTOR_FRONT, 0, new Vector3(-len, -len, 0)),
						hip);
						
	array_push(skeleton.joints, hipR);
	
	// Leg 1 R
	i = 15;
	var l1R = new Joint(	bodyParts[i].name,
						new DualQuaternion(VECTOR_FRONT, 170, new Vector3(0, len*1, 0)),
						hipR, bodyParts[i]);
						
	array_push(skeleton.joints, l1R);
	
	// Leg 2 R
	i = 16;
	var l2R = new Joint(	bodyParts[i].name,
						new DualQuaternion(VECTOR_FRONT, -0, new Vector3(0, len*4.5, 0)),
						l1R, bodyParts[i]);
						
	array_push(skeleton.joints, l2R);
	
	// Foot R
	i = 4;
	var footR = new Joint(	bodyParts[i].name,
						new DualQuaternion(VECTOR_FRONT, -0, new Vector3(0, len*6, len*.5)),
						l2R, bodyParts[i]);
						
	array_push(skeleton.joints, footR);
	
#endregion

// GAMEPLAY
z = 0;
hp = 100;
offhit = 1;

state = "None";
hitTimer = 0;