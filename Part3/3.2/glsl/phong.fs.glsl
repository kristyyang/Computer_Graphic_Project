#version 300 es

out vec4 out_FragColor;

uniform vec3 lightColor;
uniform vec3 ambientColor;
uniform vec3 lightDirection;
uniform float sControlUniform;

uniform float kAmbient;
uniform float kDiffuse;
uniform float kSpecular;
uniform float shininess;

varying vec3 eye_C;
varying vec3 eye_position;
varying vec3 eye_lightDir;

vec3 u_objectColor = vec3(1.0, 1.0, 1.0);
vec3 u_coolColor = vec3(0.0, 0.0, 0.6);
vec3 u_warmColor = vec3(0.6, 0.0, 0.0);
float u_alpha = 0.25;
float u_beta = 0.5;




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

	vec4 resultingColor = vec4(0.0,0.0,0.0,1.0);

	vec3 coolColor = min(u_coolColor + u_objectColor * u_alpha,1.0);
    vec3 warmColor = min(u_warmColor + u_objectColor * u_beta,1.0);
    vec3 colorOut = mix(coolColor,warmColor, diffuse);

    resultingColor = vec4(colorOut,1.0);


	float specular = 0.0;

    if (diffuse > 0.0){
        specular =pow(max(dot(R, H),0.0),shininess) *kSpecular;
    }

	vec3 light_DFF = colorOut;
    vec3 light_SPC = lightColor * specular;

	float spec  = pow(max(dot(R, V), 0.0), shininess);

	vec3 TOTAL;
    if (gl_FrontFacing){
        TOTAL = min(colorOut + spec, 1.0);
    } else{
        TOTAL = vec3(0.0,0.0,0.0);
    }
	// TOTAL = clamp(TOTAL,0.0,1.0);





	//TOTAL


	out_FragColor = vec4(TOTAL,1.0);
	}
