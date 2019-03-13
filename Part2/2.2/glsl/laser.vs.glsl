out vec3 color;
uniform vec3 offset;
uniform vec3 armadilloPosition;
uniform vec3 eggPosition;

#define MAX_EYE_DEPTH 0.05

void main() {
  // simple way to color the pupil where there is a concavity in the sphere
  float d = min(1.0 - length(position), MAX_EYE_DEPTH);
  color = vec3(1.0,0.0,0.0);


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
  eye_position = vec3(armadilloPosition.x+ offset.x, offset.y, armadilloPosition.z+ offset.z);
  float len = length(eye_position - eggPosition);
  vec3 forward = normalize(eye_position - eggPosition);
  vec3 D = vec3(0.0,1.0,0.0);

  mat4 S = mat4(1.0);
  S[1][1] = len;



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



  // Multiply each vertex by the model-view matrix and the projection matrix to get final vertex position
  gl_Position = projectionMatrix * viewMatrix * M_r * R *  S * vec4(position, 1.0);
}
