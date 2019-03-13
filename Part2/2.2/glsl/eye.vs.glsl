out vec3 color;
uniform vec3 offset;
uniform vec3 armadilloPosition;
uniform vec3 eggPosition;

#define MAX_EYE_DEPTH 0.05

void main() {
  // simple way to color the pupil where there is a concavity in the sphere
  float d = min(1.0 - length(position), MAX_EYE_DEPTH);
  color = mix(vec3(1.0), vec3(0.0), d * 1.0 / MAX_EYE_DEPTH);

  mat4 S = mat4(0.1);
  S[3][3] = 0.7;

  /* YOUR CODES HERE: move and rotate eyes corresponding to the movement of armadillo */
  // Creating rotation mat
  mat4 R = mat4(1.0);
  float m = -3.1415926 / 2.0;
  R[1][1] = cos(m);
  R[2][1] = -sin(m);
  R[1][2] = sin(m);
  R[2][2] = cos(m);

  // Roate with the egg
  vec3 eye_position;
  eye_position = vec3(armadilloPosition.x+ offset.x, offset.y, offset.z);
  vec3 forward = normalize(eye_position - eggPosition);
  vec3 D = vec3(0.0,1.0,0.0);

  //Compute the left vector
  vec3 left = normalize(cross(D, forward));

  //Compute the up vector
  vec3 Up = normalize(cross(forward, left));

  // Set roration, inverse rotation matrix
  mat4 M_r= mat4(1.0);
  M_r[0].xyz = left;
  M_r[1].xyz = Up;
  M_r[2].xyz = forward;

  // Set translation part
  M_r[3].xyz = eye_position;



  vec3 dif_vec;
  dif_vec = eye_position.xyz - eggPosition.xyz;

  mat4 T = mat4(1.0);
  T[3][0] = armadilloPosition.x + offset.x;
  T[3][1] = offset.y;
  T[3][2] = armadilloPosition.z + offset.z;

  // Multiply each vertex by the model-view matrix and the projection matrix to get final vertex position
  gl_Position = projectionMatrix * viewMatrix * M_r * R *  S * vec4(position, 1.0);
}
