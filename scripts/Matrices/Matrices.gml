function Matrix3x3(a0, a1, a2, a3, a4, a5, a6, a7, a8) constructor {
	if (a1!=undefined) {
		self.arrayForm = [a0, a1, a2, a3, a4, a5, a6, a7, a8];
	} else {
		if (a0!=undefined) {
			if (is_array(a0)) {
				self.arrayForm = a0;
			} else {
				self.arrayForm = [a0, a0, a0, a0, a0, a0, a0, a0, a0];
			}
		} else {
			self.arrayForm = [1, 0, 0, 0, 1, 0, 0, 0, 1];
		}
	}
	
	static Add = function(b) {
		var a = self.arrayForm; b = b.arrayForm;
		return new Matrix3x3(
			a[0] + b[0], a[1] + b[1], a[2] + b[2],
			a[3] + b[3], a[4] + b[4], a[5] + b[5],
			a[6] + b[6], a[7] + b[7], a[8] + b[8]
		);
	};
	
	static Multiply = function(b) {
		var a = self.arrayForm;
		
		if (instanceof(b) == "Matrix3x3") {
			b = b.arrayForm;
			return new Matrix3x3(
				a[0] * b[0] + a[1] * b[3] + a[2] * b[6],
				a[0] * b[1] + a[1] * b[4] + a[2] * b[7],
				a[0] * b[2] + a[1] * b[5] + a[2] * b[8],
				a[3] * b[0] + a[4] * b[3] + a[5] * b[6],
				a[3] * b[1] + a[4] * b[4] + a[5] * b[7],
				a[3] * b[2] + a[4] * b[5] + a[5] * b[8],
				a[6] * b[0] + a[7] * b[3] + a[8] * b[6],
				a[6] * b[1] + a[7] * b[4] + a[8] * b[7],
				a[6] * b[2] + a[7] * b[5] + a[8] * b[8]
			);
		} else {
			return new Matrix3x3(
				b*a[0], b*a[1], b*a[2],
				b*a[3], b*a[4], b*a[4],
				b*a[6], b*a[7], b*a[8]
			);
		}
	};
	
	static Transpose = function() {
		var a = self.arrayForm;
		return new Matrix3x3(
			a[0], a[3], a[6],
			a[1], a[4], a[7],
			a[2], a[5], a[8]
		);
	};
	
	static Determinant = function() {
		var a = self.arrayForm;
		return ( a[0]*a[4]*a[8] + a[2]*a[3]*a[7] + a[1]*a[5]*a[6] )
		- ( a[2]*a[4]*a[6] + a[1]*a[3]*a[8] + a[0]*a[5]*a[7] );
	};
	
	static toString = function() {
		var a = self.arrayForm;
		return ( "Matrix 3x3:\n" +
			"\t[ " + string(a[0]) + ", " + string(a[1]) + ", " + string(a[2]) + " ]\n" +
			"\t[ " + string(a[3]) + ", " + string(a[4]) + ", " + string(a[5]) + " ]\n" + 
			"\t[ " + string(a[6]) + ", " + string(a[7]) + ", " + string(a[8]) + " ]\n"
		);
	};

};

function Matrix4x4(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15) constructor {
	
	if (a1!=undefined) {
		self.arrayForm = [a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15];
	} else {
		if (a0!=undefined) {
			if (is_array(a0)) {
				self.arrayForm = a0;
			} else {
				self.arrayForm = [a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15];
			}
		} else {
			self.arrayForm = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
		}
	}
	
	static Add = function(b) {
		var a = self.arrayForm; b = b.arrayForm;
		return new Matrix4x4(
			a[0] + b[0], a[1] + b[1], a[2] + b[2], a[3] + b[3],
			a[4] + b[4], a[5] + b[5], a[6] + b[6], a[7] + b[7],
			a[8] + b[8], a[9] + b[9], a[10] + b[10], a[11] + b[11],
			a[12] + b[12], a[13] + b[13], a[14] + b[14], a[15] + b[15]
		);
	};
	
	// Multiplies this matrix by other. The other matrix is on the right.
	static Multiply = function(b) {
		var a = self.arrayForm;
		
		if (instanceof(b)=="Matrix4x4") {
			b = b.arrayForm;
			return new Matrix4x4(
				a[0] * b[0] + a[1] * b[4] + a[2] * b[8] + a[3] * b[12],
				a[0] * b[1] + a[1] * b[5] + a[2] * b[9] + a[3] * b[13],
				a[0] * b[2] + a[1] * b[6] + a[2] * b[10] + a[3] * b[14],
				a[0] * b[3] + a[1] * b[7] + a[2] * b[11] + a[3] * b[15],
				a[4] * b[0] + a[5] * b[4] + a[6] * b[8] + a[7] * b[12],
				a[4] * b[1] + a[5] * b[5] + a[6] * b[9] + a[7] * b[13],
				a[4] * b[2] + a[5] * b[6] + a[6] * b[10] + a[7] * b[14],
				a[4] * b[3] + a[5] * b[7] + a[6] * b[11] + a[7] * b[15],
				a[8] * b[0] + a[9] * b[4] + a[10] * b[8] + a[11] * b[12],
				a[8] * b[1] + a[9] * b[5] + a[10] * b[9] + a[11] * b[13],
				a[8] * b[2] + a[9] * b[6] + a[10] * b[10] + a[11] * b[14],
				a[8] * b[3] + a[9] * b[7] + a[10] * b[11] + a[11] * b[15],
				a[12] * b[0] + a[13] * b[4] + a[14] * b[8] + a[15] * b[12],
				a[12] * b[1] + a[13] * b[5] + a[14] * b[9] + a[15] * b[13],
				a[12] * b[2] + a[13] * b[6] + a[14] * b[10] + a[15] * b[14],
				a[12] * b[3] + a[13] * b[7] + a[14] * b[11] + a[15] * b[15]
			);
		} else {
			return new Matrix4x4(
				a[0]*b, a[1]*b, a[2]*b, a[3]*b,
				a[4]*b, a[5]*b, a[6]*b, a[7]*b,
				a[8]*b, a[9]*b, a[10]*b, a[11]*b,
				a[12]*b, a[13]*b, a[14]*b, a[15]*b
			);
		}
	};
	
	static Determinant = function() {
		var a = self.arrayForm;
		
	    return a[0]*self.Cofactor(0).Determinant() - a[1]*self.Cofactor(1).Determinant()
	    + a[2]*self.Cofactor(2).Determinant() - a[3]*self.Cofactor(3).Determinant();
	};
	
	static Transpose = function() {
		var a = self.arrayForm;
		return new Matrix4x4(
			a[0], a[4], a[8], a[12],
			a[1], a[5], a[9], a[13],
			a[2], a[6], a[10], a[14],
			a[3], a[7], a[11], a[15]
		);
	};
	
	static Adjugate = function() {
		var a = self.arrayForm;
		var adjugateMatrix = new Matrix4x4();
		var m, n;
		for(var i=0; i<16; i++) {
			m = i div 4;
			n = i % 4;
			adjugateMatrix.arrayForm[i] = power(-1, m+n)*self.Cofactor(i).Determinant();
		}
		return adjugateMatrix;
	};
	
	static Invert = function(matrix) {
		var det = self.Determinant();
		if (det!=0)
			return self.Transpose().Adjugate().Multiply(1/det);
		else
			return NULL;
	}
	
	static Cofactor = function(m, n) {
		if (n==undefined) {
			var aux = m;
			m = aux div 4;
			n = aux % 4;
		}
		var cofactorMat = new Matrix3x3();
		var idx = 0;
		for(var j=0; j<4; j++)
			for(var i=0; i<4; i++)
				if ( j!=m && i!=n )
					cofactorMat.arrayForm[idx++] = self.arrayForm[j*4+i];
		return cofactorMat;
	};
	
	static toString = function() {
		var a = self.arrayForm;
		return ( "Matrix 4x4:\n" +
			"\t[" + string(a[0]) + ", " + string(a[1]) + ", " + string(a[2]) + ", " + string(a[3]) + " ]\n" +
			"\t[" + string(a[4]) + ", " + string(a[5]) + ", " + string(a[6]) + ", " + string(a[7]) + " ]\n" +
			"\t[" + string(a[8]) + ", " + string(a[9]) + ", " + string(a[10]) + ", " + string(a[11]) + " ]\n" +
			"\t[" + string(a[12]) + ", " + string(a[13]) + ", " + string(a[14]) + ", " + string(a[15]) + " ]\n"
		);
	};
	
	static GetQuaternion = function() {
		// Code from:
		// https://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/
		var a = self.arrayForm;
		var qx, qy, qz, qw;
		
		var m00 = a[0];
		var m01 = a[1];
		var m02 = a[2];
		var m10 = a[4];
		var m11 = a[5];
		var m12 = a[6];
		var m20 = a[8];
		var m21 = a[9];
		var m22 = a[10];
		
		var tr = m00 + m11 + m22;

		if (tr > 0) { 
            var S = sqrt(tr+1.0) * 2; // S=4*qw 
            qw = 0.25 * S;
            qx = (m21 - m12) / S;
            qy = (m02 - m20) / S; 
            qz = (m10 - m01) / S; 
		} else if ((m00 > m11)&(m00 > m22)) { 
            var S = sqrt(1.0 + m00 - m11 - m22) * 2; // S=4*qx 
            qw = (m21 - m12) / S;
            qx = 0.25 * S;
            qy = (m01 + m10) / S; 
            qz = (m02 + m20) / S; 
		} else if (m11 > m22) { 
            var S = sqrt(1.0 + m11 - m00 - m22) * 2; // S=4*qy
            qw = (m02 - m20) / S;
            qx = (m01 + m10) / S; 
            qy = 0.25 * S;
            qz = (m12 + m21) / S; 
		} else { 
            var S = sqrt(1.0 + m22 - m00 - m11) * 2; // S=4*qz
            qw = (m10 - m01) / S;
            qx = (m02 + m20) / S;
            qy = (m12 + m21) / S;
            qz = 0.25 * S;
		}
		
		return new Quaternion(qx, qy, qz, qw);
	};

	static GetTranslation = function() {
		var a = self.arrayForm;
		
		return new Vector3(a[12], a[13], a[14]);
	};
	
	static GetDualQuaternion = function() {
    	var q = self.GetQuaternion();
    	var t = self.GetTranslation();
    	
    	var tj = .5 * (t.x * q.w + t.y * q.z - t.z * q.x);
		var tk = .5 * (t.y * q.w + t.z * q.x - t.x * q.z);
		var tl = .5 * (t.z * q.w + t.x * q.y - t.y * q.x);
		var ti = .5 * (- t.x * q.x - t.y * q.y - t.z * q.z);
		return new DualQuaternion(q.x, q.y, q.z, q.w, tj, tk, tl, ti);
	};
	
	static SetToUp = function(x, y, z, toX, toY, toZ, upX, upY, upZ, xScale, yScale, zScale) {
	    // From SMF
	    var l = toX * toX + toY * toY + toZ * toZ;
    	if (l > 0) l = 1 / sqrt(l);
    	else Print("Supplied zero-length vector for to-vector.");
    	toX *= l;
    	toY *= l;
    	toZ *= l;
    
    	//Orthogonalize up-vector to to-vector
    	var dot = upX * toX + upY * toY + upZ * toZ;
    	upX -= toX * dot;
    	upY -= toY * dot;
    	upZ -= toZ * dot;
    
    	//Normalize up-vector
    	l = upX * upX + upY * upY + upZ * upZ;
    	if (l > 0) l = 1 / sqrt(l);
    	else Print("Supplied zero-length vector for up-vector, or the up- and to-vectors are parallel.");
    		
    	upX *= l;
    	upY *= l;
    	upZ *= l;
    
    	//Create side vector
    	var siX, siY, siZ;
    	siX = upY * toZ - upZ * toY;
    	siY = upZ * toX - upX * toZ;
    	siZ = upX * toY - upY * toX;
    
    	//Return a 4x4 matrix
    	self.arrayForm = [toX * xScale, toY * xScale, toZ * xScale, 0,
    			siX * yScale, siY * yScale, siZ * yScale, 0,
    			upX * zScale, upY * zScale, upZ * zScale, 0,
    			x,  y,  z,  1];
	};
};
