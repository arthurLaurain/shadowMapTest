shader_type spatial;
uniform sampler2D screen_tex: hint_screen_texture;
uniform sampler2D depth_tex;

void fragment()
{
	ALBEDO = texture(depth_tex, vec2(SCREEN_UV.x, SCREEN_UV.y)).rgb;
}

void light()
{
	DIFFUSE_LIGHT = vec3(1.);
}