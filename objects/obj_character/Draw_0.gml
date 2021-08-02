
shader_set(sh_general_render);
shader_set_uniform_f(shader_get_uniform(sh_general_render, "lightPos"), 10, 10, 10);
shader_set_uniform_f(shader_get_uniform(sh_general_render, "minDarkness"), 0.3);
matrix_stack_push(matrix_build(x, y, z, 0, (Camera.mode=="Character")?Camera.look_dir-90:0, 0, 1, 1, 1));
skeleton.Draw();
shader_reset();
matrix_stack_pop();
matrix_set(matrix_world, matrix_build_identity());
