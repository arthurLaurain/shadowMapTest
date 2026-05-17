shader_type spatial;
#include "lightUtils.gdshaderinc"

uniform sampler2D screen_tex: hint_screen_texture;
uniform sampler2D depth_tex_light: filter_linear_mipmap_anisotropic;

varying vec3 world_pos;

void vertex()
{
	vec4 world_pos4d = MODEL_MATRIX * vec4(VERTEX,1.0);
	world_pos = world_pos4d.xyz / world_pos4d.w;
}

void fragment()
{
    float FOV = 75.;
	vec4 fragPos = vec4(world_pos, 1.0);
    vec3 lightPos = vec3(14.92, 5., 0.);
    vec3 lightDir = vec3(-1.,0.,0.);
	mat4 lightView = light_view(lightPos, lightDir, vec3(0.,1.,0.));
	mat4 lightProj = create_projection_matrix(FOV, 1., near_plane, far_plane);
    vec4 clipPos = lightProj * lightView * fragPos;
    vec3 projCoords = (clipPos.xyz / clipPos.w) * 0.5 + 0.5;
	vec2 uv = projCoords.xy;
	float current_depth = projCoords.z;
	current_depth = LinearizeDepth(current_depth) / far_plane;
	
	float shadow = 1.;
	float depth_light = pow(texture(depth_tex_light, vec2(uv.x,uv.y)).r,2.2);
	float bias = 0.005;
	if(current_depth - bias > depth_light)
		shadow = pow(depth_light,2.);
	vec3 screen_color = texture(screen_tex, SCREEN_UV).rgb * shadow;
	ALBEDO = vec3(depth_light);
}