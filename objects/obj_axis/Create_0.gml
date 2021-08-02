
skeleton = new Geometry.Skeleton();

skeleton.root = new Geometry.Joint("Bone0", new DualQuaternion(new Vector3(.5,0,0), 0, new Vector3(0, 0, 0)));
var currJoint = skeleton.root;
array_push(skeleton.joints, currJoint);
var i = 0;
repeat(9) {
	currJoint = new Geometry.Joint("Bone" + string(++i), new DualQuaternion(new Vector3(.5,0,0), 0, new Vector3(0,.5,0)), currJoint);
	array_push(skeleton.joints, currJoint);
};
var currJoint = skeleton.root;
i = 0;
repeat(9) {
	currJoint = new Geometry.Joint("Bone" + string(++i), new DualQuaternion(new Vector3(.5,0,0), 0, new Vector3(0,-.5,0)), currJoint);
	array_push(skeleton.joints, currJoint);
};
