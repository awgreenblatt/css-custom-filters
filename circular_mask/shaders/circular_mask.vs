precision mediump float;

uniform mat4 u_projectionMatrix;

// Built-in attributes

attribute vec4 a_position;
attribute vec2 a_texCoord;

// Varyings
varying vec2 v_uv;

void main()
{    
  	v_uv = a_texCoord;
	gl_Position = u_projectionMatrix * a_position;
}

