shader_type spatial;
#include "lightUtils.gdshaderinc"

uniform sampler2D screen_tex: hint_screen_texture;
uniform sampler2D depth_tex_light: filter_linear_mipmap_anisotropic;

varying vec3 world_pos;

void vertex()
{
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment()
{
    float near = 0.05;
    float far = 4000.;
    float FOV = 75.;

	vec4 fragPos = vec4(world_pos, 1.0);
    vec3 lightPos = vec3(15.72, 5., 0.);
    vec3 lightDir = rotateY(-PI/2.) * vec3(0., 0., -1.);

    mat4 lightView = light_view(lightPos, lightDir, vec3(0.,1.,0.));
    mat4 lightProj = create_projection_matrix(FOV, 1., near, far);
    mat4 lightSpace = lightProj * lightView;

    vec4 clipPos = lightSpace * fragPos;
    vec3 projCoords = clipPos.xyz / clipPos.w;

    projCoords = projCoords * 0.5 + 0.5;

    float depth_light = texture(depth_tex_light, projCoords.xy).r;
	float shadow = 1.;
	if(projCoords.z - 0.005 > depth_light)
		shadow = 0.;
	vec3 screen_color = texture(screen_tex, SCREEN_UV).rgb * shadow;
	EMISSION = screen_color;
}