function LoadDAE(filename, texture) {
	// Load the collada file
	var collada = new CE_XmlDocument();
	collada.load(filename);
	
	#region SKELETON
	
	var skeletonData = collada.root.get_child_by_name("library_visual_scenes").get_child(0).get_child(0);
	if (skeletonData.get_attribute("id") != "Armature") skeletonData = NULL;
	
	var skeleton = NULL;
	if (skeletonData != NULL) {
		// Create the skeleton struct
		skeleton = new Geometry.Skeleton();
		skeleton.name = skeletonData.get_attribute("name");
		skeleton.RecursiveCreate(skeletonData.get_child(1));
	
		// --- SKINNING --------
		var skinningData = collada.root.get_child_by_name("library_controllers").get_child(0).get_child(0);
		skeleton.jointsNames = Split(skinningData.get_child(1).get_child(0).value, " ");
		skeleton.bindShapeMat = new Matrix4x4(Split(skinningData.get_child_by_name("bind_shape_matrix").value, " ", true));
		skeleton.bindShapeMat = skeleton.bindShapeMat.Transpose().GetDualQuaternion();
		
		// Vertex weights and association to joints
		var associations = skinningData.get_child_by_name("vertex_weights");
		var vcount = Split(associations.get_child_by_name("vcount").value, " ", true);
		var v = Split(associations.get_child_by_name("v").value, " ", true);
		var weights = Split(skinningData.get_child(3).get_child(0).value, " ", true);
		
		Print(skeleton);
	#endregion
		
	#region ANIMATION
	
		var libAnim = collada.root.get_child_by_name("library_animations")
		
		if (libAnim != NULL) {
			var animationData = libAnim.get_child(0);
			var skNameLen = string_length(skeleton.name);
			for(var i=0; i<animationData.get_child_count(); i++) {
				// Get the whole joint animation
				var animJoint = animationData.get_child(i);
				
				// Animation name
				var animName = Split(animJoint.get_attribute("id"), "_")[1];
				
				// Find the target joint name of this animation
				var jointName = animJoint.get_child(4).get_attribute("target");
				jointName = Split(jointName, "/")[0];
				jointName = string_copy(jointName, skNameLen+2, string_length(jointName)-skNameLen);
				
				// Get the keyframes time
				var fTime = Split(animJoint.get_child(0).get_child(0).value, " ", true);
				
				// Get the transformations
				var fTrans = Split(animJoint.get_child(1).get_child(0).value, " ", true);
				
				// Save the keyframes on the joint
				var joint = skeleton.GetJoint(jointName);
				
				var timeTrans = [];
				for(var j=0, n=array_length(fTime); j<n; j++) {
					var k = j*16;
					var mat = new Matrix4x4(
						fTrans[k+0], fTrans[k+1], fTrans[k+2], fTrans[k+3],
						fTrans[k+4], fTrans[k+5], fTrans[k+6], fTrans[k+7],
						fTrans[k+8], fTrans[k+9], fTrans[k+10], fTrans[k+11],
						fTrans[k+12], fTrans[k+13], fTrans[k+14], fTrans[k+15],
					);
					var dq = mat.Transpose().GetDualQuaternion();
					array_push(timeTrans, [fTime[j], dq]);
				}
				
				joint.animations[? animName] = timeTrans;
			}
		}
	}
	
	#endregion
	
	#region GEOMETRY
	
	var geometriesData = collada.root.get_child_by_name("library_geometries");
	
	// Here I just get the first mesh but we could loop on this
	var mesh = geometriesData.get_child(0).get_child(0);
	var pos = Split(mesh.get_child(0).get_child(0).value, " ", true);
	var nor = Split(mesh.get_child(1).get_child(0).value, " ", true);
	var tex = Split(mesh.get_child(2).get_child(0).value, " ", true);
	var tris = Split(mesh.get_child_by_name("triangles").get_child_by_name("p").value, " ", true);
	
	// Create the mesh
	var modelBuff = vertex_create_buffer();
	if (skeleton==NULL)
		vertex_begin(modelBuff, Geometry.Format.Textured.format);
	else
		vertex_begin(modelBuff, Geometry.Format.Animated.format);
	
	for(var i=0 ; i<array_length(tris) ; i+=mesh.get_child_count()-2) {
		var posIdx = tris[i] * 3;
		var norIdx = tris[i+1] * 3;
		var texIdx = tris[i+2] * 2;
		var position = new Vector3(pos[posIdx], pos[posIdx+1], pos[posIdx+2]);
		var normal = new Vector3(nor[norIdx], nor[norIdx+1], nor[norIdx+2]);
		var textcoord = new Vector2(tex[texIdx], -tex[texIdx+1]);
		
		if (skeleton==NULL) {
			Geometry.Format.Textured.AddVertex(modelBuff, position, textcoord, normal);
		} else {
			// Here what I try is to get the ID of the Joint and the Weight of influence for a given vertex
			// vcount tells how many joints influences the vertex and on v we have the pair of id-weight for every vertex
			// <vcount>3 2 2 3</vcount>
			// <v>
			//		1 0		0 1		1 2
			//		1 3		1 4
			//		1 3		2 4
			//		1 0		3 1		2 2
			// </v>
			
			// By default we only support up to 3 joints per vertex
			var jArr = [0, 0, 0];
			var wArr = [0, 0, 0];
			
			// This is the amount of joints on this vertex
			var count = min(vcount[posIdx/3], 3);
			
			// Now we gotta find the index of our vertex on the <v> list
			for(var j=0, accum=0; j<posIdx/3; j++ )
				accum += vcount[j];
				
			// Once we have the index on accum we read the wanted data
			for(var j=0; j<count; j++) {
				jArr[j] = v[accum*2];
				wArr[j] = weights[ v[accum*2+1] ];
				accum++;
			}
			
			// And we add to the buffer the data of this vertex
			Geometry.Format.Animated.AddVertex(modelBuff, position, textcoord, normal, new Vector3(jArr), new Vector3(wArr));
		}
	}
	
	vertex_end(modelBuff);
	vertex_freeze(modelBuff);
	
	return [new Geometry.Mesh(modelBuff, texture), skeleton];
	
	#endregion
};
		