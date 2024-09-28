import { createBuffer } from './createBuffer'

export class Mesh {
    buffer: GPUBuffer
    bufferLayout: GPUVertexBufferLayout

    constructor(device: GPUDevice, vertices: Float32Array) {
        this.buffer = createBuffer(device, vertices, GPUBufferUsage.VERTEX | GPUBufferUsage.COPY_DST)

        this.bufferLayout = {
            // arrayStride: 6 * 4, // 6 floats, 4 bytes each
            arrayStride: 3 * 4, // 6 floats, 4 bytes each
            attributes: [
                {
                    shaderLocation: 0,
                    format: "float32x3",
                    offset: 0
                },
                // {
                //     shaderLocation: 1,
                //     format: "float32x3",
                //     offset: 4 * 3
                // }
            ]
        }
    }
}
