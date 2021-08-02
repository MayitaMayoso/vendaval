delta = 0;			// Delta is the relation between the real fps and the desired ones
rawDelta = 0;		// RawDelta is the same as delta but without multiplying by speed
speed = 1;			// Speed is a factor we will use to speed up or down the time in order to make slow mo
fpsOnDesign = 60;	// FpsOnDesign is the intended speed of the game when designing the game
accumulatedDelta = 0;
image_alpha = 0;
game_set_speed(60, gamespeed_fps);

trackedInstances = ds_list_create();

TrackFixedUpdate = function(inst, event) {
	if ( ds_list_find_index(trackedInstances, inst) == -1 ) {
		inst.FixedStep[0] = method(inst, event);
		ds_list_add(trackedInstances, inst);
	} else {
		inst.FixedStep[array_length(inst.FixedStep)] = method(inst, event);
	}
};

skip = false;