
if (!instance_exists(obj_character)) exit;

var dist = point_distance_3d(x, y, z, obj_character.x, obj_character.y, obj_character.z);

if (dist < agro1 && dist >= agro2) {
    var pdir = point_direction(obj_character.x, -obj_character.z, x, -z);
    
    dir += angle_difference(pdir, dir) * .1;
    
    xspd = lerp(xspd, clamp(obj_character.x -x, -1, 1)*spd, .1);
    zspd = lerp(zspd, clamp(obj_character.z -z, -1, 1)*spd, .1);
} else {
    if (dist < agro2) {
        if (current_time>cooldown) {
            obj_character.hp -= 10;
            cooldown = current_time + 2000;
            offhit = 1.5;
        }
    }
    
    xspd = lerp(xspd, 0, .1);
    zspd = lerp(zspd, 0, .1);
}

x += xspd;
z += zspd;
offhit = lerp(offhit, 1, .1);
if (hp<=0) instance_destroy();