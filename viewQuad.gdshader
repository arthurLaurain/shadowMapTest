shader_type spatial;
uniform sampler2D screen_tex: hint_screen_texture;
uniform sampler2D depth_tex: filter_linear_mipmap_anisotropic;

void fragment()
{
	ALBEDO = pow(texture(depth_tex, SCREEN_UV).rgb,vec3(2.2));
}

void light()
{
	DIFFUSE_LIGHT = vec3(1.);
}