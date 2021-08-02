
model = new Geometry.Model("skybox.obj", tex_rusty);
model.DrawingFunc = function() {
	matrix_set(matrix_world, matrix_build(x, y, z, 0, 0, 0, .05, .05, .05));
};

spd = .2;

xspd = 0;
zspd = 0;

alarm[0] = 120;