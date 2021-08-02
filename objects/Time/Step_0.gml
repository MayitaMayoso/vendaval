
accumulatedDelta += frac(delta);
var wholeDelta = floor(delta) + floor(accumulatedDelta);
accumulatedDelta = frac(accumulatedDelta);
repeat(wholeDelta) {
	for( var i=0 ; i<ds_list_size(trackedInstances) ; i++ ) {
		var inst = trackedInstances[|i];
		if ( !instance_exists(inst) ) {
			ds_list_delete(trackedInstances, i);
			i--;
			continue;
		}
		for( var j=0 ; j<array_length(inst.FixedStep) ; j++ ) {
			inst.FixedStep[j]();
		}
	}
}