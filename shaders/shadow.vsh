#version 120

#define SHADOW_MAP_BIAS 0.8
#define EXTENDED_SHADOW_DISTANCE true

uniform mat4 shadowProjection;
uniform mat4 shadowProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;

varying vec3	color;
varying vec2	texcoord;

vec4 BiasShadowProjection(in vec4 position) {
	float dist = length(position.xy);
	
	if (EXTENDED_SHADOW_DISTANCE) {
		vec2 pos = abs(position.xy * 1.165);
		dist = pow(pow(pos.x, 8) + pow(pos.y, 8), 1.0 / 8.0);
	}
	
	float distortFactor = dist * SHADOW_MAP_BIAS + (1.0 - SHADOW_MAP_BIAS);
	
	position.xy /= distortFactor;
	
	position.z += 0.01 * (dist + 0.1);
	
	if (EXTENDED_SHADOW_DISTANCE) position.z /= 4.0;
	
	return position;
}

void main() {
	color			= gl_Color.rgb;
	texcoord		= gl_MultiTexCoord0.st;
	
	gl_Position		= BiasShadowProjection(ftransform());
}