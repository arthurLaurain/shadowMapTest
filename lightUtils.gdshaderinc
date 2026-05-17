const float near_plane = 0.05;
const float far_plane = 20.;

float LinearizeDepth(float depth)
{
    float z = depth * 2.0 - 1.;
    return (2.0 * near_plane * far_plane) / (far_plane + near_plane - z * (far_plane - near_plane));
}

mat4 light_view(vec3 pos, vec3 dir, vec3 up) {
    vec3 z = normalize(-dir);
    vec3 x = normalize(cross(up, z));
    vec3 y = cross(z, x);

    return mat4(
        vec4(x.x, y.x, z.x, 0.0),
        vec4(x.y, y.y, z.y, 0.0),
        vec4(x.z, y.z, z.z, 0.0),
        vec4(-dot(x, pos), -dot(y, pos), -dot(z, pos), 1.0)
    );
}

mat4 create_projection_matrix(float fov, float aspect, float z_near, float z_far) {
    float f = 1.0 / tan(radians(fov) / 2.0);

    return mat4(
        vec4(f / aspect, 0.0, 0.0, 0.0),
        vec4(0.0, f, 0.0, 0.0),
        vec4(0.0, 0.0, (z_far + z_near) / (z_near - z_far), -1.0),
        vec4(0.0, 0.0, (2.0 * z_far * z_near) / (z_near - z_far), 0.0)
    );
}