shader_type spatial;
#include "lightUtils.gdshaderinc"
render_mode unshaded;
uniform sampler2D depth_tex : hint_depth_texture;

void fragment() 
{
    float depth = 1. - texture(depth_tex, SCREEN_UV).r;
	ALBEDO = vec3(LinearizeDepth(depth) / far_plane);
	
}