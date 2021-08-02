attribute vec3 in_Position;                  // (x,y,z)
attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 lightDir;
varying float shade;

uniform vec3 lightPos;
uniform float minDarkness;


void main()
{
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
	
	vec3 worldNormal = normalize((gm_Matrices[MATRIX_WORLD] * vec4(in_Normal, 0.)).xyz);
    
	lightDir = normalize(lightPos - in_Position);
	shade = minDarkness + (1.0-minDarkness)*(dot(worldNormal, lightDir) / 2.0 + 0.5);
	
    v_vTexcoord = in_TextureCoord;
}
