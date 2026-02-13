<script>
	import Navbar from '$lib/components/navbar.svelte'
    import Footer from '$lib/components/footer.svelte'
</script>

<main style="--customSaturation: 0%">
    <Navbar/>

    <div class="min-h-screen w-full text-white bg-neutral-900 overflow-hidden font-fira-code">
        <div class="flex flex-col items-center gap-12 mx-6 my-12">

            <div class="flex flex-col items-center text-7xl font-bold text-primary1">
                About
                <hr class="small w-2/3"/>
            </div>

            <div class="flew sm:w-[41rem] text-primary1 text-justify">

                I program a lot in my spare time and post my personal projects here.<br>

                <!-- <br> -->
                <!-- My greatest interests are graphic programming, game development and optimization.<br>
                I enjoy working close to the hardware and optimizing performance through low-level
                programming in C/C++ or by offloading the workload to the GPU.<br> -->
                <!-- <br> -->

                Most of my graphic programming projects uses the OpenGL API.<br>

                <br>

                All of my public source are available over at my <a href="https://github.com/Rafale25">github</a>.<br>

                <br><br><br>

                Programming languages I actively use:
                <div class="flex flex-col gap-1 py-2 px-4 ml-4 text-primary2">
                    <li>C/C++</li>
                    <li>C# (Unity)</li>
                    <li>Python</li>
                    <li>Javascript</li>
                    <li>GLSL</li>
                </div>

                <br>

                Other known programming languages:
                <div class="flex flex-col gap-1 py-2 px-4 ml-4 text-primary2">
                    <li>HLSL, WGSL</li>
                    <li>Lua</li>
                    <li>Bash, Powershell</li>
                </div>

                <br>

                Technologies:
                <div class="flex flex-col gap-1 py-2 px-4 ml-4">
                    <li>
                        <p>Graphic Programming:</p>
                        <p class="text-primary2">
                            OpenGL, WebGL, WebGPU, Vulkan, RenderDoc, GLSL/HLSL,<br>
                            GLM, GLFW, DearImgui
                        </p>
                    </li>

                    <li>
                        <p>GameDev:</p>
                        <p class="text-primary2">
                            Unity, SFML
                        </p>
                    </li>

                    <li>
                        <p>Webdev:</p>
                        <p class="text-primary2">
                            React, Tailwind, NodeJS
                        </p>
                    </li>

                    <li>
                        <p>Source Control:</p>
                        <p class="text-primary2">
                            Git, Github
                        </p>
                    </li>

                    <li>
                        <p>Modeling:</p>
                        <p class="text-primary2">
                            Blender
                        </p>
                    </li>

                    <li>
                        <p>Operating Systems:</p>
                        <p class="text-primary2">
                            Windows, MacOS, Linux (Ubuntu, Debian)
                        </p>
                    </li>
                </div>

                <br>

                Languages:
                <div class="flex flex-col gap-1 py-2 px-4 ml-4 text-primary2">
                    <li>French (native)</li>
                    <li>English (fluent)</li>
                </div>

            </div>
        </div>
<!--
        <div class="flex flex-wrap gap-8 justify-center p-16 text-primary1">
            <div class="flex flex-col w-fit p-4 gap-2 border rounded">
                <p class="text-2xl">Preferred Languages</p>
                <div class="flex flex-col gap-1 p-2 text-lg ml-4">
                    <li>C/C++</li>
                    <li>Python</li>
                    <li>Javascript</li>
                </div>
            </div>

            <div class="flex flex-col w-fit p-4 gap-2 border rounded">
                <p class="text-2xl">Other Known Languages</p>
                <div class="flex flex-col gap-1 p-2 text-lg ml-4">
                    <li class="text-primary2">
                        bash, powershell
                    </li>
                    <li class="text-primary2">
                        Lua
                    </li>
                </div>
            </div>

            <div class="flex flex-col w-fit max-w-80 p-4 gap-2 border rounded">
                <p class="text-2xl">Technologies</p>
                <div class="flex flex-col gap-1 p-2 text-lg ml-4">
                    <li>
                        <p>Graphic Programming:</p>
                        <p class="text-primary2">
                            GLFW, OpenGL, WebGL, WebGPU, GLSL/HLSL, GLM, DearImgui
                        </p>
                    </li>

                    <li>
                        <p>GameDev:</p>
                        <p class="text-primary2">
                            Unity, SFML
                        </p>
                    </li>

                    <li>
                        <p>Webdev:</p>
                        <p class="text-primary2">
                            React, Tailwind, Node
                        </p>
                    </li>

                    <li>
                        <p>Source Control:</p>
                        <p class="text-primary2">
                            Git, Github
                        </p>
                    </li>

                    <li>
                        <p>Modeling:</p>
                        <p class="text-primary2">
                            Blender
                        </p>
                    </li>

                    <li>
                        <p>Operating Systems:</p>
                        <p class="text-primary2">
                            Windows, Mac, Linux (Ubuntu, Debian)
                        </p>
                    </li>
                </div>
            </div>
        </div>
-->
    </div>

    <Footer/>
</main>

<style>
    .font-fira-code {
        font-family: "Fira Code", monospace;
        font-optical-sizing: auto;
        font-weight: 600;
        font-style: normal;
    }

    hr.small {
        max-width: 100px;
        margin: 15px auto;
        border-width: 3px;
        border-color: rgba(255, 255, 255, 0.4);
        border-radius: 3px;
    }

    a {
        color: #41a6ff;
    }

</style>
