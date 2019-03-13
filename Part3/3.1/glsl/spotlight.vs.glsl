#version 300 es


uniform vec3 lightColor;
uniform vec3 ambientColor;
uniform vec3 lightDirection;
uniform vec3 spotlightPosition;

uniform float kAmbient;
uniform float kDiffuse;
uniform float kSpecular;
uniform float shininess;


varying vec3 eye_C;
varying vec3 eye_position;
varying vec3 eye_lightDir;
uniform vec3 spotDirectPosition;

void main() {
	// TODO: PART 1D
    eye_C = normalMatrix * normal;
    // eye_lightDir = vec3(viewMatrix * vec4(spotlightPosition,0.0));
    eye_lightDir = spotlightPosition - spotDirectPosition;


    //light is innitially in the world coordinate.
    eye_position = vec3(modelMatrix * vec4(position,1.0));



    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}
