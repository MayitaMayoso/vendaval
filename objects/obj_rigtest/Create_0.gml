
// Model loading and setting up the drawing func of it
model = new Geometry.Model("character.dae", tex_rusty);
model.DrawingFunc = function() {
	shader_set(sh_animated_model)
	shader_set_uniform_f_array(shader_get_uniform(sh_animated_model, "DQ"), model.skeleton.GetUniform())
	matrix_set(matrix_world, matrix_build(0, 0, 0, 90, 0, 0, .5, .5, .5));
};

// Extra attributes
z = 0;
y = .5;

model.skeleton.animation = "Idle";