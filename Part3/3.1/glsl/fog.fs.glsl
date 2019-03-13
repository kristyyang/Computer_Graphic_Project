#version 300 es

out vec4 out_FragColor;

uniform vec3 lightColor;
uniform vec3 ambientColor;
uniform vec3 lightDirection;
uniform vec3 lightFogColor;

uniform float kAmbient;
uniform float kDiffuse;
uniform float kSpecular;
uniform float shininess;


varying vec3 eye_C;
varying vec3 eye_position;
varying vec3 eye_lightDir;


//Creating final color for fog


void main() {
	float fogDensity = 0.02;
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


    float specular = pow(max(dot(V, R),0.0),shininess) * kSpecular;


	//AMBIENT
	vec3 light_AMB = ambientColor * kAmbient;
	//DIFFUSE
	vec3 light_DFF = lightColor * diffuse;
	//SPECULAR
	vec3 light_SPC = lightColor * specular;


	vec3 TOTAL = light_DFF;
	//DIFFUSE

	float d = distance(cameraPosition,eye_position);

	float FOG_LEVEL;
	FOG_LEVEL = 1.0 /exp(d * fogDensity);

	float fog_level;
	fog_level = clamp(FOG_LEVEL, 0.0, 1.0 );

	vec3 finalColor;
	finalColor = mix(lightFogColor,TOTAL,fog_level);


	// TODO: PART 1C

	out_FragColor = vec4(finalColor,1.0);
}
