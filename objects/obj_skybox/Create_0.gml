model = new Geometry.Model("skybox.obj", tex_skybox);
model.DrawingFunc = function() {
	shader_set(sh_skybox);
	matrix_set(matrix_world, matrix_build(Camera.view.x, Camera.view.y, Camera.view.z, 0, 0, 0, 100, 100, 100));	
};
