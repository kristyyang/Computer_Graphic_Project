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
    vec3 random_pr = normalize(position - o_right_ear);
    vec3 random_pl = normalize(position - o_left_ear);
    float ltheta = acos(dot(normalize(normal_left_ear), random_pl));
    float rtheta = acos(dot(normalize(normal_right_ear), random_pr));

    mat4 A_1 = mat4(1.0);
    mat4 B = mat4(1.0);
    mat4 R = mat4(1.0);
    mat4 Right = mat4(1.0);

    mat4 A_2 = mat4(1.0);
    mat4 C = mat4(1.0);
    mat4 Left = mat4(1.0);


    R[0][0] =  cos(rot_angle);
    R[2][0] = sin(rot_angle);
    R[0][2] = -sin(rot_angle);
    R[2][2] = cos(rot_angle);

    if(ltheta < (3.1415926 / 4.0)){
        segment = 1.0;

        A_1[3].xyz = o_right_ear.xyz;
        B = inverse(A_1);
        Right = A_1 * R * B;

    }else if (rtheta < (3.1415926 / 4.0)){
        segment = 1.0;
         A_2[3].xyz = o_left_ear.xyz;
        C = inverse(A_2);
        Left = A_2 * R * C;
    }else{
        segment = 0.0;
    }


    // If the current vertex is in Ear frame, modify this, if not, keep this.
    vec3 pos = position;

    gl_Position = projectionMatrix * viewMatrix * T * S *  Right * Left * vec4(pos, 1.0);
}
