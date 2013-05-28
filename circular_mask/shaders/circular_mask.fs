precision mediump float;

uniform float radius;
uniform vec2 center;
uniform float opacity;
uniform float feather;

// Varyings
varying vec2 v_uv;

// Main

void main()
{
	float transparency = opacity;
	float featherStep = smoothstep(radius, radius+feather, length(v_uv - center));
	transparency = opacity + (1.0 - opacity) * featherStep;
	css_ColorMatrix = mat4( 1.0, 0.0, 0.0, 0.0,
                        0.0, 1.0, 0.0, 0.0,
                        0.0, 0.0, 1.0, 0.0,
                        0.0, 0.0, 0.0, transparency);
    
}
