export function createBuffer(device: GPUDevice, arr: Float32Array | Uint16Array, usage: GPUBufferUsageFlags): GPUBuffer {
    if (!device) throw new Error("Couldn't create buffer, no logical device");

    const desc: GPUBufferDescriptor = {
        size: arr.byteLength,
        usage,
        mappedAtCreation: true
    };
    const buffer = device.createBuffer(desc);

    const writeArray =
        arr instanceof Uint16Array
            ? new Uint16Array(buffer.getMappedRange())
            : new Float32Array(buffer.getMappedRange());
    writeArray.set(arr);
    buffer.unmap();
    return buffer;
}