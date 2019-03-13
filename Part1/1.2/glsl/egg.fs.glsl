#version 300 es

precision highp float;
precision highp int;
out vec4 out_FragColor;
in float x;
in vec3 interpolatedNormal;

// CHANGE EGG COLOR AS COLORFUL


// HINT: YOU WILL NEED TO PASS IN THE CORRECT VARYING (SHARED) VARIABLE


void main() {

  // HINT: YOU WILL NEED TO SET YOUR OWN DISTANCE THRESHOLD
  vec4 temp;
  vec3 N;
  N = normalize(interpolatedNormal);

    // Mix uses pct (a value from 0-1) to
    // mix the two colors

//  if (x > 5.0) {
//    temp = vec4(N, 1.0);
//  } else {
//    temp = vec4(1.0, 1.0, 1.0, 1.0);
//  }
 temp = vec4(N, 1.0);

  // Set constant color red
   out_FragColor = temp; // REPLACE ME
  //out_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
}
