#version 300 es

// The uniform variable is set up in the javascript code and the same for all vertices
uniform vec3 bunnyPosition;



// HINT: YOU WILL NEED AN ADDITIONAL UNIFORM VARIABLE TO MAKE THE BUNNY HOP

// Create shared variable for the vertex and fragment shaders
out vec3 interpolatedNormal;

void main() {
    // Set shared variable to vertex normal
    interpolatedNormal = normal;

    // HINT: USE bunnyPosition HERE

   mat4 bunnyP = modelMatrix;
   bunnyP[3][0] = bunnyPosition.x;
   bunnyP[3][1] = bunnyPosition.y;
   bunnyP[3][2] = bunnyPosition.z;



    // Multiply each vertex by the model matrix to get the world position of each vertex, then the view matrix to get the position in the camera coordinate system, and finally the projection matrix to get final vertex position
    gl_Position = projectionMatrix * viewMatrix * bunnyP * vec4(position, 1.0);

}
