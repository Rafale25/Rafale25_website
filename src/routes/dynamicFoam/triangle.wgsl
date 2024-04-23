// struct TransformData {
//     model: mat4x4f,
//     view: mat4x4f,
//     projection: mat4x4f,
// }
// @binding(0) @group(0) var<uniform> transformUBO: TransformData

struct Fragment {
    @builtin(position) Position : vec4<f32>,
    @location(0) Color : vec4<f32>
};

// fn vs_main(@builtin(vertex_index) v_id: u32) -> Fragment {
@vertex
fn vs_main(@builtin(instance_index) instance_id: u32, @location(0) v_position: vec3f, @location(1) v_color: vec3f) -> Fragment {
    var output : Fragment;
    output.Position = vec4f(v_position, 1.0);
    output.Color = vec4f(v_color, 0.0);

    output.Position.x += f32(instance_id) * 0.1;

    return output;
}

@fragment
fn fs_main(@location(0) color: vec4f) -> @location(0) vec4f {
    return color;
}