function Skeleton() constructor {
	// Methods of the Skeleton
	static RecursiveCreate = function(XMLData, parent) {
		// Creating the current joint
		var name = XMLData.get_attribute("sid");
		var arr = Split(XMLData.get_child_by_name("matrix").value, " ", true);
		var matrix = new Matrix4x4(arr);
		var joint = new Geometry.Joint(name, matrix.Transpose().GetDualQuaternion(), parent);
		if (self.root==NULL) self.root = joint;
		array_push(self.joints, joint);
		
		// For every children we call this same function recursively
		for(var i=0; i<XMLData.get_child_count(); i++) {
			if (XMLData.get_child(i).name == "node") {
				RecursiveCreate(XMLData.get_child(i), joint);
			}
		}
	};
	
	static GetJoint = function(name) {
		for(var i=0, n=array_length(self.joints); i<n; i++)
			if (self.joints[i].name == name) return self.joints[i];
		return NULL;
	};

	static Update = function() {
		self.root.Update(self.animation);
	};
	
	static GetUniform = function() {
		var n = array_length(self.joints);
		var dq = array_create(n*8);
		for(var i=0, ; i<n; i++) {
			var joint = self.joints[i]
			dq[i*8 + 0] = joint.deltaWorldDQ.x;
			dq[i*8 + 1] = joint.deltaWorldDQ.y;
			dq[i*8 + 2] = joint.deltaWorldDQ.z;
			dq[i*8 + 3] = joint.deltaWorldDQ.w;
			dq[i*8 + 4] = joint.deltaWorldDQ.j;
			dq[i*8 + 5] = joint.deltaWorldDQ.k;
			dq[i*8 + 6] = joint.deltaWorldDQ.l;
			dq[i*8 + 7] = joint.deltaWorldDQ.i;
		}
		
		return dq;
	};
	
	static CleanUp = function() {
		for(var i=0, n=array_length(self.joints); i<n; i++) {
			ds_map_destroy(self.joints[i].animations);
		}	
	};
	
	static toString = function() {
		return self.root.toString();
	};
	
	static Draw = function() {
		for(var i=0, n=array_length(self.joints); i<n; i++) {
			self.joints[i].Draw();
		}	
	}
	
	// Initialization
	self.root = NULL;
	self.inverseDQ = NULL;
	self.jointsNames = NULL;
	self.joints = [];
	self.animation = "";
	self.animIndex = 0;
	self.name = "";
};
