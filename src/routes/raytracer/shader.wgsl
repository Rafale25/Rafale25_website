struct Fragment {
    @builtin(position) Position : vec4f,
};

struct Ray {
    origin: vec3f,
    dir: vec3f
};

struct HitInfo {
    didHit: bool,
    dst: f32,
    hitPoint: vec3f,
    normal: vec3f,
    material: RayTracingMaterial
};

struct RayTracingMaterial {
    color: vec3f,
    emissionColor: vec3f,
    emissionStrength: f32,
    smoothness: f32,
    specularProbability: f32,
    specularColor: vec3f,
};

struct Sphere {
    position: vec3f,
    radius: f32,
    material: RayTracingMaterial
};

struct ParamsUniforms {
    resolution: vec2f,
    frameCount: u32,

    numRaysPerPixel: u32,
    maxLightBounce: u32,
    divergeStrength: f32,

    useSkybox: u32,
    skyColorZenith: vec3f,
    skyColorHorizon: vec3f,
    groundColor: vec3f,
    sunLightDirection: vec3f,
    sunFocus: f32,
    sunIntensity: f32,

    focusDistance: f32,
    unfocusStrength: f32,

    viewPosition: vec3f,
    viewMatrix: mat4x4<f32>,
};

const PI: f32 = 3.141592653;

const spheres = array(
    Sphere(vec3f(20.0, -10.0, 20.0), 17.0, RayTracingMaterial(vec3f(1.0, 1.0, 1.0), vec3f(1.0), 2.0, 0.0, 0, vec3f(1.0))),
    Sphere(vec3f(-2.5, 1.0, 4.2), 0.5, RayTracingMaterial(vec3f(1.0, 1.0, 1.0), vec3f(1.0, 0.2, 1.0), 3.0, 0, 0, vec3f(1.0))),

    Sphere(vec3f(0.0, 21.0, 5.0), 20.0, RayTracingMaterial(vec3f(0.4, 0.8, 0.9), vec3f(0.0), 0.0, 0.0, 0, vec3f(1.0))),

    Sphere(vec3f(0.0, 0.0, 5.0), 1.0, RayTracingMaterial(vec3f(0.1, 1.0, 0.2), vec3f(0.0), 0.0, 0.0, 0, vec3f(1.0))),
    Sphere(vec3f(-1.7, 0.3, 5.0), 0.8, RayTracingMaterial(vec3f(1.0, 1.0, 1.0), vec3f(0.0), 0.0, 0.95, 0, vec3f(1.0))),

    Sphere(vec3f(1.5, 0.8, 4.0), 0.9, RayTracingMaterial(vec3f(1, 0, 0), vec3f(0), 0, 1, 0.1, vec3f(1))),
    Sphere(vec3f(-0.8, 1.0, 2.3), 0.3, RayTracingMaterial(vec3f(0, 0.4, 1), vec3f(0), 0, 1, 0.1, vec3f(1))),
);
const sphereCount = 7;

fn hash(_x: u32) -> u32 {
    var x = _x;
    x ^= 2747636419u;
    x *= 2654435769u;
    x ^= x >> 16;
    x *= 2654435769u;
    x ^= x >> 16;
    x *= 2654435769u;
    return x;
}

fn random_uniform(seed: u32) -> f32 { // [0, 1]
    return f32(hash(seed)) / 4294967295.0;
}

fn randomPointInCircle(seed: u32) -> vec2f {
    var angle: f32 = random_uniform(seed) * 2.0 * PI;
    var pointOnCircle = vec2f(cos(angle), sin(angle));
    return pointOnCircle * sqrt(random_uniform(seed+11));
}

// Random value in normal distribution (with mean=0 and sd=1)
fn RandomValueNormalDistribution(seed: u32) -> f32 {
    // Thanks to https://stackoverflow.com/a/6178290
    var theta: f32 = 2.0 * PI * random_uniform(seed);
    var rho: f32 = sqrt(-2.0 * log(random_uniform(seed*3)));
    return rho * cos(theta);
}

fn RandomDirection(seed: u32) -> vec3f {
    // Thanks to https://math.stackexchange.com/a/1585996
    var x: f32 = RandomValueNormalDistribution(seed+7);
    var y: f32 = RandomValueNormalDistribution(seed+13);
    var z: f32 = RandomValueNormalDistribution(seed+3);
    return normalize(vec3f(x, y, z));
}

fn RandomHemisphereDirection(normal: vec3f, seed: u32) -> vec3f {
    var dir = RandomDirection(seed);
    return dir * sign(dot(normal, dir));
}

fn RaySphere(ray: Ray, sphereCenter: vec3f, sphereRadius: f32) -> HitInfo {
    var hitInfo: HitInfo = HitInfo();
    var offsetRayOrigin: vec3f = ray.origin - sphereCenter;

    var a: f32 = dot(ray.dir, ray.dir);
    var b: f32 = 2.0 * dot(offsetRayOrigin, ray.dir);
    var c: f32 = dot(offsetRayOrigin, offsetRayOrigin) - sphereRadius * sphereRadius;
    var discriminant: f32 = b * b - 4 * a * c;

    if (discriminant >= 0) {
        var dst: f32 = (-b - sqrt(discriminant)) / (2.0 * a);

        if (dst >= 0.0) {
            hitInfo.didHit = true;
            hitInfo.dst = dst;
            hitInfo.hitPoint = ray.origin + ray.dir * dst;
            hitInfo.normal = normalize(hitInfo.hitPoint - sphereCenter);
        }
    }

    return hitInfo;
}

fn CalculateRayCollision(ray: Ray) -> HitInfo {
    var closestHit: HitInfo = HitInfo();
    closestHit.dst = 100000000.0;

    for (var i: u32 = 0; i < sphereCount; i++) {
        var sphere: Sphere = spheres[i];
        var hitInfo = RaySphere(ray, sphere.position, sphere.radius);

        if (hitInfo.didHit && hitInfo.dst < closestHit.dst) {
            closestHit = hitInfo;
            closestHit.material = sphere.material;
        }
    }

    return closestHit;
}

fn GetEnvironmentLight(ray: Ray) -> vec3f {
    var skyGradientT: f32 = pow(smoothstep(0.0, 0.4, -ray.dir.y), 0.35);
    var skyGradient: vec3f = mix(u_params.skyColorHorizon, u_params.skyColorZenith, skyGradientT);
    var sun: f32 = pow(max(0.0, dot(ray.dir, -normalize(u_params.sunLightDirection))), u_params.sunFocus) * u_params.sunIntensity;

    var groundToSkyT: f32 = smoothstep(-0.01, 0.0, -ray.dir.y);
    var sunMask: f32 = f32(groundToSkyT >= 1.0);
    return mix(u_params.groundColor, skyGradient, groundToSkyT) + sun * sunMask;
}

fn Trace(_ray: Ray, seed: u32) -> vec3f {
    var ray = _ray;

    var incomingLight: vec3f = vec3f(0.0);
    var rayColor: vec3f = vec3f(1.0);

    for (var i: u32 = 0; i <= u_params.maxLightBounce; i++) {
        var hitInfo = CalculateRayCollision(ray);
        var material: RayTracingMaterial = hitInfo.material;

        if (hitInfo.didHit) {
            ray.origin = hitInfo.hitPoint;

            var diffuseDir = normalize(hitInfo.normal + RandomDirection(seed+i));
            var specularDir = reflect(ray.dir, hitInfo.normal);
            var isSpecularBounce: f32 = f32(material.specularProbability >= random_uniform(seed+i+7268));
            ray.dir = normalize(mix(diffuseDir, specularDir, material.smoothness * isSpecularBounce));

            var emittedLight: vec3f = material.emissionColor * material.emissionStrength;
            incomingLight += emittedLight * rayColor;
            rayColor *= mix(material.color, material.specularColor, isSpecularBounce);
        }
        else
        {
            if (u_params.useSkybox == 1) {
                incomingLight += GetEnvironmentLight(ray) * rayColor;
            }
            break;
        }
    }

    return incomingLight;
}

@group(0) @binding(0) var<uniform> u_params: ParamsUniforms;
@group(0) @binding(1) var<storage, read_write> pixel_buffer: array<vec4f>;

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
    var uv01 = Position.xy / u_params.resolution;
    var uv: vec2f = (2.0 * Position.xy - u_params.resolution) / u_params.resolution.y;

    var numPixels: vec2u = vec2u(u_params.resolution);
    var pixelCoord: vec2u = vec2u(uv01 * vec2f(numPixels));
    var pixelIndex: u32 = pixelCoord.y * numPixels.x + pixelCoord.x;
    var seed: u32 = (pixelIndex+u32(f32(u_params.frameCount)*2371)) + pixelCoord.y*467828 + pixelCoord.x*29738;

    var viewPointLocal = vec3f(uv, 1.0) * u_params.focusDistance;
    var viewPoint = (u_params.viewMatrix * vec4f(viewPointLocal, 1.0)).xyz;

    var camRight = vec3f(u_params.viewMatrix[0][0], u_params.viewMatrix[0][1], u_params.viewMatrix[0][2]);
    var camUp = vec3f(u_params.viewMatrix[1][0], u_params.viewMatrix[1][1], u_params.viewMatrix[1][2]);

    var totalIncomingLight: vec3f = vec3f(0.0);

    for (var rayIndex: u32 = 0; rayIndex < u_params.numRaysPerPixel; rayIndex++) {
        var ray: Ray;

        var defocusJitter: vec2f = randomPointInCircle(seed+rayIndex*7263) * u_params.unfocusStrength / f32(numPixels.x);

        ray.origin = u_params.viewPosition + camRight*defocusJitter.x + camUp*defocusJitter.y;

        var jitter: vec2f = randomPointInCircle(seed + rayIndex) * u_params.divergeStrength / f32(numPixels.x);
        var jitteredViewPoint = viewPoint + camRight * jitter.x + camUp * jitter.y;
        ray.dir = normalize(jitteredViewPoint - ray.origin);

        var incomingLight = Trace(ray, seed+rayIndex);
        totalIncomingLight += incomingLight;
    }

    var pixelColor = totalIncomingLight;

    pixel_buffer[pixelIndex] += vec4f(pixelColor, 0.0);
    var pixelBufferColor: vec3f = pixel_buffer[pixelIndex].rgb;

    var finalColor = pixelBufferColor / f32(u32(u_params.frameCount)*u_params.numRaysPerPixel);

    // return vec4f(pixelColor / f32(u_params.numRaysPerPixel), 1.0);
    return vec4f(finalColor, 1.0);

    // return vec4f(vec3f(random_uniform(seed)), 1.0);
    // return vec4f(vec3f(f32(pixelIndex) / f32(numPixels.x * numPixels.y)), 1.0);
    // return vec4f(uv01, 0.0, 1.0);
    // return vec4f(uv, 0.0, 1.0);
}
