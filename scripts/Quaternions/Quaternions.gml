function Quaternion(axis, angle) constructor {
	/// @function Quaternion(axis, angle) / Vector4(quaternion)
	/// @description Constructor for the quaternion data structure.
	/// @parameter {real} [angle]
	/// @parameter {real} [axis] / {Vector3/Quaternion} quaternion (Use the last one for construction by copy)
		
	#region Getters
	
		static CalculateQuaternion = function() {
			// AngleAxisToQuaternion()
			//
			// Calculates the x, y, z and w component of the quaternion structure
			// out of the axis and the angle of this rotation.
			// This function should always be called after changing either
			// angle or axis of rotation.
				
			self.axis.Normalize();
			self.angle %= 360;
				
			self.x = self.axis.x * dsin(self.angle/2);
			self.y = self.axis.y * dsin(self.angle/2);
			self.z = self.axis.z * dsin(self.angle/2);
			
			self.w = dcos(self.angle/2);
				
			return self;
		};
			
		static GetAxisAngle = function() {
			// QuaternionToAngleAxis()
			//
			// Calculates the angle and rotation component of the quaternion structure
			// out of the x, y, z and w components.
			// This function should always be called after changing either
			// x, y, z or w.
		
			var angle = 2*radtodeg(arccos(clamp(self.w, 0, 1)));
			var axisX = self.x / dsin(angle/2);
			var axisY = self.y / dsin(angle/2);
			var axisZ = self.z / dsin(angle/2);
				
			return new Vector4(axisX, axisY, axisZ, angle);
		};
		
		static GetVector = function() {
			return new Vector3(self.x, self.y, self.z);	
		};
		
		static GetEulerAngles = function() {
			var heading, attitude, bank;
			var test = self.x*self.y + self.z*self.w;
			if (test > 0.499) { // singularity at north pole
				heading = 2 * arctan2(self.x,self.w);
				attitude = pi/2;
				bank = 0;
				return new Vector3(radtodeg(heading), radtodeg(attitude), radtodeg(bank));
			}
			if (test < -0.499) { // singularity at south pole
				heading = -2 * arctan2(self.x,self.w);
				attitude = -pi/2;
				bank = 0;
				return new Vector3(radtodeg(heading), radtodeg(attitude), radtodeg(bank));
			}
		    var sqx = self.x*self.x;
		    var sqy = self.y*self.y;
		    var sqz = self.z*self.z;
		    heading = arctan2(2*self.y*self.w-2*self.x*self.z , 1 - 2*sqy - 2*sqz);
			attitude = arcsin(2*test);
			bank = arctan2(2*self.x*self.w-2*self.y*self.z , 1 - 2*sqx - 2*sqz);
			return new Vector3(radtodeg(heading), radtodeg(attitude), radtodeg(bank));
		};
		
		static Right = function(quat) {
			return new Vector3(2 * (quat.x * quat.y - quat.z * quat.w), 
					sqr(quat.w) - sqr(quat.x) + sqr(quat.y) - sqr(quat.z),
					2 * (quat.y * quat.z + quat.x * quat.w));
		}
		
		static Front = function(quat) {
			return new Vector3(sqr(quat.w) + sqr(quat.x) - sqr(quat.y) - sqr(quat.z), 
					2 * (quat.x * quat.y + quat.w * quat.z),
					2 * (quat.x * quat.z - quat.w * quat.y));
		};
		
		static Up = function(quat) {
			return new Vector3(2 * (quat.z * quat.x + quat.w * quat.y), 
					2 * (quat.z * quat.y - quat.w * quat.x),
					sqr(quat.w) - sqr(quat.x) - sqr(quat.y) + sqr(quat.z));
		};
			
		static toString = function() {
			// toString()
			//
			// Prints on the console a well formated version of the Quaternion structure.
				
			var str = "Quaternion(x, y, z, w)\t{ "
			+ string(self.x) + ", "
			+ string(self.y) + ", "
			+ string(self.z) + ", "
			+ string(self.w) + "}\n";
			
			str += "Quaternion(axis, angle)\t{ {"
			+ string(self.axis.x) + ", "
			+ string(self.axis.y) + ", "
			+ string(self.axis.z) + "}, "
			+ string(self.w) + "}";
			
			return str;
		}
		
	#endregion
	
	#region Setters
	
		static Set = function(axis, angle) {
			self.axis = axis;
			self.angle = angle;
			self.CalculateQuaternion();
		};
		
		static SetRaw = function(x, y, z, w) {
			self.x = x;
			self.y = y;
			self.z = z;
			self.w = w;
			var AA = self.GetAxisAngle();
			self.axis = new Vector3(AA);
			self.angle = AA.w;
		};
		
		static Copy = function(quat) {
			self.axis = quat.axis;
			self.angle = quat.angle;
			self.CalculateQuaternion();
		};
	
	#endregion
		
	#region Operators
	
		static Length = function() {
			// Length()
			// 
			// Returns the length of the vector. Calculates using the Pythagoras
			// theorem. Pretty basic.
				
			if ( self.x == 0 && self.y == 0 && self.z == 0 ) return 0;
				
			return sqrt( self.x*self.x + self.y*self.y + self.x*self.x );
		};
		
		static Normalize = function() {
			// Normalize()
			//
			// Normalizes this vector. This means we get the same quaternion. But with
			// its Length clamped to 1. In other words we get the unit vector (length 1)
			// for the direction we were already pointing at.
				
			var normalized = new Quaternion(self);
				
			var magn = self.Length();
				
			if ( magn == 0 ) return normalized;
				
			normalized.x /= magn;
			normalized.y /= magn;
			normalized.z /= magn;
				
			var rot = normalized.GetAxisAngle();
			return new Quaternion(rot.w, new Vector3(rot));
		};
		
		static Invert = function() {
			// Invert()
			//
			// Operates the Invert of this quaternion.
			// The inverse of a quaternion is the rotation that would undo itself.
				
			return new Quaternion(-self.angle, self.axis);
		};
		
		static Conjugate = function() {
			return new Quaternion(-self.x, -self.y, -self.z, self.w);
		};
			
		static Multiply = function(quat) {
			// Multiply()
			// 	{Quaternion} quaternion
			//
			// This method chains two quaternions one after another.
			// This operation is not conmutative.
			var newQuat = new Quaternion();
			var newVec = newQuat.GetVector();
			var myVec = self.GetVector();

			newQuat.w = self.w * quat.w - myVec.Dot(newVec);
			myVec = myVec.Multiply(quat.w).Add(newVec.Multiply(self.w)).Add(myVec.Cross(newVec));
			
			newQuat.x = myVec.x;
			newQuat.y = myVec.y;
			newQuat.z = myVec.z;
			
			var rot = newQuat.GetAxisAngle();
			return new Quaternion(rot.w, new Vector3(rot));
		};
			
		static Raise = function(exponent) {
			// Raise()
			// 	{real} exponent
			//
			// This method multiplies the angle of this quaternions rotation.
			// In quaternion termes this would be the equivalent of raising to an exponent.
				
			return new Quaternion(self.angle * exponent, self.axis);
		};
			
		static Slerp = function(to, amount) {
			// Lerp()
			// 	{Vector4} vector
			// 	{real} amount
			//
			// Spherically interpolates two quaternions.
				
			return new Quaternion( to.Multiply(self.Invert()).Raise(amount).Multiply(self) );
		};
			
		static RotateVector = function(vec) {
			if (is_nan(self.axis.x) || is_nan(self.axis.y) || is_nan(self.axis.z))
				return VECTOR_UP;
			var p = new Quaternion(vec.x, vec.y, vec.z, 0);
			var newV = self.Multiply(p.Multiply(self.Invert()))
			
			return new Vector3(newV.x, newV.y, newV.z);
		}	
		
	#endregion
		
	// Initialization of the Quaternion
	if (argument_count==2) self.Set(axis, angle);
	else if (argument_count==4) self.SetRaw(argument[0], argument[1], argument[2], argument[3]);
	else if ( argument_count==4 && instanceof(argument[0]) == "Quaternion" ) self.Copy(argument[0]);
	else self.Set(new Vector3(0, 1, 0), 0);
};

function DualQuaternion(axis, angle,translation) constructor {
	
	#region Getters
	
		static GetAxisAngle = function() {			
			var angle = 2*radtodeg(arccos(clamp(self.w, 0, 1)));
			
			if (self.x == 0 && self.y == 0 && self.z == 0) return new Vector4(0, 0, 0, angle);
			var axisX = self.x / dsin(angle/2);
			var axisY = self.y / dsin(angle/2);
			var axisZ = self.z / dsin(angle/2);
				
			return new Vector4(axisX, axisY, axisZ, angle);
		};
		static GetTranslation = function() {
			var q0 = self.x, q1 = self.y, q2 = self.z, q3 = self.w, q4 = self.j, q5 = self.k, q6 = self.l, q7 = self.i;
			return new Vector3(2 * (-q7 * q0 + q4 * q3 + q6 * q1 - q5 * q2), 
					2 * (-q7 * q1 + q5 * q3 + q4 * q2 - q6 * q0), 
					2 * (-q7 * q2 + q6 * q3 + q5 * q0 - q4 * q1));
		};
		static GetX = function() {
			return 2 * (-quat.i * quat.x + quat.j * quat.w + quat.l * quat.y - quat.k * quat.z);
		};
		static GetY = function() {
			return 2 * (-quat.i * quat.y + quat.k * quat.w + quat.j * quat.z - quat.l * quat.x);
		};
		static GetZ = function() {
			return 2 * (-quat.i * quat.z + quat.l * quat.w + quat.k * quat.x - quat.j * quat.y);
		};
		static GetMatrix = function() {
			var newMat = new Matrix4x4();
			var q0 = self.x, q1 = self.y, q2 = self.z, q3 = self.w, q4 = self.j, q5 = self.k, q6 = self.l, q7 = self.i;
			newMat.arrayForm[0] = q3 * q3 + q0 * q0 - q1 * q1 - q2 * q2;
			newMat.arrayForm[1] = 2 * (q0 * q1 + q2 * q3);
			newMat.arrayForm[2] = 2 * (q0 * q2 - q1 * q3);
			newMat.arrayForm[3] = 0;
			newMat.arrayForm[4] = 2 * (q0 * q1 - q2 * q3);
			newMat.arrayForm[5] = q3 * q3 - q0 * q0 + q1 * q1 - q2 * q2;
			newMat.arrayForm[6] = 2 * (q1 * q2 + q0 * q3);
			newMat.arrayForm[7] = 0;
			newMat.arrayForm[8] = 2 * (q0 * q2 + q1 * q3);
			newMat.arrayForm[9] = 2 * (q1 * q2 - q0 * q3);
			newMat.arrayForm[10] = q3 * q3 - q0 * q0 - q1 * q1 + q2 * q2;
			newMat.arrayForm[11] = 0;
			newMat.arrayForm[12] = 2 * (-q7 * q0 + q4 * q3 + q6 * q1 - q5 * q2);
			newMat.arrayForm[13] = 2 * (-q7 * q1 + q5 * q3 + q4 * q2 - q6 * q0); 
			newMat.arrayForm[14] = 2 * (-q7 * q2 + q6 * q3 + q5 * q0 - q4 * q1);
			newMat.arrayForm[15] = 1;
			return newMat;
		};
		static GetQuaternion = function() {
			return new Quaternion(self.angle, self.axis);
		};
		
		static toString = function() {
			// toString()
			//
			// Prints on the console a well formated version of the Quaternion structure.
				
			var str = "DualQuaternion(x, y, z, w, j, k, l, i)\t{ "
			+ string(self.x) + ", "
			+ string(self.y) + ", "
			+ string(self.z) + ", "
			+ string(self.w) + ", "
			+ string(self.j) + ", "
			+ string(self.k) + ", "
			+ string(self.l) + ", "
			+ string(self.i) + "}\n";
			
			return str;
		}
	
	#endregion
	
	#region Setters
	
		static CalculateDualQuaternion = function() {
			var radians = degtorad(self.angle);
			var ax = self.axis.x;
			var ay = self.axis.y;
			var az = self.axis.z;
			var tx = self.translation.x;
			var ty = self.translation.y;
			var tz = self.translation.z;
			
			var c, s;
			radians *= .5;
			var c = cos(radians);
			var s = sin(radians);
			ax *= s;
			ay *= s;
			az *= s;
		
			self.x = ax;
			self.y = ay;
			self.z = az;
			self.w = c;
			self.j = .5 * (tx * c + ty * az - tz * ax);
			self.k = .5 * (ty * c + tz * ax - tx * az);
			self.l = .5 * (tz * c + tx * ay - ty * ax);
			self.i = .5 * (- tx * ax - ty * ay - tz * az);
		};
		static Set = function(axis, angle, translation) {
			self.axis = axis;
			self.angle = angle;
			self.translation = translation;
			self.CalculateDualQuaternion();
		};
		static SetAxisAngle = function(axis, angle) {
			self.axis = axis;
			self.angle = w;
			self.CalculateDualQuaternion();
		};
		static SetTranslation = function(x, y, z) {
			self.translation = new Vector3(x, y, z);
			self.CalculateDualQuaternion();
		};
		static SetRaw = function(x, y, z, w, j, k, l, i) {;
			self.x = x;
			self.y = y;
			self.z = z;
			self.w = w;
			self.j = j;
			self.k = k;
			self.l = l;
			self.i = i;
			var AA = self.GetAxisAngle();
			self.axis = new Vector3(AA);
			self.angle = AA.w;
			self.translation = self.GetTranslation();
		}
		static Copy = function(dquat) {
			self.x = dquat.x;
			self.y = dquat.y;
			self.z = dquat.z;
			self.w = dquat.w;
			self.j = dquat.j;
			self.k = dquat.k;
			self.l = dquat.l;
			self.i = dquat.i;
			var AA = self.GetAxisAngle();
			self.axis = new Vector3(AA);
			self.angle = AA.w;
			self.translation = self.GetTranslation();
		};
	
	#endregion
	
	#region Operators
	
		static Invert = function() {
			return new DualQuaternion(-self.x, -self.y, -self.z, self.w, -self.j, -self.k, -self.l, self.i);
		};
		
		static Lerp = function(dquat, amount) {
			var v2 = amount;
			var v1 = 1 - v2;
			var newX = self.x * v1 + dquat.x * v2;
			var newY = self.y * v1 + dquat.y * v2;
			var newZ = self.z * v1 + dquat.z * v2;
			var newW = self.w * v1 + dquat.w * v2;
			var newJ = self.j * v1 + dquat.j * v2;
			var newK = self.k * v1 + dquat.k * v2;
			var newL = self.l * v1 + dquat.l * v2;
			var newI = self.i * v1 + dquat.i * v2;
			return new DualQuaternion(newX, newY, newZ, newW, newJ, newK, newL, newI);
		};
		static Multiply = function(dquat) {
			//Multiplies two dual quaternions and outputs the result to target
			//R * S = (A * C, A * D + B * C)
			var r0 = self.x, r1 = self.y, r2 = self.z, r3 = self.w, r4 = self.j, r5 = self.k, r6 = self.l, r7 = self.i;
			var s0 = dquat.x, s1 = dquat.y, s2 = dquat.z, s3 = dquat.w, s4 = dquat.j, s5 = dquat.k, s6 = dquat.l, s7 = dquat.i;
			var newX = r3 * s0 + r0 * s3 + r1 * s2 - r2 * s1;
			var newY = r3 * s1 + r1 * s3 + r2 * s0 - r0 * s2;
			var newZ = r3 * s2 + r2 * s3 + r0 * s1 - r1 * s0;
			var newW = r3 * s3 - r0 * s0 - r1 * s1 - r2 * s2;
			var newJ = r3 * s4 + r0 * s7 + r1 * s6 - r2 * s5 + r7 * s0 + r4 * s3 + r5 * s2 - r6 * s1;
			var newK = r3 * s5 + r1 * s7 + r2 * s4 - r0 * s6 + r7 * s1 + r5 * s3 + r6 * s0 - r4 * s2;
			var newL = r3 * s6 + r2 * s7 + r0 * s5 - r1 * s4 + r7 * s2 + r6 * s3 + r4 * s1 - r5 * s0;
			var newI = r3 * s7 - r0 * s4 - r1 * s5 - r2 * s6 + r7 * s3 - r4 * s0 - r5 * s1 - r6 * s2;
			return new DualQuaternion(newX, newY, newZ, newW, newJ, newK, newL, newI);
		};
		static Normalize = function() {
			var dquat = new DualQuaternion(self);
			var l = 1 / sqrt(sqr(dquat.x) + sqr(dquat.y) + sqr(dquat.z) + sqr(dquat.w));
			dquat.x *= l
			dquat.y *= l
			dquat.z *= l
			dquat.w *= l
			var d = dquat.x * dquat.j + dquat.y * dquat.k + dquat.z * dquat.l + dquat.w * dquat.i;
			dquat.j = (dquat.j - dquat.x * d) * l;
			dquat.k = (dquat.k - dquat.y * d) * l;
			dquat.l = (dquat.l - dquat.z * d) * l;
			dquat.i = (dquat.i - dquat.w * d) * l;
			return dquat;
		};
		static QuadraticInterpolate = function(dquat1, dquat2, amount) {
			var t0 = .5 * sqr(1 - amount);
			var t1 = .5 * amount * amount;
			var t2 = 2 * amount * (1 - amount);
			
			var b0 = dquat1.x, b1 = dquat1.y, b2 = dquat1.z, b3 = dquat1.w, b4 = dquat1.j, b5 = dquat1.k, b6 = dquat1.l, b7 = dquat1.i;
			var newX = t0 * (self.x + b0) + t1 * (b0 + dquat2.x) + t2 * b0;
			var newY = t0 * (self.y + b1) + t1 * (b1 + dquat2.y) + t2 * b1;
			var newZ = t0 * (self.z + b2) + t1 * (b2 + dquat2.z) + t2 * b2;
			var newW = t0 * (self.w + b3) + t1 * (b3 + dquat2.w) + t2 * b3;
			var newJ = t0 * (self.j + b4) + t1 * (b4 + dquat2.j) + t2 * b4;
			var newK = t0 * (self.k + b5) + t1 * (b5 + dquat2.k) + t2 * b5;
			var newL = t0 * (self.l + b6) + t1 * (b6 + dquat2.l) + t2 * b6;
			var newI = t0 * (self.i + b7) + t1 * (b7 + dquat2.i) + t2 * b7;
			return new DualQuaternion(newX, newY, newZ, newW, newJ, newK, newL, newI);
		};
	
	#endregion
	
	// Initialization of the Dual Quaternion
	if ( instanceof(argument[0]) == "DualQuaternion" ) self.Copy(argument[0]);
	else if (argument_count == 3) self.Set(axis, angle, translation);
	else if (argument_count == 8) self.SetRaw(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7]);
	else if (argument[0] == undefined) self.Set(new Vector3(0, 1, 0), 0, new Vector3());
};