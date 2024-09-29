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
};

struct Sphere {
    position: vec3f,
    radius: f32,
    material: RayTracingMaterial
};

const spheres = array(
    Sphere(vec3f(20.0, -10.0, 20.0), 17.0, RayTracingMaterial(vec3f(1.0, 1.0, 1.0), vec3f(1.0), 2.5)),
    Sphere(vec3f(-2.5, 1.0, 4.2), 0.5, RayTracingMaterial(vec3f(1.0, 1.0, 1.0), vec3f(1.0, 0.2, 1.0), 2.0)),

    Sphere(vec3f(0.0, 21.0, 5.0), 20.0, RayTracingMaterial(vec3f(0.4, 0.8, 0.9), vec3f(0.0), 0.0)),

    Sphere(vec3f(0.0, 0.0, 5.0), 1.0, RayTracingMaterial(vec3f(0.1, 1.0, 0.2), vec3f(0.0), 0.0)),
    Sphere(vec3f(-1.5, 0.3, 5.0), 0.8, RayTracingMaterial(vec3f(1.0, 1.0, 1.0), vec3f(0.0), 0.0)),
);
const sphereCount = 5;

const numRaysPerPixel: u32 = 604;
const maxLightBounce: u32 = 6;

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

// Random value in normal distribution (with mean=0 and sd=1)
fn RandomValueNormalDistribution(seed: u32) -> f32
{
    // Thanks to https://stackoverflow.com/a/6178290
    var theta: f32 = 2.0 * 3.1415926 * random_uniform(seed);
    var rho: f32 = sqrt(-2.0 * log(random_uniform(seed)));
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

fn Trace(_ray: Ray, seed: u32) -> vec3f {
    var ray = _ray;

    var incomingLight: vec3f = vec3f(0.0);
    var rayColor: vec3f = vec3f(1.0);

    for (var i: u32 = 0; i <= maxLightBounce; i++) {
        var hitInfo = CalculateRayCollision(ray);
        if (hitInfo.didHit) {
            ray.origin = hitInfo.hitPoint;
            ray.dir = RandomHemisphereDirection(hitInfo.normal, seed+i);

            var material: RayTracingMaterial = hitInfo.material;
            var emittedLight: vec3f = material.emissionColor * material.emissionStrength;
            incomingLight += emittedLight * rayColor;
            rayColor *= material.color;
        }
        else
        {
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

    var viewPointLocal: vec3f = vec3f(uv, 1.0); // * viewParams
    var viewPoint: vec3f = viewPointLocal;

    var numPixels: vec2u = vec2u(u_resolution);
    var pixelCoord: vec2u = vec2u(uv01 * vec2f(numPixels));
    var pixelIndex: u32 = pixelCoord.y * numPixels.x + pixelCoord.x;
    var seed: u32 = pixelIndex + pixelCoord.y*467828 + pixelCoord.x*29738;

    var ray: Ray;
    ray.origin = vec3f(0.0);
    ray.dir = normalize(viewPoint - ray.origin);

    var totalIncomingLight: vec3f = vec3f(0.0);

    for (var rayIndex: u32 = 0; rayIndex < numRaysPerPixel; rayIndex++) {
        totalIncomingLight += Trace(ray, seed + rayIndex);
    }

    var pixeColor = totalIncomingLight / f32(numRaysPerPixel);

    return vec4f(pixeColor, 1.0);

    // return vec4f(vec3f(random_uniform(pixelIndex)), 1.0);
    // return vec4f(vec3f(f32(pixelIndex) / f32(numPixels.x * numPixels.y)), 1.0);
    // return vec4f(ray.dir, 1.0);
    // return vec4f(uv01, 0.0, 1.0);
    // return vec4f(uv, 0.0, 1.0);
}
