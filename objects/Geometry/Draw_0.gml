//game_end();
for(var i=0; i<array_length(models); i++) models[i].Draw();
matrix_set(matrix_world, matrix_build_identity());
shader_reset();