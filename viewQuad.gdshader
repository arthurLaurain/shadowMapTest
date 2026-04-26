shader_type spatial;

render_mode unshaded, fog_disabled;
uniform sampler2D screen_tex: hint_screen_texture;
uniform sampler2D depth_tex: hint_depth_texture;

void fragment()
{
	ALBEDO = vec3(texture(depth_tex, SCREEN_UV).r);
}