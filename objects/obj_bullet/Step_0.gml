
if (xspd == 0) {
    var dir = point_direction(obj_character.x, -obj_character.z, x, -z);
    xspd = dcos(dir+180)*spd;
    zspd = dsin(dir+180)*spd;
}

x += xspd;
z += zspd;

if (point_distance(x, z, obj_character.x, obj_character.z) < .25) {
    instance_destroy();
    obj_character.offhit = 1.5;
    obj_character.hp -= 5;
}