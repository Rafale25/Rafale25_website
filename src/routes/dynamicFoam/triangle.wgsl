struct Fragment {
    @builtin(position) Position : vec4<f32>,
    @location(0) Color : vec4<f32>
};

@vertex
fn vs_main(@builtin(vertex_index) v_id: u32) -> Fragment {

    var pos = array<vec2f, 3> (
        vec2(0.0, 0.5),
        vec2(-0.5, -0.5),
        vec2(0.5, -0.5)
    );

    var color = array<vec3f, 3> (
        vec3(1.0, 0.0, 0.0),
        vec3(0.0, 1.0, 0.0),
        vec3(0.0, 0.0, 1.0)
    );

    var output : Fragment;
    output.Position = vec4f(pos[v_id], 0.0, 1.0);
    output.Color = vec4f(color[v_id], 1.0);

    return output;
}

@fragment
fn fs_main(@location(0) color: vec4f) -> @location(0) vec4f {
    return color;
}