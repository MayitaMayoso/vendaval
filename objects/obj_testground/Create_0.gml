
model = new Geometry.Model("testground.obj");
model.DrawingFunc = function() {
	shader_set(sh_general_render);
	matrix_set(matrix_world, matrix_build(0, 0, 0, 0, 0 , 0, 100, 100, 100));
};

