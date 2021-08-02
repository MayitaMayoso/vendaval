//
// Simple passthrough fragment shader
//

varying vec4 v_vColour;
varying vec3 v_vPosition;

uniform float maxDistance;

void main() {
	gl_FragColor = vec4(v_vColour.rgb, v_vColour.a * (maxDistance-length(v_vPosition)) / maxDistance);
}
