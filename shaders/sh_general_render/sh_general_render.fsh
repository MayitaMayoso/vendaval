//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying float shade;

void main()
{
    vec4 baseColor = texture2D( gm_BaseTexture, v_vTexcoord );
	gl_FragColor = vec4(baseColor.rgb * shade , 1.0);
}
