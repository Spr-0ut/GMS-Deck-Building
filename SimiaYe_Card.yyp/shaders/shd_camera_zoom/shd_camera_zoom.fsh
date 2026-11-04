const int Quality = 16;
const float blur_intensity = 0.4;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec2 pos;
uniform float radius_not_blured;

void main()
{
	vec4 Color;
	float dist_to_blur_from;
	float dist_to_center = max(distance(v_vTexcoord, pos) - radius_not_blured, 0.0);
	for(float blur_texture_index = 0.0; blur_texture_index < 1.0; blur_texture_index += 1.0 / float(Quality))
	{
		dist_to_blur_from = (1.0 - blur_intensity * dist_to_center) + blur_texture_index * blur_intensity * dist_to_center;
		Color += texture2D(gm_BaseTexture, v_vTexcoord * dist_to_blur_from + pos * (1.0 - dist_to_blur_from));
	}
	Color /= float(Quality);
	gl_FragColor = v_vColour * Color;
}
