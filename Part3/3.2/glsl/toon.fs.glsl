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

	float THRESHOLD = 0.4;
//	if (lightIntensity.x < THRESHOLD * TOTAL.x && lightIntensity.y < THRESHOLD * TOTAL.y && lightIntensity.z < THRESHOLD * TOTAL.z){
    if (lightIntensity < 0.7 && lightIntensity>=0.6){
          float plane = mod(eye_position.x + eye_position.y,0.03);
          if ( plane <= 0.005 && plane >= 0.0){
               resultingColor = vec4(vec3(0.0),1.0);
          }
	}

	if (lightIntensity < 0.6){
	    float  p1= mod(eye_position.x + eye_position.y,0.05);

	    if ( p1 <= 0.005 && p1 >= 0.0){
	        resultingColor = vec4(vec3(0.0),1.0);
        }
	    float p2 = mod(eye_position.x - eye_position.y,0.05);
        if (p2 <= 0.005 && p2 >=0.0){
            resultingColor = vec4(vec3(0.0),1.0);
        }
	}


	out_FragColor = resultingColor;
}
