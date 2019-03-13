#version 300 es

out vec4 out_FragColor;

uniform vec3 lightColor;
uniform vec3 ambientColor;
uniform vec3 lightDirection;

uniform float kAmbient;
uniform float kDiffuse;
uniform float kSpecular;
uniform float shininess;

varying vec3 viewVector;
varying vec3 normalVector;

varying vec3 eye_C;
varying vec3 eye_position;
varying vec3 eye_lightDir;



void main() {

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

	float diffuse =  max(0.0, dot(N,L)) * kDiffuse;
	float specular = pow(max(dot(H, N),0.0),shininess) * kSpecular;


	//TODO: PART 1B

	//AMBIENT
	vec3 light_AMB = ambientColor * kAmbient;
	//DIFFUSE
	 vec3 light_DFF = lightColor * diffuse;
	//SPECULAR
	vec3 light_SPC = lightColor * specular;


	vec3 TOTAL = light_AMB  + light_DFF  + light_SPC;

	//TOTAL

	out_FragColor = vec4(TOTAL, 1.0);
	}
