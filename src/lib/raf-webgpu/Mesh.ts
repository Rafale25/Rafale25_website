import { createBuffer } from './createBuffer'

export class Mesh {
    buffer: GPUBuffer
    bufferLayout: GPUVertexBufferLayout

    constructor(device: GPUDevice, vertices: Float32Array) {
        // x y z r g b

        // r g b
        // const colors: Float32Array = new Float32Array(
        //     [
        //         1.0, 0.0, 0.0,
        //         0.0, 1.0, 0.0,
        //         0.0, 0.0, 1.0
        //     ]
        // )

        this.buffer = createBuffer(device, vertices, GPUBufferUsage.VERTEX | GPUBufferUsage.COPY_DST)

        this.bufferLayout = {
            arrayStride: 4 * 6,
            attributes: [
                {
                    shaderLocation: 0,
                    format: "float32x3",
                    offset: 0
                },
                {
                    shaderLocation: 1,
                    format: "float32x3",
                    offset: 4 * 3
                }
            ]
        }
    }
}