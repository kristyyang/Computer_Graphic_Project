#version 300 es

out vec4 out_FragColor;

uniform vec3 lightColor;
uniform vec3 ambientColor;
uniform vec3 lightDirection;

uniform float kAmbient;
uniform float kDiffuse;
uniform float kSpecular;
uniform float shininess;

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


	//DIFUSE
	float diffuse = max (0.0, dot(N, L));


	vec3 light_DFF = lightColor * diffuse*kDiffuse;

	vec3 light_AMB = ambientColor * kAmbient;


	//TOTAL INTENSITY

	//TODO PART 1E: calculate light intensity (ambient+diffuse+speculars' intensity term)
	float lightIntensity = diffuse;

   	vec4 resultingColor = vec4(0.0,0.0,0.0,0.0);

   	//TODO PART 1E: change resultingColor based on lightIntensity (toon shading)
	if (lightIntensity > 0.75)
        resultingColor = vec4(0.0,0.6,0.5,1.0);
    else if (lightIntensity > 0.65)
        resultingColor = vec4(0.0,0.4,0.4,1.0);
    else if (lightIntensity > 0.45)
        resultingColor = vec4(0.0,0.3,0.3,1.0);
    else if (lightIntensity > 0.25)
        resultingColor = vec4(0.0,0.2,0.2,1.0);
	else
        resultingColor = vec4(0.0,0.1,0.1,1.0);

	float silhouette = abs(dot(N, V));
	if (silhouette < 0.15){
		resultingColor = vec4(0.05, 0.05, 0.15, 1.0);
	}




   	//TODO PART 1E: change resultingColor to silhouette objects

	out_FragColor = resultingColor;
}
