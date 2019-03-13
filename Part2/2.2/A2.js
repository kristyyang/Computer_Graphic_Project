/*
 * UBC CPSC 314, Vjan2019
 * Assignment 2
 */
 // Modes.. one per part of question 1
 var Part = {
   PROTECT: 0,
   LASERS: 1,
   SHAKE: 2
 }
 var mode = Part.PROTECT // current mode
// CHECK WEBGL VERSION
if ( WEBGL.isWebGL2Available() === false ) {
  document.body.appendChild( WEBGL.getWebGL2ErrorMessage() );
}

// SETUP RENDERER & SCENE
var container = document.createElement( 'div' );
document.body.appendChild( container );

var canvas = document.createElement("canvas");
var context = canvas.getContext( 'webgl2' );
var renderer = new THREE.WebGLRenderer( { canvas: canvas, context: context } );
renderer.setClearColor(0X000000); // black background colour
container.appendChild( renderer.domElement );

// Setting up all shared objects
var scenes = [];
var cameras = [];
var controls = [];
var worldFrames = [];
var floorTextures = [];
var floorMaterials = [];
var floorGeometries = [];
var floors = [];

for (let i = 0; i < 3; ++i) {
  scenes[i] = new THREE.Scene();
  // view angle, aspect ratio, near, far
  cameras[i] = new THREE.PerspectiveCamera(30,1,0.1,1000);
  cameras[i].position.set(-5, 5, -15);
  cameras[i].lookAt(scenes[i].position);
  scenes[i].add(cameras[i]);

  controls[i] = new THREE.OrbitControls(cameras[i]);
  controls[i].damping = 0.2;
  controls[i].autoRotate = false;

  worldFrames[i] = new THREE.AxesHelper(1);
  scenes[i].add(worldFrames[i]);

  // FLOOR WITH PATTERN
  floorTextures[i] = (new THREE.TextureLoader().load('images/floor.jpg'));
  floorTextures[i].wrapS = floorTextures[i].wrapT = THREE.RepeatWrapping;
  floorTextures[i].repeat.set(1, 1);
  floorMaterials[i] = new THREE.MeshBasicMaterial({ map: floorTextures[i], side: THREE.DoubleSide });
  floorGeometries[i] =new THREE.PlaneBufferGeometry(15, 15);
  floors[i] = new THREE.Mesh(floorGeometries[i], floorMaterials[i]);
  floors[i].rotation.x = Math.PI / 2;
  floors[i].parent = worldFrames[i];
  scenes[i].add(floors[i]);
}


// ADAPT TO WINDOW RESIZE
function resize() {
  renderer.setSize(window.innerWidth,window.innerHeight);
  for (let i = 0; i < 3; ++i) {
    cameras[i].aspect = window.innerWidth/window.innerHeight;
    cameras[i].updateProjectionMatrix();
  }
}

// EVENT LISTENER RESIZE
window.addEventListener('resize',resize);
resize();

//SCROLLBAR FUNCTION DISABLE
window.onscroll = function () {
     window.scrollTo(0,0);
   }
   var ctx = renderer.context;
   ctx.getShaderInfoLog = function () { return '' };   // stops shader warnings, seen in some browsers

   // LOAD OBJECT
   function loadOBJ(mode, file, material, scale, xOff, yOff, zOff, xRot, yRot, zRot) {
     var manager = new THREE.LoadingManager();
             manager.onProgress = function (item, loaded, total) {
       console.log( item, loaded, total );
     };

     var onProgress = function (xhr) {
       if ( xhr.lengthComputable ) {
         var percentComplete = xhr.loaded / xhr.total * 100;
         console.log( Math.round(percentComplete, 2) + '% downloaded' );
       }
     };

     var onError = function (xhr) {
     };

     var loader = new THREE.OBJLoader( manager );
     loader.load(file, function(object) {
       object.traverse(function(child) {
         if (child instanceof THREE.Mesh) {
           child.material = material;
         }
       });

       object.position.set(xOff,yOff,zOff);
       object.rotation.x= xRot;
       object.rotation.y = yRot;
       object.rotation.z = zRot;
       object.scale.set(scale,scale,scale);
       object.parent = worldFrames[mode];
       scenes[mode].add(object);

     }, onProgress, onError);
   }

/////////////////////////////////
//   YOUR WORK STARTS BELOW    //
/////////////////////////////////

// MATERIALS: specifying uniforms and shaders

var rot_angle = { type: 'f', value: 0.0 }
var armadilloPosition = { type: 'v3', value: new THREE.Vector3(0.0,1.0,0.0)};
var bunnyPosition = {  type: 'v3',  value: new THREE.Vector3(0.0,-0.3,-3)};
var lightPosition = {  type: 'v3',  value: new THREE.Vector3(0, 0, 0)};
var eggPosition = {  type: 'v3',  value: new THREE.Vector3(0.0, 0.3, -5.0)};

// Used for both (A) & (B)
var armadilloMaterial = new THREE.ShaderMaterial({
  uniforms: {
    armadilloPosition: armadilloPosition,
    lightPosition: lightPosition
  }
});

var bunnyMaterial = new THREE.ShaderMaterial({
  uniforms: {
    bunnyPosition: bunnyPosition,
    lightPosition: lightPosition,
    armadilloPosition: armadilloPosition,
  }
});

var eggMaterial = new THREE.ShaderMaterial({
  uniforms: {
    eggPosition: eggPosition,
    lightPosition: lightPosition,
  }
});

// CREATE LASER MATERIAL
var llaserMaterial = new THREE.ShaderMaterial({
  uniforms:{
    offset: {type: 'v3', value: new THREE.Vector3(-0.15, 2.42, -0.64)},
    eggPosition: eggPosition,
    armadilloPosition: armadilloPosition,
  }
});

var rlaserMaterial = new THREE.ShaderMaterial({
  uniforms:{
    offset: {type: 'v3', value: new THREE.Vector3(0.15, 2.42, -0.64)},
    eggPosition: eggPosition,
    armadilloPosition: armadilloPosition,
  }
});
// used only for (B)
var leftEyeMaterial = new THREE.ShaderMaterial({
	uniforms: {
    offset: {type: 'v3', value: new THREE.Vector3(-0.15, 2.42, -0.64)},
    armadilloPosition: armadilloPosition,
    eggPosition: eggPosition,
	}
})
var rightEyeMaterial = new THREE.ShaderMaterial({
	uniforms: {
    offset: {type: 'v3', value: new THREE.Vector3(0.15, 2.42, -0.64)},
    armadilloPosition: armadilloPosition,
    eggPosition: eggPosition,
	}
})

// used only in (C)
var shakeBunnyMaterial = new THREE.ShaderMaterial({
  uniforms:{
    bunnyPosition: bunnyPosition,
    rot_angle: rot_angle
  }
});

// LOAD SHADERS
var shaderFiles = [
  'glsl/armadillo.vs.glsl',
  'glsl/armadillo.fs.glsl',
  'glsl/bunny.vs.glsl',
  'glsl/bunny.fs.glsl',
  'glsl/egg.vs.glsl',
  'glsl/egg.fs.glsl',
  'glsl/eye.vs.glsl',
  'glsl/eye.fs.glsl',
  'glsl/shake_bunny.vs.glsl',
  'glsl/shake_bunny.fs.glsl',
  'glsl/laser.vs.glsl',
  'glsl/laser.fs.glsl'
];

new THREE.SourceLoader().load(shaderFiles, function(shaders) {
  armadilloMaterial.vertexShader = shaders['glsl/armadillo.vs.glsl'];
  armadilloMaterial.fragmentShader = shaders['glsl/armadillo.fs.glsl'];

  bunnyMaterial.vertexShader = shaders['glsl/bunny.vs.glsl'];
  bunnyMaterial.fragmentShader = shaders['glsl/bunny.fs.glsl'];

  eggMaterial.vertexShader = shaders['glsl/egg.vs.glsl'];
  eggMaterial.fragmentShader = shaders['glsl/egg.fs.glsl'];

  leftEyeMaterial.vertexShader = shaders['glsl/eye.vs.glsl']
  leftEyeMaterial.fragmentShader = shaders['glsl/eye.fs.glsl']

  rightEyeMaterial.vertexShader = shaders['glsl/eye.vs.glsl']
  rightEyeMaterial.fragmentShader = shaders['glsl/eye.fs.glsl']

  shakeBunnyMaterial.vertexShader = shaders['glsl/shake_bunny.vs.glsl']
  shakeBunnyMaterial.fragmentShader = shaders['glsl/shake_bunny.fs.glsl']

  llaserMaterial.vertexShader = shaders['glsl/laser.vs.glsl'];
  llaserMaterial.fragmentShader = shaders ['glsl/laser.fs.glsl'];

  rlaserMaterial.vertexShader = shaders['glsl/laser.vs.glsl'];
  rlaserMaterial.fragmentShader = shaders ['glsl/laser.fs.glsl'];

})

//---------------------------
// (A) -- PROTECT SCENE OBJECTS
// WORK HERE FOR PART 1.A
//---------------------------
loadOBJ(Part.PROTECT, 'obj/armadillo.obj', armadilloMaterial, 1, 0, 0, 0, 0, 0, 0); // Armadillo
loadOBJ(Part.PROTECT,'obj/bunny.obj', bunnyMaterial, 1, 0, 0 , 0, 0 ,0 ,0);

protect = {}
// Lightbulb
protect.lightbulbMaterial = new THREE.MeshBasicMaterial()
protect.lightbulbMaterial.color = new THREE.Color(1, 1, 0)
protect.lightbulbGeometry = new THREE.SphereGeometry(1, 32, 32)

protect.lightbulb = new THREE.Mesh(protect.lightbulbGeometry, protect.lightbulbMaterial)
protect.lightbulb.scale.set(0.15, 0.15, 0.15)
protect.lightbulb.position.set(0, 5.0, 2.0)
scenes[Part.PROTECT].add(protect.lightbulb)

// CREATE EGG
protect.eggGeometry = new THREE.SphereGeometry(1, 32, 32);
protect.egg = new THREE.Mesh(protect.eggGeometry, eggMaterial);
protect.egg.scale.set(0.2, 0.3, 0.2);
protect.egg.position.set(eggPosition.value.x, eggPosition.value.y, eggPosition.value.z);
scenes[Part.PROTECT].add(protect.egg);

//----------------------------
// (B) -- LASERS SCENE OBJECTS
// WORK HERE FOR PART 1.B
//---------------------------
loadOBJ(Part.LASERS, 'obj/armadillo.obj', armadilloMaterial, 1, 0, 0, 0, 0, 0, 0); // Armadillo
loadOBJ(Part.LASERS,'obj/bunny.obj', bunnyMaterial, 1, 0, 0 , 0, 0 ,0 ,0);

laser = {}
// Lightbulb
laser.lightbulbMaterial = new THREE.MeshBasicMaterial();
laser.lightbulbMaterial.color = new THREE.Color(1, 1, 0);
laser.lightbulbGeometry = new THREE.SphereGeometry(1, 32, 32);

laser.lightbulb = new THREE.Mesh(laser.lightbulbGeometry, laser.lightbulbMaterial);
laser.lightbulb.scale.set(0.15, 0.15, 0.15);
laser.lightbulb.position.set(0, 5.0, 2.0);
scenes[Part.LASERS].add(laser.lightbulb);

// CREATE EGG
laser.eggGeometry = new THREE.SphereGeometry(1, 32, 32);
laser.egg = new THREE.Mesh(laser.eggGeometry, eggMaterial);
laser.egg.scale.set(0.2, 0.3, 0.2);
laser.egg.position.set(eggPosition.value.x, eggPosition.value.y, eggPosition.value.z);
scenes[Part.LASERS].add(laser.egg);
// EYES
loadOBJ(Part.LASERS,'obj/eye.obj', leftEyeMaterial, 1.0, 0.0, 0.0, 0.0, 0, 0, 0);
loadOBJ(Part.LASERS,'obj/eye.obj', rightEyeMaterial, 1.0, 0.0, 0.0, 0.0, 0, 0, 0);

//Laser geometry CREATE LASER
laser.laserGeometry = new THREE.CylinderGeometry(0.02, 0.02, 1, 16);

for (let i = 0; i < laser.laserGeometry.vertices.length; ++i)
  laser.laserGeometry.vertices[i].y += 0.5

laser.llaser = new THREE.Mesh(laser.laserGeometry,llaserMaterial);
laser.llaser.scale.set(1.0,1.0,1.0);
laser.llaser.position.set(0.0,0.0,0.0);
scenes[Part.LASERS].add(laser.llaser);

laser.rlaser = new THREE.Mesh(laser.laserGeometry,rlaserMaterial);
laser.rlaser.scale.set(1.0,1.0,1.0);
laser.rlaser.position.set(0.0,0.0,0.0);
scenes[Part.LASERS].add(laser.rlaser);
//---------------------------
// (C) - SHAKE SCENE OBJECTS
// WORK HERE FOR PART 1.C
//---------------------------
loadOBJ(Part.SHAKE, 'obj/bunny.obj', shakeBunnyMaterial, 1, 0, 0, 0, 0, 0, 0); // Bunny

// LISTEN TO KEYBOARD
var keyboard = new THREEx.KeyboardState();
function checkKeyboard() {
  if (keyboard.pressed("1"))
    mode = Part.PROTECT;
  else if (keyboard.pressed("2"))
    mode = Part.LASERS;
  else if (keyboard.pressed("3"))
    mode = Part.SHAKE;

  if (mode == Part.PROTECT) {
    if (keyboard.pressed("A")){
      armadilloPosition.value.x -= 0.1;
      bunnyPosition.value.x -= 0.1;
    }
    else if (keyboard.pressed("D")){
      armadilloPosition.value.x += 0.1;
      bunnyPosition.value.x += 0.1;
    }else if (keyboard.pressed("J"))
      eggPosition.value.x += 0.1;
    else if (keyboard.pressed("L"))
      eggPosition.value.x -= 0.1;
    else if (keyboard.pressed("I"))
      eggPosition.value.z += 0.1;
    else if (keyboard.pressed("K"))
      eggPosition.value.z -= 0.1;
    lightPosition.value = protect.lightbulb.position
  }
  else if (mode == Part.LASERS) {
    if (keyboard.pressed("A")){
      armadilloPosition.value.x -= 0.1;
      bunnyPosition.value.x -= 0.1;
    }
    else if (keyboard.pressed("D")){
      armadilloPosition.value.x += 0.1;
      bunnyPosition.value.x += 0.1;
    }else if (keyboard.pressed("J"))
      eggPosition.value.x += 0.1;
    else if (keyboard.pressed("L"))
      eggPosition.value.x -= 0.1;
    else if (keyboard.pressed("I"))
      eggPosition.value.z += 0.1;
    else if (keyboard.pressed("K"))
      eggPosition.value.z -= 0.1;
    lightPosition.value = laser.lightbulb.position
  }
  else if (mode == Part.SHAKE) {

    if (keyboard.pressed("Z"))
      rot_angle.value += 0.01;// Used for deformation of the ears

  }


  shakeBunnyMaterial.needsUpdate = true;
  leftEyeMaterial.needsUpdate = true;
  rightEyeMaterial.needsUpdate = true;
  eggMaterial.needsUpdate = true;
  bunnyMaterial.needsUpdate = true;
  armadilloMaterial.needsUpdate = true;
  llaserMaterial.needsUpdate = true;
  rlaserMaterial.needsUpdate = true; // Tells three.js that some uniforms might have changed
}

// SETUP UPDATE CALL-BACK
function update() {
  checkKeyboard();
  requestAnimationFrame(update);
  renderer.render(scenes[mode], cameras[mode]);
}

update();
