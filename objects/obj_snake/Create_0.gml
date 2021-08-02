
model = new Geometry.Model("snake.obj");
model.DrawingFunc = function() {
	matrix_set(matrix_world, matrix_build(x, y, z, 0, dir, 0, .25 * offhit, .25 / offhit, .25 * offhit));
};

z = 0;

dir = 0;
spd = .04;
xspd = 0;
zspd = 0;

// Gameplay
agro1 = 5;
cooldown = 0;
offhit = 1;
hp = 50;