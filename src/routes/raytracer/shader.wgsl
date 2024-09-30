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
};

struct Sphere {
    position: vec3f,
    radius: f32,
    material: RayTracingMaterial
};

const PI: f32 = 3.141592653;

const spheres = array(
    Sphere(vec3f(20.0, -10.0, 20.0), 17.0, RayTracingMaterial(vec3f(1.0, 1.0, 1.0), vec3f(1.0), 2.0, 0.0)),
    Sphere(vec3f(-2.5, 1.0, 4.2), 0.5, RayTracingMaterial(vec3f(1.0, 1.0, 1.0), vec3f(1.0, 0.2, 1.0), 3.0, 0.0)),

    Sphere(vec3f(0.0, 21.0, 5.0), 20.0, RayTracingMaterial(vec3f(0.4, 0.8, 0.9), vec3f(0.0), 0.0, 0.0)),

    Sphere(vec3f(0.0, 0.0, 5.0), 1.0, RayTracingMaterial(vec3f(0.1, 1.0, 0.2), vec3f(0.0), 0.0, 0.0)),
    Sphere(vec3f(-1.7, 0.3, 5.0), 0.8, RayTracingMaterial(vec3f(1.0, 1.0, 1.0), vec3f(0.0), 0.0, 0.95)),
);
const sphereCount = 5;

const numRaysPerPixel: u32 = 300;
const maxLightBounce: u32 = 6;
const DivergeStrength: f32 = 1.0;

const USE_SKYBOX: bool = true;
const SkyColorZenith: vec3f = vec3f(0.0788, 0.364, 0.7264);
const SkyColorHorizon: vec3f = vec3f(1.0, 1.0, 1.0);
const GroundColor: vec3f = vec3f(0.35, 0.3, 0.35);
const SunLightDirection: vec3f = normalize(vec3f(0.5, 0.6, -0.5));
const SunFocus: f32 = 500.0;
const SunIntensity: f32 = 0;//200.0;

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
fn RandomValueNormalDistribution(seed: u32) -> f32
{
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
    var skyGradient: vec3f = mix(SkyColorHorizon, SkyColorZenith, skyGradientT);
    var sun: f32 = pow(max(0.0, dot(ray.dir, -SunLightDirection)), SunFocus) * SunIntensity;

    var groundToSkyT: f32 = smoothstep(-0.01, 0.0, -ray.dir.y);
    var sunMask: f32 = f32(groundToSkyT >= 1.0);
    return mix(GroundColor, skyGradient, groundToSkyT) + sun * sunMask;
}

fn Trace(_ray: Ray, seed: u32) -> vec3f {
    var ray = _ray;

    var incomingLight: vec3f = vec3f(0.0);
    var rayColor: vec3f = vec3f(1.0);

    for (var i: u32 = 0; i <= maxLightBounce; i++) {
        var hitInfo = CalculateRayCollision(ray);
        var material: RayTracingMaterial = hitInfo.material;

        if (hitInfo.didHit) {
            ray.origin = hitInfo.hitPoint;

            var diffuseDir = normalize(hitInfo.normal + RandomDirection(seed+i));
            var specularDir = reflect(ray.dir, hitInfo.normal);
            ray.dir = normalize(mix(diffuseDir, specularDir, material.smoothness));

            var emittedLight: vec3f = material.emissionColor * material.emissionStrength;
            var lightStrength = dot(hitInfo.normal, ray.dir);
            incomingLight += emittedLight * rayColor;
            rayColor *= material.color;
        }
        else
        {
            if (USE_SKYBOX) {
                incomingLight += GetEnvironmentLight(ray) * rayColor;
            }
            break;
        }
    }

    return incomingLight;
}

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
    var uv01 = Position.xy / u_resolution;
    var uv: vec2f = (2.0 * Position.xy - u_resolution) / u_resolution.y;

    var viewPointLocal = vec3f(uv, 1.0); // * viewParams
    var viewPoint = viewPointLocal;

    var numPixels: vec2u = vec2u(u_resolution);
    var pixelCoord: vec2u = vec2u(uv01 * vec2f(numPixels));
    var pixelIndex: u32 = pixelCoord.y * numPixels.x + pixelCoord.x;
    var seed: u32 = pixelIndex + pixelCoord.y*467828 + pixelCoord.x*29738;

    var totalIncomingLight: vec3f = vec3f(0.0);

    for (var rayIndex: u32 = 0; rayIndex < numRaysPerPixel; rayIndex++) {
        var ray: Ray;
        ray.origin = vec3f(0.0);
        var jitter: vec2f = randomPointInCircle(seed + rayIndex) * DivergeStrength / f32(numPixels.x);
        var jitteredViewPoint = viewPoint + vec3f(1.0, 0.0, 0.0) * jitter.x + vec3f(0.0, 1.0, 0.0) * jitter.y;
        ray.dir = normalize(jitteredViewPoint - ray.origin);

        var incomingLight = Trace(ray, seed+rayIndex);
        totalIncomingLight += incomingLight;
    }

    var pixelColor = totalIncomingLight / f32(numRaysPerPixel);

    return vec4f(pixelColor, 1.0);

    // return vec4f(vec3f(random_uniform(seed)), 1.0);
    // return vec4f(vec3f(f32(pixelIndex) / f32(numPixels.x * numPixels.y)), 1.0);
    // return vec4f(uv01, 0.0, 1.0);
    // return vec4f(uv, 0.0, 1.0);
}
