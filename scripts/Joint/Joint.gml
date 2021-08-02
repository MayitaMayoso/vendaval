function Joint(name, dquat, parent, mesh) constructor {
		
	static Init = function() {
		if (self.parent!=NULL) {
			self.worldDQ = self.parent.worldDQ.Multiply(self.localDQ);
			self.length = self.worldDQ.GetTranslation().Length();
		} else {
			self.worldDQ = self.localDQ;
			self.length = self.worldDQ.GetTranslation().Substract(self.parent.worldDQ.GetTranslation()).Length();
		}
		self.inverseWorldDQ = self.worldDQ.Invert();
	}
	
	static Update = function(animName) {
		// Get the absolute local and world DQ
		self.frameLocalDQ = self.localDQ.Multiply(self.keyframe);
		
		if (self.parent==NULL)
			self.frameWorldDQ = self.frameLocalDQ
		else
			self.frameWorldDQ = self.parent.frameWorldDQ.Multiply(self.frameLocalDQ);
		
		// Get the relative transform of the joint
		self.deltaWorldDQ = self.frameWorldDQ.Multiply(self.inverseWorldDQ);
		
		// Tell every children to update
		for(var i=0; i<array_length(self.children); i++) {
			self.children[i].Update(animName);
		}
	}
	
	static AddChild = function(child) {
		array_push(self.children, child);
	}
	
	static toString = function() {
		var tab = "";
		repeat(self.parentsDepth) tab += "|\t";
		
		var str = tab + self.name + "\n";//;"\t---------\tMatrix: " + string(self.localMatrix) + "\n";
		
		// Tell every children to give the string
		for(var i=0; i<array_length(self.children); i++) {
			str += self.children[i].toString();
		}
		
		return str;
	};
	
	static Draw = function() {
		if (self.mesh != undefined) {
			matrix_set(matrix_world, matrix_multiply(self.frameWorldDQ.GetMatrix().arrayForm, matrix_stack_top()));
			self.mesh.Draw();
		}
	}
	
	self.localDQ = dquat;
	self.worldDQ = DQ_IDENTITY;
	self.inverseWorldDQ = DQ_IDENTITY;
	self.deltaWorldDQ = DQ_IDENTITY;
	self.frameLocalDQ = DQ_IDENTITY;
	self.frameWorldDQ = DQ_IDENTITY;
	self.keyframe = DQ_IDENTITY;
	self.length = 0;
	
	
	self.t = 0;
	self.name = name;
	self.parent = DefaultValue(parent, NULL);
	self.children = array_create(0);
	self.animations = ds_map_create();
	self.mesh = mesh;
	
	self.parentsDepth = 0;
	if (self.parent != NULL) {
		self.parent.AddChild(self);
		// Caltulate the joint parents depth
		var par = self.parent;
		while(par != NULL) {
			self.parentsDepth++;
			par = par.parent;
		}
	}
	
	self.Init();
};
