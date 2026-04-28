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
    float near = 0.05;
    float far = 5.;
    float FOV = 75.;

	vec4 fragPos = vec4(world_pos, 1.0);
    vec3 lightPos = vec3(14.92, 5., 0.);
    vec3 lightDir = vec3(-1.,0.,0.);
	vec3 target = lightPos + lightDir;
	mat4 lightView = light_view(lightPos, normalize(target - lightPos), vec3(0.,1.,0.));
	mat4 lightProj = create_projection_matrix(FOV, 1., near, far);
    mat4 lightSpace = lightProj * lightView;

    vec4 clipPos = lightSpace * fragPos;
    vec3 projCoords = clipPos.xyz / clipPos.w;

    projCoords = projCoords * 0.5 + 0.5;
	float shadow = 1.;
	float depth_light = pow(texture(depth_tex_light, projCoords.xy).r,2.2);
	float bias = 0.005;
	if(projCoords.z - bias > depth_light)
		shadow = 0.0;
	vec3 screen_color = texture(screen_tex, SCREEN_UV).rgb * shadow;
	ALBEDO = vec3(0.);
	EMISSION = vec3(projCoords.z);
}