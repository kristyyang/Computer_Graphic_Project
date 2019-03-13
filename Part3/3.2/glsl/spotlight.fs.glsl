#version 300 es

precision highp float;
precision highp int;
out vec4 out_FragColor;

uniform vec3 lightColor;
uniform vec3 ambientColor;
uniform vec3 lightDirection;     //lightDirection
uniform vec3 spotlightPosition; //light position

uniform float kAmbient;
uniform float kDiffuse;
uniform float kSpecular;
uniform float shininess;

varying vec3 eye_C;
varying vec3 eye_position;
varying vec3 eye_lightDir;


void main() {
   vec3 lightvec = normalize(spotlightPosition - eye_position);

	// TODO: PART 1D

   //normal
	vec3 N = normalize(eye_C);
	//LightDir
	vec3 L = normalize(eye_lightDir);
	//View Dir
	vec3 V = normalize(-eye_position);

	//reflect
	vec3 R = normalize((2.0 * dot(N,L)) * N - L);
	//halfway
	vec3 H = normalize(V + L);

   float theta = dot(lightvec, V);
   // float epsilon = light.cutOff - light.outerCutOff;


   float spotExponent = 5.0;

   vec3 SpotColor = vec3(1.0, 1.0, 0.0);

   out_FragColor = vec4(SpotColor , 1.0);
}
