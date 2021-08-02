attribute vec3 in_Position;                  // (x,y,z)
attribute vec2 in_TextureCoord;
attribute vec3 in_Normal;
attribute vec3 in_BlendIndices;
attribute vec3 in_BlendWeight;

varying vec2 v_vTexcoord;
varying float shade;
varying float test;

const int maxJoints = 32;
uniform vec4 DQ[maxJoints*2];
uniform vec3 lightPos;
uniform float minDarkness;

vec4 blendReal, blendDual;
vec3 blendTranslation;

void anim_init(ivec3 bone, vec3 weight) {
	blendReal  =  DQ[bone[0]]   * weight[0] + DQ[bone[1]]   * weight[1];// + DQ[bone[2]]   * weight[2];
	blendDual  =  DQ[bone[0]+1] * weight[0] + DQ[bone[1]+1] * weight[1];// + DQ[bone[2]+1] * weight[2];
	
	blendTranslation = 2. * (blendReal.w * blendDual.xyz - blendDual.w * blendReal.xyz + cross(blendReal.xyz, blendDual.xyz));
}

vec3 anim_rotate(vec3 v) {
	return v + 2. * cross(blendReal.xyz, cross(blendReal.xyz, v) + blendReal.w * v);
}

vec3 anim_transform(vec3 v) {
	return anim_rotate(v) + blendTranslation;
}

void main() {
    /*///////////////////////////////////////////////////////////////////////////////////////////
	Initialize the animation system, and transform the vertex position
	/*///////////////////////////////////////////////////////////////////////////////////////////
	anim_init(ivec3(in_BlendIndices*2.), in_BlendWeight);
	vec4 objectSpacePos = vec4(in_Position, 1.0);
	/////////////////////////////////////////////////////////////////////////////////////////////
	
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * objectSpacePos;
	vec3 worldNormal = normalize((gm_Matrices[MATRIX_WORLD] * vec4(in_Normal, 0.)).xyz);
    
	vec3 lightDir = normalize(lightPos - in_Position);
	shade = minDarkness + (1.0-minDarkness)*(dot(worldNormal, lightDir) / 2.0 + 0.5);
    v_vTexcoord = in_TextureCoord;
    test = in_BlendIndices.x;
}