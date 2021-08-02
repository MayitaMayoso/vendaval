
if (!instance_exists(obj_character)) exit;

var dist = point_distance_3d(x, y, z, obj_character.x, obj_character.y, obj_character.z);
var pdir = point_direction(obj_character.x, -obj_character.z, x, -z);

if (dist < agro1) {
    dir += angle_difference(pdir, dir) * .1;
    
    xspd = lerp(xspd, clamp(x -obj_character.x, -1, 1)*spd, .1);
    zspd = lerp(zspd, clamp(z -obj_character.z, -1, 1)*spd, .1);
} else {
    if ( abs(angle_difference(pdir, dir+180)) < 5 ) {
        if (current_time>cooldown) {
            var b = instance_create_depth(x, .5, 0, obj_bullet);
            b.z = z;
            cooldown = current_time + 2000;
            offhit = 1.5;
        }
    }
    dir += angle_difference(pdir, dir + 180) * .1;
    xspd = lerp(xspd, 0, .1);
    zspd = lerp(zspd, 0, .1);
}

x += xspd;
z += zspd;
offhit = lerp(offhit, 1, .1);

if (hp<=0) instance_destroy();

