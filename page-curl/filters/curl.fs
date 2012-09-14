precision mediump float;

varying vec2 v_texCoord;

varying float v_lighting;

void main()
{
	css_MixColor = vec4(v_lighting);
	css_MixColor.a = 1.0;
}
