
model = new Geometry.Model("world.obj");
model.DrawingFunc = function() {
	shader_set(sh_general_render);
	matrix_set(matrix_world, matrix_build(0, 0, 0, 0, 0, 0, -1, 1, 1));
};

Print(model);