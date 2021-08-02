function Vector2(x, y) constructor {
	/// @function Vector2(x, y) / Vector2(vector)
	/// @description Constructor for the 2-dimensonal vector data structure.
	/// @parameter [ {Real} x / {Vector2/Vector3/Vector4} vector ]
	/// @parameter [ {Real} y ]
		
	//		Set, Copy, ToString, Print
	#region Basic functionalities of Vector2
		
		// Set(x, y)
		// 	{real} x
		// 	{real} y
		// Returns: {Vector2}
		//
		// Sets the value of the Vector2 x and y variables using scalar values.
		// If this function is only called with one argument, every component
		// of the vector will be set to that value.
		static Set = function(x, y) {
			self.x = x;
			self.y = DefaultValue(y, x);
				
			return self;
		};
			
		// Copy(vector)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Vector2}
		//
		// Copy the x and y values of the vector given in the argument into this Vector2 structure.
		static Copy = function(vec) {
			self.x = vec.x;
			self.y = vec.y;
				
			return self;
		};
		
		// ToString()
		// Returns: {String}
		//
		// Returns a String with some well formated information of this Vector2 structure.
		static toString = function() {
			return "Vector2(x, y)\t{" + string(self.x) + "," + string(self.y) +  "}";
		};
		
	#endregion
		
	//		Equals, Length, Dot, Angle, Distance
	#region Methods that returns a single value
			
		// Equals(vec)
		// Returns: {Bool}
		// 	{Vector2/Vector3/Vector4} vector
		//
		// Compares every component and returns true if and only all are equal.
		static Equals = function(vec) {
			return ( self.x == vec.x && self.y == vec.y );
		};
		
		// Length()
		// Returns: {Real}
		// 
		// Returns the length of the vector. Calculates using the Pythagoras theorem. Pretty basic.
		static Length = function() {
			if ( self.x == 0 && self.y == 0 ) return 0;
				
			return sqrt( self.x*self.x + self.y*self.y );
		};
			
		// Dot(vec)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Real}
		//
		// Returns the Dot product between this vector and the given in the parameters.
		// The Dot product tells how similar two vectors are.
		// If both vectors are normalized:
		//		 1 means equal vectors
		//		 0 means perpendicular vector
		//		-1 means equal vector but pointing in the opposite direction
		// Any other inbetween value would mean an intermediate situation.
		static Dot = function(vec) {
			return self.x * vec.x + self.y * vec.y;
		};
			
		// Angle(vec)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Real}
		//
		// Returns the angle between two vectors. If the vectors are the same the returned angle is 0.
		// Also if one of the vectors has length of 0, it returns 0.
		static Angle = function(vec) {
			if ( self.Equals(vec) || self.Length() == 0 || vec.Length() == 0 ) return 0;
				
			return radtodeg( arccos( self.Dot(vec) / ( self.Length() * vec.Length() ) ) );
		};
			
		// Distance(vec)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Real}
		//
		// Returns the length between the two points defined by the vector.
		static Distance = function(vec) {
			return self.Substract(vec).Length();
		};
		
	#endregion
		
	//		Add, Substract, Multiply, Divide, Invert, Max, Min, Lerp,
	//		Normalize, MaxLength, MinLength, ClampLength, WrapLength.
	#region Methods that returns another vector
		
		// Add(vec)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Vector2}
		//
		// Operates this vector with every component of the other vector added to ours.
		// We would get the same vector as if we put one vector after another and we traced
		// a line between the (0,0) to the point they are ending at.
		static Add = function(vec) {
			return new Vector2(self.x + vec.x, self.y + vec.y);
		};
			
		// Substract(vec)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Vector2}
		//
		// Operates this vector with every component of the other vector substracted to ours.
		// We would get the same vector as if we put one vector after another (but this second in the 
		// oposite direction) and we traced a line between the (0,0) to the point they are ending at.
		static Substract = function(vec) {
			return new Vector2(self.x - vec.x, self.y - vec.y);
		};
			
		// Multiply(multiplier)
		// 	{real} multiplier
		// Returns: {Vector2}
		//
		// Operates this vector with every component multiplied by a scalar value.
		static Multiply = function(multiplier) {
			return new Vector2(self.x * multiplier, self.y * multiplier);
		};
			
		// Divide(divisor)
		// 	{real} divisor
		// Returns: {Vector2}
		//
		// Operates this vector with every component divided by a scalar value.
		static Divide = function(divisor) {
			if ( divisor == 0 )
				return new Vector2();
			return new Vector2(self.x / divisor, self.y / divisor);
		};
			
		// Invert()
		// Returns: {Vector2}
		//
		// Operates the oposite of the self vector. Changes are applyed.
		static Invert = function() {
			return new Vector2(self.Multiply(-1));
		};
			
		// Max(vec)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Vector2}
		//
		// Operates this vector with every component choosen between the bigger
		// components between this and the given on the parameters.
		static Max = function(vec) {
			return new Vector2(max(self.x, vec.x), max(self.y, vec.y));
		};
			
		// Min(vec)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Vector2}
		//
		// Operates this vector with every component choosen between the smaller
		// components between this and the given on the parameters.
		static Min = function(vec) {
			return new Vector2(min(self.x, vec.x), min(self.y, vec.y));
		};
			
		// Lerp(to, amount)
		// 	{Vector2/Vector3/Vector4} vector
		// 	{real} amount
		// Returns: {Vector2}
		//
		// Calculates for this vector the linear interpolation between
		// this vector and the given on the parameters by a given amount.
		// This means if amount is 0 we have the same vector and if amount
		// is 1 we get the vector on the parameters. Any in-between amount
		// value will be a component-wise calculation of:
		//		this + ( other - this ) * amount.
		static Lerp = function(to, amount) {
			return new Vector2(lerp(self.x , to.x, amount), lerp(self.y , to.y, amount));
		};
			
		// Normalize()
		// Returns: {Vector2}
		//
		// Normalizes this vector. This means we get the same vector. But with
		// its Length clamped to 1. In other words we get the unit vector (length 1)
		// for the direction we were already pointing at.
		static Normalize = function() {
			var len = self.Length();
				
			if ( len == 0 )
				return new Vector2(self);
				
			return new Vector2(self.Divide(len));
		};
			
		// MaxLength(maxLength)
		// 	{Real} maxLength
		// Returns: {Vector2}
		//
		// Clamps this vector to a given length. This means we get the same vector.
		// But the length cannot be longer than the one given on the parameters.
		static MaxLength = function(maxLength) {
			if ( self.Length() > maxLength )
				return new Vector2(self.Normalize().Multiply(maxLength));
				
			return new Vector2(self);
		};
			
		// MinLength(minLength)
		// 	{Real} minLength
		// Returns: {Vector2}
		//
		// Clamps this vector to a given length. This means we get the same vector.
		// But the length cannot be shorter than the one given on the parameters.
		static MinLength = function(minLength) {
			if ( self.Length() < minLength )
				return new Vector2(self.Normalize().Multiply(minLength));
				
			return new Vector2(self);
		};
			
		// ClampLength(minLength, maxLength)
		// 	{Real} minLength
		// 	{Real} maxLength
		// Returns: {Vector2}
		//
		// Clamps this vector to two given lengths. This means we get the same vector.
		// But the length has to be in between the two given lengths.
		static ClampLength = function(minLength, maxLength) {
			return self.MinLength(minLength).MaxLength(maxLength);
		};
			
		// WrapLength(minLength, maxLength)
		// 	{Real} minLength
		// 	{Real} maxLength
		// Returns: {Vector2}
		//
		// Wraps this vector to two given lengths. This means we get the same vector.
		// But the length has to be in between the two given lengths.
		// In this case if the length goes out of the boundaries the length will be wraped.
		// If we surpase the max we go to min, and if we go below min we set max.
		static WrapLength = function(minLength, maxLength) {
			var len = self.Length();
			if ( len < minLength || len > maxLength ) {
				var diff = maxLength-minLength;
				len = len - floor( (len - minLength) / diff ) * diff;
				return self.Normalize().Multiply(len);
			}
				
			return new Vector2(self);
		};
		
	#endregion
		
	// Construction of the vector
	if (IsIn(instanceof(argument[0]), ["Vector2", "Vector3", "Vector4"])) {
		self.Copy(argument[0]);
	} else {
		self.Set(DefaultValue(argument[0], 0), DefaultValue(argument[1], 0));
	}
};
	
function Vector3(x, y, z) : Vector2(x, y) constructor {
	/// @function Vector3(x, y, z) / Vector3(vector)
	/// @description Constructor for the 3-dimensonal vector data structure.
	/// @parameter [ {Real} x / {Vector2/Vector3/Vector4} vector ]
	/// @parameter [ {Real} y ]
	/// @parameter [ {Real} z ]
		
	//		Set, Copy, ToString, Print
	#region Basic functionalities of Vector3
		
		// Set(x, y, z)
		// 	{real} x
		// 	{real} y
		// 	{real} z
		// Returns: {Vector3}
		//
		// Sets the value of the Vector3 x, y and z variables using scalar values.
		// If this function is only called with one argument, every component
		// of the vector will be set to that value.
		static Set = function(x, y, z) {
			self.x = x;
			self.y = DefaultValue(y, x);
			self.z = DefaultValue(z, x);
				
			return self;
		};
			
		// Copy(vector)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Vector3}
		//
		// Copy the x, y and z values of the vector given in the argument into this Vector4 structure.
		static Copy = function(vec) {
					
			self.x = vec.x;
			self.y = vec.y;
			if ( instanceof(vec) == "Vector2" ) self.z = 0;
			else self.z = vec.z;
				
			return self;
		};
		
		// ToString()
		// Returns: {String}
		//
		// Returns a String with some well formated information of the Vector3 structure.
		static toString = function() {
			return "Vector2(x, y, z)\t{" + string(self.x) + "," + string(self.y) + "," + string(self.z) +  "}";
		};
		
	#endregion
		
	//		Equals, Length, Dot, Angle, Distance
	#region Methods that returns a single value
		
		// Equals(vec)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Bool}
		//
		// Compares every component and returns true if and only all are equal.
		static Equals = function(vec) {
			if ( instanceof(vec) == "Vector2" )
				vec = new Vector3(vec);
					
			return ( self.x == vec.x && self.y == vec.y && self.z == vec.z );
		};
		
		// Length()
		// Returns: {Real}
		// 
		// Returns the length of the vector. Calculates using the Pythagoras
		// theorem. Pretty basic.
		static Length = function() {
			if ( self.x == 0 && self.y == 0 && self.z == 0 ) return 0;
			
			return sqrt( self.x*self.x + self.y*self.y + self.z*self.z );
		};
			
		// Dot()
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Real}
		//
		// Returns the Dot product between this vector and the given in the parameters.
		// The Dot product tells how similar two vectors are. If both normalized 1 means equal vectors,
		// -1 means equal vector but pointing in the opposite direction and 0 means perpendicular vector.
		static Dot = function(vec) {
			if ( instanceof(vec) == "Vector2" )
				vec = new Vector3(vec);
					
			return self.x * vec.x + self.y * vec.y + self.z * vec.z;
		};
			
		// Angle(vec)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Real}
		//
		// Returns the angle between two vectors. If the vectors are the same the returned angle is 0.
		// Also if one of the vectors has length of 0, it returns 0.
		static Angle = function(vec) {
			if ( instanceof(vec) == "Vector2" )
				vec = new Vector3(vec);
				
			if ( self.Equals(vec) || self.Length() == 0 || vec.Length() == 0 ) return 0;
				
			return radtodeg( arccos( self.Dot(vec) / ( self.Length() * vec.Length() ) ) );
		};
			
		// Distance(vec)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Real}
		//
		// Returns the length between the two points defined by the vector.
		static Distance = function(vec) {
			if ( instanceof(vec) == "Vector2" )
				vec = new Vector3(vec);
					
			return self.Substracted(vec).Length();
		};
			
	#endregion
		
	//		Cross, Add, Substract, Multiply, Divide, Invert, Max, Min,
	//		Lerp, Normalize, MaxLength, MinLength, ClampLength, WrapLength.
	#region Methods that returns another vector
			
		// Cross()
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Vector3}
		//
		// The cross product takes two vectors and returns the perpendicular
		// projection of thes two with length equals the product of the lengths
		// of the two vectors multiplied by the cos of the angle between them.
		static Cross = function(vec) {
			if ( instanceof(vec) == "Vector2" )
				vec = new Vector3(vec);
					
			newX = self.y*vec.z - self.z*vec.y;
			newY = self.z*vec.x - self.x*vec.z;
			newZ = self.x*vec.y - self.y*vec.x;
			
			return new Vector3(newX, newY, newZ);
		};
		
		static Orthogonal = function(vec) {
		    var dot = self.Dot(vec);
        	return [vec.x - self.x * dot,
        			vec.y - self.y * dot,
        			vec.z - self.z * dot];
		}
		
		// Add(vec)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Vector3}
		//
		// Operates this vector with every component of the other vector added to ours.
		// We would get the same vector as if we put one vector after another and we traced
		// a line between the (0,0) to the point they are ending at.
		static Add = function(vec) {
			if ( instanceof(vec) == "Vector2" )
				vec = new Vector3(vec);
					
			return new Vector3(self.x + vec.x, self.y + vec.y, self.z + vec.z);
		};
			
		// Substract(vec)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Vector3}
		//
		// Operates this vector with every component of the other vector substracted to ours.
		// We would get the same vector as if we put one vector after another (but this second in the 
		// oposite direction) and we traced a line between the (0,0) to the point they are ending at.
		static Substract = function(vec) {
			if ( instanceof(vec) == "Vector2" )
				vec = new Vector3(vec);
					
			return new Vector3(self.x - vec.x, self.y - vec.y, self.z - vec.z);
		};
			
		// Multiply(multiplier)
		// 	{real} multiplier
		// Returns: {Vector3}
		//
		// Operates this vector with every component multiplied by a scalar value.
		static Multiply = function(multiplier) {
			return new Vector3(self.x * multiplier, self.y * multiplier, self.z * multiplier);
		};
			
		// Divide(divisor)
		// 	{real} divisor
		// Returns: {Vector3}
		//
		// Operates this vector with every component divided by a scalar value.
		static Divide = function(divisor) {
			if ( divisor == 0 )
				return new Vector3();
					
			return new Vector3(self.x / divisor, self.y / divisor, self.z / divisor);
		};
			
		// Invert()
		// Returns: {Vector3}
		//
		// Operates the oposite of the self vector. Changes are applyed.
		static Invert = function() {
			return new Vector3(self.Multiply(-1));
		};
			
		// Max(vec)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Vector3}
		//
		// Operates this vector with every component choosen between the bigger
		// components between this and the given on the parameters.
		static Max = function(vec) {
			if ( instanceof(vec) == "Vector2" )
				vec = new Vector3(vec);
			return new Vector3(max(self.x, vec.x), max(self.y, vec.y), max(self.z, vec.z));
		};
			
		// Min(vec)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Vector3}
		//
		// Operates this vector with every component choosen between the smaller
		// components between this and the given on the parameters.
		static Min = function(vec) {
			if ( instanceof(vec) == "Vector2" )
				vec = new Vector3(vec);
			return new Vector3(min(self.x, vec.x), min(self.y, vec.y), min(self.y, vec.y));
		};
			
		// Lerp(to, amount)
		// 	{Vector2/Vector3/Vector4} vector
		// 	{real} amount
		// Returns: {Vector3}
		//
		// Calculates for this vector the linear interpolation between
		// this vector and the given on the parameters by a given amount.
		// This means if amount is 0 we have the same vector and if amount
		// is 1 we get the vector on the parameters. Any in-between amount
		// value will be a component-wise calculation of:
		//		this + ( other - this ) * amount.
		static Lerp = function(to, amount) {
			if ( instanceof(to) == "Vector2" )
				to = new Vector3(to);
			return new Vector3(lerp(self.x , to.x, amount), lerp(self.y , to.y, amount), lerp(self.z , to.z, amount));
		};
			
		// Normalize()
		// Returns: {Vector3}
		//
		// Normalizes this vector. This means we get the same vector. But with
		// its Length clamped to 1. In other words we get the unit vector (length 1)
		// for the direction we were already pointing at.
		static Normalize = function() {
			var len = self.Length();
				
			if ( len == 0 )
				return new Vector3(self);
				
			return new Vector3(self.Divide(len));
		};
			
		// MaxLength(maxLength)
		// 	{Real} maxLength
		// Returns: {Vector3}
		//
		// Clamps this vector to a given length. This means we get the same vector.
		// But the length cannot be longer than the one given on the parameters.
		static MaxLength = function(maxLength) {
			if ( self.Length() > maxLength )
				return new Vector3(self.Normalize().Multiply(maxLength));
				
			return new Vector3(self);
		};
			
		// MinLength(minLength)
		// 	{Real} minLength
		// Returns: {Vector3}
		//
		// Clamps this vector to a given length. This means we get the same vector.
		// But the length cannot be shorter than the one given on the parameters.
		static MinLength = function(minLength) {
			if ( self.Length() < minLength )
				return new Vector3(self.Normalize().Multiply(minLength));
				
			return new Vector3(self);
		};
			
		// ClampLength(minLength, maxLength)
		// 	{Real} minLength
		// 	{Real} maxLength
		// Returns: {Vector3}
		//
		// Clamps this vector to two given lengths. This means we get the same vector.
		// But the length has to be in between the two given lengths.
		static ClampLength = function(minLength, maxLength) {
			return self.MinLength(minLength).MaxLength(maxLength);
		};
			
		// WrapLength(minLength, maxLength)
		// 	{Real} minLength
		// 	{Real} maxLength
		// Returns: {Vector3}
		//
		// Wraps this vector to two given lengths. This means we get the same vector.
		// But the length has to be in between the two given lengths.
		// In this case if the length goes out of the boundaries the length will be wraped.
		// If we surpase the max we go to min, and if we go below min we set max.
		static WrapLength = function(minLength, maxLength) {
			var len = self.Length();
			if ( len < minLength || len > maxLength ) {
				var diff = maxLength-minLength;
				len = len - floor( (len - minLength) / diff ) * diff;
				return self.Normalize().Multiply(len);
			}
				
			return new Vector3(self);
		};
		
	#endregion
		
		
	// Construction of the vector
	if (IsIn(instanceof(argument[0]), ["Vector2", "Vector3", "Vector4"])) {
		self.Copy(argument[0]);
	} else {
		if (is_array(argument[0])) {
			var arr = argument[0];
			self.Set(arr[0], arr[1], arr[2]);
		} else 
			self.Set(DefaultValue(argument[0], 0), DefaultValue(argument[1], 0), DefaultValue(argument[2], 0));
	}
};
	
function Vector4(x, y, z, w) : Vector3(x, y, z) constructor{
	/// @function Vector4(x, y, z, w) / Vector4(vector)
	/// @description Constructor for the 4-dimensonal vector data structure.
	/// @parameter {real} [x] / {Vector2/Vector3/Vector4} vector (Use the last one for construction by copy)
	/// @parameter {real} [y]
	/// @parameter {real} [z]
	/// @parameter {real} [w]
		
	//		Set, Copy, ToString, Print
	#region Basic functionalities of Vector3
		
		// Set(x, y, z, w)
		// 	{real} x
		// 	{real} y
		// 	{real} z
		// 	{real} w
		// Returns: {Vector4}
		//
		// Sets the value of the Vector3 x, y, z and w variables using scalar values.
		// If this function is only called with one argument, every component
		// of the vector will be set to that value.
		static Set = function(x, y, z, w) {
			self.x = x;
			self.y = DefaultValue(y, x);
			self.z = DefaultValue(z, x);
			self.w = DefaultValue(w, x);
				
			return self;
		};
			
		// Copy(vector)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Vector4}
		//
		// Copy the x, y, z and w values of the vector given in the argument into this Vector4 structure.
		static Copy = function(vec) {
			if ( instanceof(vec) == "Vector2" || instanceof(vec) == "Vector3" )
				vec = new Vector4(vec);
					
			self.x = vec.x;
			self.y = vec.y;
			self.z = vec.z;
			self.w = vec.w;
				
			return self;
		};
		
		// ToString()
		// Returns: {String}
		//
		// Returns a String with some well formated information of the Vector4 structure.
		static toString = function() {
			return "Vector2(x, y, z, w)\t{" + string(self.x) + "," + string(self.y) + ","
											+ string(self.z) + "," + string(self.w) +  "}";
		};
		
	#endregion
		
	//		Equals, Length, Dot, Angle, Distance
	#region Methods that returns a single value
		
		// Equals(vec)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Bool}
		//
		// Compares every component and returns true if and only all are equal.
		static Equals = function(vec) {
			if ( instanceof(vec) == "Vector2" || instanceof(vec) == "Vector3" )
				vec = new Vector4(vec);
					
			return ( self.x == vec.x && self.y == vec.y && self.z == vec.z && self.w == vec.w );
		};
		
		// Length()
		// Returns: {Real}
		// 
		// Returns the length of the vector. Calculates using the Pythagoras
		// theorem. Pretty basic.
		static Length = function() {
			if ( self.x == 0 && self.y == 0 && self.z == 0 && self.w == 0 ) return 0;
				
			return sqrt( self.x*self.x + self.y*self.y + self.z*self.z + self.w*self.w );
		};
			
		// Dot()
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Real}
		//
		// Returns the Dot product between this vector and the given in the parameters.
		// The Dot product tells how similar two vectors are. If both normalized 1 means equal vectors,
		// -1 means equal vector but pointing in the opposite direction and 0 means perpendicular vector.
		static Dot = function(vec) {
			if ( instanceof(vec) == "Vector2" || instanceof(vec) == "Vector3" )
				vec = new Vector4(vec);
					
			return self.x * vec.x + self.y * vec.y + self.z * vec.z + self.w*vec.w;
		};
			
		// Angle(vec)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Real}
		//
		// Returns the angle between two vectors. If the vectors are the same the returned angle is 0.
		// Also if one of the vectors has length of 0, it returns 0.
		static Angle = function(vec) {
			if ( instanceof(vec) == "Vector2" || instanceof(vec) == "Vector3" )
				vec = new Vector4(vec);
				
			if ( self.Equals(vec) || self.Length() == 0 || vec.Length() == 0 ) return 0;
				
			return radtodeg( arccos( self.Dot(vec) / ( self.Length() * vec.Length() ) ) );
		};
			
		// Distance(vec)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Real}
		//
		// Returns the length between the two points defined by the vector.
		static Distance = function(vec) {
			if ( instanceof(vec) == "Vector2" || instanceof(vec) == "Vector3" )
				vec = new Vector4(vec);
					
			return self.Substract(vec).Length();
		};
			
	#endregion
		
	//		Cross, Add, Substract, Multiply, Divide, Invert, Max, Min,
	//		Lerp, Normalize, MaxLength, MinLength, ClampLength, WrapLength.
	#region Methods that returns another vector
			
		// Cross()
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Vector3}
		//
		// The cross product takes two vectors and returns the perpendicular
		// projection of thes two with length equals the product of the lengths
		// of the two vectors multiplied by the cos of the angle between them.
		// 
		// The cross product of Vector4 is not implemented. We just do the 3D
		// Cross product instead.
		// ---- INHERITED ----
			
		// Add(vec)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Vector3}
		//
		// Operates this vector with every component of the other vector added to ours.
		// We would get the same vector as if we put one vector after another and we traced
		// a line between the (0,0) to the point they are ending at.
		static Add = function(vec) {
			if ( instanceof(vec) == "Vector2" || instanceof(vec) == "Vector3" )
				vec = new Vector4(vec);
					
			return new Vector4(self.x + vec.x, self.y + vec.y,
								self.z + vec.z, self.w + vec.w);
		};
			
		// Substract(vec)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Vector3}
		//
		// Operates this vector with every component of the other vector substracted to ours.
		// We would get the same vector as if we put one vector after another (but this second in the 
		// oposite direction) and we traced a line between the (0,0) to the point they are ending at.
		static Substract = function(vec) {
			if ( instanceof(vec) == "Vector2" || instanceof(vec) == "Vector3" )
				vec = new Vector4(vec);
					
			return new Vector4(self.x - vec.x, self.y - vec.y,
								self.z - vec.z, self.w - vec.w);
		};
			
		// Multiply(multiplier)
		// 	{real} multiplier
		// Returns: {Vector4}
		//
		// Operates this vector with every component multiplied by a scalar value.
		static Multiply = function(multiplier) {
			return new Vector4(self.x * multiplier, self.y * multiplier,
								self.z * multiplier, self.w * multiplier);
		};
			
		// Divide(divisor)
		// 	{real} divisor
		// Returns: {Vector4}
		//
		// Operates this vector with every component divided by a scalar value.
		static Divide = function(divisor) {
			if ( divisor == 0 )
				return new Vector4();
					
			return new Vector4(self.x / divisor, self.y / divisor,
								self.w / divisor, self.w / divisor);
		};
			
		// Invert()
		// Returns: {Vector4}
		//
		// Operates the oposite of the self vector. Changes are applyed.
		static Invert = function() {
			return new Vector4(self.Multiply(-1));
		};
			
		// Max(vec)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Vector4}
		//
		// Operates this vector with every component choosen between the bigger
		// components between this and the given on the parameters.
		static Max = function(vec) {
			if ( instanceof(vec) == "Vector2" || instanceof(vec) == "Vector3" )
				vec = new Vector4(vec);
			return new Vector4(max(self.x, vec.x), max(self.y, vec.y),
								max(self.z, vec.z), max(self.w, vec.w));
		};
			
		// Min(vec)
		// 	{Vector2/Vector3/Vector4} vector
		// Returns: {Vector4}
		//
		// Operates this vector with every component choosen between the smaller
		// components between this and the given on the parameters.
		static Min = function(vec) {
			if ( instanceof(vec) == "Vector2" || instanceof(vec) == "Vector3" )
				vec = new Vector4(vec);
			return new Vector4(min(self.x, vec.x), min(self.y, vec.y),
								min(self.y, vec.y), min(self.w, vec.w));
		};
			
		// Lerp(to, amount)
		// 	{Vector2/Vector3/Vector4} vector
		// 	{real} amount
		// Returns: {Vector4}
		//
		// Calculates for this vector the linear interpolation between
		// this vector and the given on the parameters by a given amount.
		// This means if amount is 0 we have the same vector and if amount
		// is 1 we get the vector on the parameters. Any in-between amount
		// value will be a component-wise calculation of:
		//		this + ( other - this ) * amount.
		static Lerp = function(to, amount) {
			if ( instanceof(vec) == "Vector2" || instanceof(vec) == "Vector3" )
				vec = new Vector4(vec);
			return new Vector4(lerp(self.x , to.x, amount), lerp(self.y , to.y, amount),
								lerp(self.z , to.z, amount), lerp(self.w , to.w, amount));
		};
			
		// Normalize()
		// Returns: {Vector4}
		//
		// Normalizes this vector. This means we get the same vector. But with
		// its Length clamped to 1. In other words we get the unit vector (length 1)
		// for the direction we were already pointing at.
		static Normalize = function() {
			var len = self.Length();
				
			if ( len == 0 )
				return new Vector4(self);
				
			return new Vector4(self.Divide(len));
		};
			
		// MaxLength(maxLength)
		// 	{Real} maxLength
		// Returns: {Vector4}
		//
		// Clamps this vector to a given length. This means we get the same vector.
		// But the length cannot be longer than the one given on the parameters.
		static MaxLength = function(maxLength) {
			if ( self.Length() > maxLength )
				return new Vector4(self.Normalize().Multiply(maxLength));
				
			return new Vector4(self);
		};
			
		// MinLength(minLength)
		// 	{Real} minLength
		// Returns: {Vector3}
		//
		// Clamps this vector to a given length. This means we get the same vector.
		// But the length cannot be shorter than the one given on the parameters.
		static MinLength = function(minLength) {
			if ( self.Length() < minLength )
				return new Vector4(self.Normalize().Multiply(minLength));
				
			return new Vector4(self);
		};
			
		// ClampLength(minLength, maxLength)
		// 	{Real} minLength
		// 	{Real} maxLength
		// Returns: {Vector4}
		//
		// Clamps this vector to two given lengths. This means we get the same vector.
		// But the length has to be in between the two given lengths.
		static ClampLength = function(minLength, maxLength) {
			return self.MinLength(minLength).MaxLength(maxLength);
		};
			
		// WrapLength(minLength, maxLength)
		// 	{Real} minLength
		// 	{Real} maxLength
		// Returns: {Vector4}
		//
		// Wraps this vector to two given lengths. This means we get the same vector.
		// But the length has to be in between the two given lengths.
		// In this case if the length goes out of the boundaries the length will be wraped.
		// If we surpase the max we go to min, and if we go below min we set max.
		static WrapLength = function(minLength, maxLength) {
			var len = self.Length();
			if ( len < minLength || len > maxLength ) {
				var diff = maxLength-minLength;
				len = len - floor( (len - minLength) / diff ) * diff;
				return self.Normalize().Multiply(len);
			}
				
			return new Vector4(self);
		};
		
	#endregion
		
		
	// Construction of the vector
	if (IsIn(instanceof(argument[0]), ["Vector2", "Vector3", "Vector4"])) {
		self.Copy(argument[0]);
	} else {
		self.Set(DefaultValue(argument[0], 0), DefaultValue(argument[1], 0),
					DefaultValue(argument[2], 0), DefaultValue(argument[3], 0));
	}
		
	self.rgb = make_color_rgb(self.x, self.y, self.z);
};
