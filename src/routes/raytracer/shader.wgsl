struct Fragment {
    @builtin(position) Position : vec4f,
};

@group(0) @binding(0) var<uniform> u_resolution: vec2f;

@vertex
fn vs_main(
    @location(0) v_position: vec3f,
) -> Fragment
{
    var output : Fragment;
    output.Position = vec4f(v_position, 1.0);
    return output;
}

@fragment
fn fs_main(
    @builtin(position) Position : vec4f,
) -> @location(0) vec4f {
    return vec4f(Position.xy/u_resolution, 0.0, 1.0);
}
