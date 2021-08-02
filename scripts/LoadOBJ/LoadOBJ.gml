function LoadOBJ(filename) {
	var position = ds_list_create();
	var normal = ds_list_create();
	var textcoord = ds_list_create();

	var file = file_text_open_read(filename);
	
	var modelBuff = array_create(0);
	var textures = array_create(0);
	var names = array_create(0);

	while(!file_text_eof(file) ) {
		var line = file_text_read_string(file);
		file_text_readln(file);
		var terms = Split(line, " ");
		if (!array_length(terms)) continue;
		switch(terms[0]) {
			case "mtllib":  // Materials library
				break;
				
			case "o":       // Objects
				if (array_length(modelBuff)>0) {
					vertex_end(modelBuff[array_length(modelBuff)-1]);
					vertex_freeze(modelBuff[array_length(modelBuff)-1]);
				}
				array_push(modelBuff, vertex_create_buffer());
				array_push(names, Split(terms[1], "_")[0]);
				vertex_begin(modelBuff[array_length(modelBuff)-1], Geometry.Format.Textured.format);
				break;
				
			case "usemtl":  // Apply texture
				var tex = asset_get_index("tex_" + string_lower(terms[1]));
				array_push(textures, tex);
				break;
				
			case "v":       // Positions
				ds_list_add(position, new Vector3(real(terms[1]), real(terms[2]), real(terms[3])));
				break;
				
			case "vt":      // Texture
				ds_list_add(textcoord, new Vector2(real(terms[1]), 1-real(terms[2])));
				break;
				
			case "vn":      // Normals
				ds_list_add(normal, new Vector3(real(terms[1]), real(terms[2]), real(terms[3])));
				break;
				
			case "f":       // Triangles
				for ( var i=1 ; i<=3 ; i++ ) {
					var index = Split(terms[i], "/");
					var tmpPos = position[|index[0]-1];
					var tmpTex = textcoord[|index[1]-1];
					var tmpNor = normal[|index[2]-1];
					Geometry.Format.Textured.AddVertex(modelBuff[array_length(modelBuff)-1], tmpPos, tmpTex, tmpNor);
				}			
				break;
		}
	}

	file_text_close(file);
	vertex_end(modelBuff[array_length(modelBuff)-1]);
	vertex_freeze(modelBuff[array_length(modelBuff)-1]);

	ds_list_destroy(textcoord);
	ds_list_destroy(normal);
	ds_list_destroy(position);

	var meshes = array_create(0);
	
	for(var i=0; i<array_length(modelBuff); i++) {
		array_push(meshes, new Mesh(modelBuff[i], textures[i], names[i]))
	}
	
	return meshes;
}