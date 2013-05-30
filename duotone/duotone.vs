precision mediump float;

// Built-in attributes

attribute vec4 a_position;


// Built-in uniforms

uniform mat4 u_projectionMatrix;


// Main

void main()
{
  gl_Position = u_projectionMatrix * a_position;
}
