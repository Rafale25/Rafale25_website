<script lang='ts'>
	import { onMount, onDestroy } from 'svelte';
	import { browser } from '$app/environment';
	import vertShaderCode from './triangle.vert.wgsl?raw';
	import fragShaderCode from './triangle.frag.wgsl?raw';

	const positions = new Float32Array([
		1, -1, 0, // bottom-right
		-1, -1, 0, // bottom-left
		0, 1, 0 // top-center
	]);

	const colors = new Float32Array([
		1, 0, 0, // red
		0, 1, 0, // green
		0, 0, 1 // blue
	]);

	const indices = new Uint16Array([0, 1, 2]);

	const uniformData = new Float32Array([
		1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0.9, 0.1, 0.3, 1, 0.8, 0.2, 0.8, 1
	]);

	let adapter: GPUAdapter | null = null;
	let device: GPUDevice | null = null;
	let queue: GPUQueue | null = null;
	let canvas: HTMLCanvasElement;
	let context: GPUCanvasContext | null = null;
	let depthTexture: GPUTexture;
	let depthTextureView: GPUTextureView;
	let colorTexture: GPUTexture;
	let colorTextureView: GPUTextureView;
	let positionBuffer: GPUBuffer;
	let colorBuffer: GPUBuffer;
	let indexBuffer: GPUBuffer;

	function createBuffer(arr: Float32Array | Uint16Array, usage: GPUFlagsConstant): GPUBuffer {
		if (!device) throw new Error("Couldn't create buffer, no logical device");

		const desc: GPUBufferDescriptor = {
			size: (arr.byteLength + 3) & ~3,
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

	let vertModule: GPUShaderModule;
	let fragModule: GPUShaderModule;
	let uniformBuffer: GPUBuffer;
	let uniformBindGroupLayout: GPUBindGroupLayout;
	let uniformBindGroup: GPUBindGroup;
	let pipeline: GPURenderPipeline;
	let commandEncoder: GPUCommandEncoder;
	let passEncoder: GPURenderPassEncoder;

	function encodeCommands() {
		if (!device || !queue) throw new Error("Couldn't encode commands, no device.");

		const colorAttachment: GPURenderPassColorAttachment = {
			view: colorTextureView,
			clearValue: { r: 0, g: 0, b: 0, a: 1 },
			// loadValue: { r: 0, g: 0, b: 0, a: 1 },
			loadOp: 'clear',
			storeOp: 'store'
		};

		const depthAttachment: GPURenderPassDepthStencilAttachment = {
			view: depthTextureView,
			depthClearValue: 1,
			// depthLoadValue: 1,
			depthLoadOp: 'clear',
			depthStoreOp: 'store',
			stencilClearValue: 0,
			// stencilLoadValue: 0,
			stencilLoadOp: 'clear',
			stencilStoreOp: 'store'
		};

		const renderPassDesc: GPURenderPassDescriptor = {
			colorAttachments: [colorAttachment],
			depthStencilAttachment: depthAttachment
		};

		commandEncoder = device.createCommandEncoder();

		passEncoder = commandEncoder.beginRenderPass(renderPassDesc);
		passEncoder.setPipeline(pipeline);
		passEncoder.setViewport(0, 0, canvas.width, canvas.height, 0, 1);
		passEncoder.setScissorRect(0, 0, canvas.width, canvas.height);
		passEncoder.setBindGroup(0, uniformBindGroup);
		passEncoder.setVertexBuffer(0, positionBuffer);
		passEncoder.setVertexBuffer(1, colorBuffer);
		passEncoder.setIndexBuffer(indexBuffer, 'uint16');
		passEncoder.drawIndexed(3);
		passEncoder.end();
		// passEncoder.endPass();

		queue.submit([commandEncoder.finish()]);
	}

	const start = Date.now();
	const period = 6; // seconds

	function rotation(t: number): Float32Array {
		const theta = (2 * Math.PI * (t - start)) / 1000 / period;
		return new Float32Array([
			Math.cos(theta),
			Math.sin(theta),
			0,
			0,
			-Math.sin(theta),
			Math.cos(theta),
			0,
			0
		]);
	}

	let rafHandle: number;

	function render() {
		if (!context || !queue) throw new Error("Couldn't render, no context");

		const matrix = rotation(Date.now());
		queue.writeBuffer(uniformBuffer, 0, matrix.buffer, matrix.byteOffset, matrix.byteLength);

		colorTexture = context.getCurrentTexture();
		colorTextureView = colorTexture.createView();

		encodeCommands();

		rafHandle = requestAnimationFrame(render);
	}

	onMount(async () => {
		const entry = navigator.gpu;
		if (!entry) throw new Error('WebGPU is not supported in this browser.');

		adapter = await entry.requestAdapter();
		if (!adapter) throw new Error("Couldn't request GPU adapter.");

		device = await adapter.requestDevice();
		if (!device) throw new Error("Couldn't request GPU logical device.");

		queue = device.queue;

		context = canvas.getContext('webgpu');
		if (!context) throw new Error("Couldn't get WebGPU canvas context.");

		const canvasConfig: GPUCanvasConfiguration = {
			device,
			format: 'bgra8unorm',
			usage: GPUTextureUsage.RENDER_ATTACHMENT | GPUTextureUsage.COPY_SRC,
			alphaMode: 'opaque'
		};
		context.configure(canvasConfig);

		const depthTextureDesc: GPUTextureDescriptor = {
			size: [canvas.width, canvas.height],
			dimension: '2d',
			format: 'depth24plus-stencil8',
			usage: GPUTextureUsage.RENDER_ATTACHMENT | GPUTextureUsage.COPY_SRC
		};

		depthTexture = device.createTexture(depthTextureDesc);
		depthTextureView = depthTexture.createView();

		colorTexture = context.getCurrentTexture();
		colorTextureView = colorTexture.createView();

		positionBuffer = createBuffer(positions, GPUBufferUsage.VERTEX);
		colorBuffer = createBuffer(colors, GPUBufferUsage.VERTEX);
		indexBuffer = createBuffer(indices, GPUBufferUsage.INDEX);

		const vsmDesc: GPUShaderModuleDescriptor = { code: vertShaderCode };
		vertModule = device.createShaderModule(vsmDesc);

		const fsmDesc: GPUShaderModuleDescriptor = { code: fragShaderCode };
		fragModule = device.createShaderModule(fsmDesc);

		uniformBuffer = createBuffer(uniformData, GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST);

		uniformBindGroupLayout = device.createBindGroupLayout({
			entries: [
				{
					binding: 0,
					visibility: GPUShaderStage.VERTEX,
					buffer: {}
				}
			]
		});

		uniformBindGroup = device.createBindGroup({
			layout: uniformBindGroupLayout,
			entries: [
				{
					binding: 0,
					resource: {
						buffer: uniformBuffer
					}
				}
			]
		});

		const pipelineLayoutDesc: GPUPipelineLayoutDescriptor = { bindGroupLayouts: [uniformBindGroupLayout] };
		const layout = device.createPipelineLayout(pipelineLayoutDesc);

		const positionAttribDesc: GPUVertexAttribute = {
			shaderLocation: 0,
			offset: 0,
			format: 'float32x3'
		};

		const colorAttribDesc: GPUVertexAttribute = {
			shaderLocation: 1,
			offset: 0,
			format: 'float32x3'
		};

		const positionBufferDesc: GPUVertexBufferLayout = {
			attributes: [positionAttribDesc],
			arrayStride: 4 * 3,
			stepMode: 'vertex'
		};

		const colorBufferDesc: GPUVertexBufferLayout = {
			attributes: [colorAttribDesc],
			arrayStride: 4 * 3,
			stepMode: 'vertex'
		};

		const depthStencil: GPUDepthStencilState = {
			depthWriteEnabled: true,
			depthCompare: 'less',
			format: 'depth24plus-stencil8'
		};

		const vertex: GPUVertexState = {
			module: vertModule,
			entryPoint: 'main',
			buffers: [positionBufferDesc, colorBufferDesc]
		};

		const colorState: GPUColorTargetState = {
			format: 'bgra8unorm'
		};

		const fragment: GPUFragmentState = {
			module: fragModule,
			entryPoint: 'main',
			targets: [colorState]
		};

		const primitive: GPUPrimitiveState = {
			frontFace: 'cw',
			cullMode: 'none',
			topology: 'triangle-list'
		};

		const pipelineDesc: GPURenderPipelineDescriptor = {
			layout,
			vertex,
			fragment,
			primitive,
			depthStencil
		};

		pipeline = device.createRenderPipeline(pipelineDesc);

		render();
	});

	onDestroy(() => {
		browser && cancelAnimationFrame(rafHandle);
	});
</script>

<svelte:head>
	<title>Triangle render example</title>
	<meta name="description" content="WebGPU triangle render example" />
</svelte:head>

<canvas bind:this={canvas} width={640} height={640} />