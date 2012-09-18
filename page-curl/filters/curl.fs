precision mediump float;

varying vec2 v_texCoord;

varying float pointLightIntensity;

uniform vec3 pointLightColor;
uniform vec3 ambientLightColor;

void main()
{
	float frontFacing = gl_FrontFacing ? 1.0 : -1.0;
	float facePointLightIntensity = max(frontFacing * pointLightIntensity, 0.0);
	vec3 color = min(ambientLightColor + facePointLightIntensity * pointLightColor, 1.0);

	css_MixColor = vec4(color, 1.0);
}
