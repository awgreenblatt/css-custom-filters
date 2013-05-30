precision mediump float;

uniform vec3 black;
uniform vec3 white;

// Main

void main()
{
  vec3 b = black / 255.0;
  vec3 w = white / 255.0;
  //b = black;
  //w = white;
  
  css_ColorMatrix = mat4(w.r-b.r, 0.0, 0.0, 0.0,
							0.0, w.g - b.g, 0.0, 0.0,
							0.0, 0.0, w.b - b.b, 0.0,
							b.r, b.g, b.b, 1.0);
}

