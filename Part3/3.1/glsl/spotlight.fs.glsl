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
uniform vec3 spotDirectPosition;

const int light_angle = 15;


void main() {
	float spotExponent = 10.0;

   vec3 SpotColor = vec3(1.0, 1.0, 0.0);

	// TODO: PART 1D

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


	float U_Cutoff = 35.0; //Angle

	float radianCutoff=U_Cutoff*3.14/180.0;
	float cosThta = cos(radianCutoff);
	vec3 lighting = spotlightPosition - eye_position;

	vec3 spotLightDirection = normalize(lighting);




	float currentCosThta=max(0.0,dot(L,spotLightDirection));
	vec3 TOTAL;

	float diffuseIntensity = 0.0;
	if(currentCosThta > cosThta){
		diffuseIntensity = pow(currentCosThta,spotExponent);
		vec3 diffuseColor = SpotColor * diffuseIntensity;
		TOTAL =     diffuseColor;

    }else{
		vec3 color = vec3(0.0,0.0,0.0);
		TOTAL = color;
	}


   out_FragColor = vec4(TOTAL,1.0);
	 }
