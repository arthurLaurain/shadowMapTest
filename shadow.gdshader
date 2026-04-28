shader_type spatial;
render_mode unshaded;
uniform sampler2D depth_tex : hint_depth_texture;
uniform float linear_depth_bias : hint_range(1., 100., 0.1);

void fragment() {
    float depth = texture(depth_tex, SCREEN_UV).r;

    vec4 clip_space = vec4(SCREEN_UV * 2.0 - 1.0, depth, 1.0);
    vec4 view = INV_PROJECTION_MATRIX * clip_space;
    view /= view.w;

    float linear_depth = -view.z;
	ALBEDO = vec3(clamp(linear_depth / linear_depth_bias, 0.0, 1.0));
	
}