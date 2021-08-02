//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying float shade;
varying float test;

void main() {
    vec4 baseColor = shade * texture2D(gm_BaseTexture, v_vTexcoord );
    if (test==2.) {
    	baseColor = vec4(1., 0, 0, 1.);
    }
	gl_FragColor = vec4(baseColor.rgb , 1.0);
}
