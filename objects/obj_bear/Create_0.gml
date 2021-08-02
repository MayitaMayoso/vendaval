
model = new Geometry.Model("bear.obj");
model.DrawingFunc = function() {
	matrix_set(matrix_world, matrix_build(x, y, z, 0, dir-90, 0, 1 * offhit, 1 / offhit, 1 * offhit));
};

z = 0;

dir = 0;
spd = .04;
xspd = 0;
zspd = 0;

// Gameplay
agro1 = 10;
agro2 = 2;
cooldown = 0;
offhit = 1;

hp = 30;
