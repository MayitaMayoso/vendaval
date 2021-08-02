
skeleton.Draw();
skeleton.Update();


/*
z = 0;
var grid_size = METER*10;
var grid_separation = METER;
var total_size = grid_separation*grid_size;
var startCoord = -grid_separation*grid_size/2;

axis = vertex_create_buffer();
vertex_begin(axis, Geometry.FormatColor.format);

for (var i=0; i<=grid_size; i++) {
	if (i!=grid_size/2) {
		// X lines
		Geometry.Format.Colored.AddVertex(axis, new Vector4(150, 150, 150, 1), new Vector3(startCoord + grid_separation*i, 0, startCoord));		
		Geometry.Format.Colored.AddVertex(axis, new Vector4(150, 150, 150, 1), new Vector3(startCoord + grid_separation*i, 0, total_size/2));
		
		// Z lines
		Geometry.Format.Colored.AddVertex(axis, new Vector4(150, 150, 150, 1), new Vector3(startCoord, 0, startCoord + grid_separation*i));		
		Geometry.Format.Colored.AddVertex(axis, new Vector4(150, 150, 150, 1), new Vector3(total_size/2, 0, startCoord + grid_separation*i));
	}
}

var size = total_size/2;
Geometry.Format.Colored.AddVertex(axis, new Vector4(255, 0, 0, 1), new Vector3(0, 0, 0));
Geometry.Format.Colored.AddVertex(axis, new Vector4(255, 0, 0, 1), new Vector3(size, 0, 0));
Geometry.Format.Colored.AddVertex(axis, new Vector4(255, 0, 255, 1), new Vector3(0, 0, 0));
Geometry.Format.Colored.AddVertex(axis, new Vector4(255, 0, 255, 1), new Vector3(-size, 0, 0));
Geometry.Format.Colored.AddVertex(axis, new Vector4(0, 255, 0, 1), new Vector3(0, 0, 0));
Geometry.Format.Colored.AddVertex(axis, new Vector4(0, 255, 0, 1), new Vector3(0, size, 0));
Geometry.Format.Colored.AddVertex(axis, new Vector4(210, 250, 0, 1), new Vector3(0, 0, 0));
Geometry.Format.Colored.AddVertex(axis, new Vector4(210, 250, 0, 1), new Vector3(0, -size, 0));
Geometry.Format.Colored.AddVertex(axis, new Vector4(0, 0, 255, 1), new Vector3(0, 0, 0));
Geometry.Format.Colored.AddVertex(axis, new Vector4(0, 0, 255, 1), new Vector3(0, 0, size));
Geometry.Format.Colored.AddVertex(axis, new Vector4(0, 250, 250, 1), new Vector3(0, 0, 0));
Geometry.Format.Colored.AddVertex(axis, new Vector4(0, 250, 250, 1), new Vector3(0, 0, -size));

vertex_end(axis);
vertex_freeze(axis);

model = new Geometry.Model();
model.primitive = pr_linelist;
model.DrawingFunc = function() {
	shader_set(sh_axisgrid);
	shader_set_uniform_f(shader_get_uniform(sh_axisgrid,"maxDistance"), 10);
};
*