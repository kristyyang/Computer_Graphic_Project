#version 300 es

// Shared variable passed to the fragment shader
out float segment;
out vec3 interpolatedNormal;

uniform float rot_angle;
uniform vec3 bunnyPosition;

void main() {
    // Colorize bunny use the normal
    interpolatedNormal = normal;

    // Provided information, do not need to change
    vec3 o_left_ear = vec3(-0.055, 0.155, 0.0126); // origin for the left ear frame
    vec3 t_left_ear = vec3(-0.0111, 0.182, -0.028); // the top point on the left ear
    vec3 o_right_ear = vec3(-0.077, 0.1537, -0.0023); // origin for the right ear frame
    vec3 t_right_ear = vec3(-0.0678, 0.18, -0.058); // the top point on the right ear
    vec3 normal_left_ear = t_left_ear-o_left_ear; // approximated normal from the origin of the left ear frame
    vec3 normal_right_ear = t_right_ear-o_right_ear; // approximated normal from the origin of the right ear frame



    // Scale matrix
    mat4 S = mat4(10.0);
    S[3][3] = 1.0;

    // Translation matrix
    mat4 T = mat4(1.0);
    T[3].xyz = bunnyPosition;

    /* Your codes start here */

    segment = 1.0;


    // If the current vertex is in Ear frame, modify this, if not, keep this.
    vec3 pos = position;

    gl_Position = projectionMatrix * viewMatrix * T * S * vec4(pos, 1.0);
}
