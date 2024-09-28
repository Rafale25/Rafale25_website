export function makePipeline(
    device: GPUDevice,
    vertex: string,
    fragment: string,
    bufferLayouts: Iterable<GPUVertexBufferLayout>,
    topology: GPUPrimitiveTopology = "triangle-list"
): GPURenderPipeline
{
    const pipeline = device.createRenderPipeline({
        layout: 'auto',
        vertex: {
            module: device.createShaderModule({
                code: vertex,
            }),
            buffers: bufferLayouts
        },
        fragment: {
            module: device.createShaderModule({
                code: fragment
            }),
            targets: [{
                format: navigator.gpu.getPreferredCanvasFormat(),
            }]
        },
        primitive: {
            topology
        },
    })

    return pipeline
}