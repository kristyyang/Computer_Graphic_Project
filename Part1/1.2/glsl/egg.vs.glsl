#version 300 es

// HINT: YOU WILL NEED TO PASS IN THE CORRECT UNIFORM AND CREATE THE CORRECT SHARED VARIABLE
uniform vec3 bunnyPosition;
out float x;
out vec3 interpolatedNormal;


void main() {
  interpolatedNormal = normal;
  vec4 eggPosition = modelMatrix * vec4(position, 1.0);

  mat4 eggP = modelMatrix;
   eggP[3][0] = bunnyPosition.z;
   eggP[3][2] = bunnyPosition.x;

  	// HINT: BE MINDFUL OF WHICH COORDINATE SYSTEM THE BUNNY'S POSITION IS IN

    // Multiply each vertex by the model matrix to get the world position of each vertex, then the view matrix to get the position in the camera coordinate system, and finally the projection matrix to get final vertex position


    gl_Position = projectionMatrix * viewMatrix * eggP * vec4(position, 1.0);
    x = distance(vec4(bunnyPosition,1.0), eggPosition);

}
