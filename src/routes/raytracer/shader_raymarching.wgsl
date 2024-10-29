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

    mergeStrength: f32,

    viewPosition: vec3f,
    viewMatrix: mat4x4<f32>,
};

struct DistInfo {
    distance: f32,
    material: RayTracingMaterial,
};

fn fractal(_p: vec3f) -> f32 {
    var CSize: vec3f = vec3f(1.0, 1.0, 1.3);

	var p: vec3f = _p.xzy;
	var scale: f32 = 1.;
	for (var i: u32 = 0; i < 12; i++) {
		p = 2.0*clamp(p, -CSize, CSize) - p;
		var r2: f32 = dot(p,p);
        //float r2 = dot(p,p+sin(p.z*.3)); //Alternate fractal
		var k: f32 = max((2.)/(r2), .027);
		p *= k;
		scale *= k;
	}
	var l: f32 = length(p.xy);
	var rxy: f32 = l - 4.0;
	var n: f32 = l * p.z;
	rxy = max(rxy, -(n) / 4.0);
	return (rxy) / abs(scale);
}

const PI: f32 = 3.141592653;

const spheres = array(
    Sphere(vec3f(20.0, -10.0, 20.0), 17.0, RayTracingMaterial(vec3f(1.0, 1.0, 1.0), vec3f(1.0), 2.0, 0.0, 0, vec3f(1.0))),
    Sphere(vec3f(-2.5, 1.0, 4.2), 0.5, RayTracingMaterial(vec3f(1.0, 1.0, 1.0), vec3f(1.0), 7.0, 0, 0, vec3f(1.0))),

    Sphere(vec3f(0.0, 21.0, 5.0), 20.0, RayTracingMaterial(vec3f(0.4, 0.8, 0.9), vec3f(0.0), 0.0, 0.0, 0, vec3f(1.0))),

    Sphere(vec3f(0.0, 0.0, 5.0), 1.0, RayTracingMaterial(vec3f(0.1, 1.0, 0.2), vec3f(0.0), 0.0, 0.0, 0, vec3f(1.0))),
    Sphere(vec3f(-1.7, 0.3, 5.0), 0.8, RayTracingMaterial(vec3f(1.0, 1.0, 1.0), vec3f(0.0), 0.0, 0.95, 0, vec3f(1.0))),

    Sphere(vec3f(1.5, 0.8, 4.0), 0.9, RayTracingMaterial(vec3f(1, 0, 0), vec3f(0), 0, 1, 0.1, vec3f(1))),
    Sphere(vec3f(-0.8, 1.0, 2.3), 0.3, RayTracingMaterial(vec3f(0, 0.4, 1), vec3f(0), 0, 1, 0.1, vec3f(1))),

    // BIG WHITE BALL
    // Sphere(vec3f(46.0, 0.0, 0.0), 40.0, RayTracingMaterial(vec3f(1.0), vec3f(1.0), 3, 1, 1, vec3f(1))),
);
const sphereCount = 7;

fn mixMaterial(matA: RayTracingMaterial, matB: RayTracingMaterial, d: f32) -> RayTracingMaterial {
    return RayTracingMaterial(
        mix(matA.color,                 matB.color,                 d),
        mix(matA.emissionColor,         matB.emissionColor,         d),
        mix(matA.emissionStrength,      matB.emissionStrength,      d),
        mix(matA.smoothness,            matB.smoothness,            d),
        mix(matA.specularProbability,   matB.specularProbability,   d),
        mix(matA.specularColor,         matB.specularColor,         d),
    );
}

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

fn GetEnvironmentLight(ray: Ray) -> vec3f {
    var skyGradientT: f32 = pow(smoothstep(0.0, 0.4, -ray.dir.y), 0.35);
    var skyGradient: vec3f = mix(u_params.skyColorHorizon, u_params.skyColorZenith, skyGradientT);
    var sun: f32 = pow(max(0.0, dot(ray.dir, -normalize(u_params.sunLightDirection))), u_params.sunFocus) * u_params.sunIntensity;

    var groundToSkyT: f32 = smoothstep(-0.01, 0.0, -ray.dir.y);
    var sunMask: f32 = f32(groundToSkyT >= 1.0);
    return mix(u_params.groundColor, skyGradient, groundToSkyT) + sun * sunMask;
}

const MAX_DIST = 200.0;
const MAX_STEP = 150;
const SURFACE_DIST = 0.001;

fn opSmoothUnion(d1: f32, d2: f32, k: f32) -> f32 {
    var h: f32 = clamp(0.5 + 0.5*(d2-d1)/k, 0.0, 1.0);
    return mix(d2, d1, h) - k*h*(1.0-h);
}

fn opSubtraction(d1: f32, d2: f32) -> f32 {
    return max(-d1,d2);
}

fn sdSphere(p: vec3f, s: f32) -> f32 {
    return length(p)-s;
}

fn Map(p: vec3f) -> DistInfo {
    var camera_position: vec3f = u_params.viewPosition;

    var dist: f32 = 1000000.0;
    var material: RayTracingMaterial;

    var fractalMaterial: RayTracingMaterial = RayTracingMaterial(vec3f(1.0, 1.0, 1.0), vec3f(0.0), 0.0, 0.0, 0, vec3f(1.0));

    for (var i: u32 = 0; i < sphereCount; i++) {
        var sphere: Sphere = spheres[i];

        var d1 = dist;
        var d2 = sdSphere(p - sphere.position, sphere.radius);
        var k = u_params.mergeStrength;
        var d = opSmoothUnion(d1, d2, k);
        var h: f32 = clamp(0.5 + 0.5*(d2-d1)/k, 0.0, 1.0);

        material = mixMaterial(sphere.material, material, h);

        if (d < dist) {
            dist = d;
        }
    }

    var d1 = dist;
    var d2 = fractal(p - vec3f(0.0, 7.0, 0.0));
    var k = u_params.mergeStrength;
    var d = opSmoothUnion(d1, d2, k);
    var h: f32 = clamp(0.5 + 0.5*(d2-d1)/k, 0.0, 1.0);

    if (d < dist) {
        dist = d;
        material = mixMaterial(fractalMaterial, material, h);
    }

    // dist = min(dist, fractal(p));
    // dist = fractal(p);

    // var dCameraSphere: f32 = sdSphere(p - camera_position, 2.0);
    // dist = opSubtraction(dCameraSphere, dist);
    // var material: RayTracingMaterial = spheres[index].material;

    return DistInfo(dist, material);
}

fn getDistMaterial(p: vec3f) -> DistInfo {
    var dm: DistInfo = Map(p);
    return dm;
}

fn getDist(p: vec3f) -> f32 {
    var dm: DistInfo = Map(p);
    // var dst: f32 = Map(p);
    return dm.distance;
}

fn rayMarch(rayOrigin: vec3f, rayDirection: vec3f) -> DistInfo {
    var d0: f32 = 0.0;
    var material: RayTracingMaterial;

    for (var i: u32 = 0; i < MAX_STEP; i++) {

        var p: vec3f = rayOrigin + rayDirection * d0;
        var dm: DistInfo = getDistMaterial(p);

        // var ds: f32 = getDist(p);
        d0 += dm.distance;
        material = dm.material;

        if (d0 > MAX_DIST || dm.distance < SURFACE_DIST) {
            break;
        }
    }
    return DistInfo(d0, material);
}

fn GetNormal(p: vec3f) -> vec3f {
    var d: f32 = getDist(p); // Distance
    var e: vec2f = vec2f(.0001, 0); // Epsilon
    var n: vec3f = d - vec3f(
        getDist(p-e.xyy),
        getDist(p-e.yxy),
        getDist(p-e.yyx));

    return normalize(n);
}

fn GetLight(p: vec3f) -> f32 {
    // Directional light
    var l: vec3f = normalize(-u_params.sunLightDirection); // Light Vector
    var n: vec3f = GetNormal(p); // Normal Vector

    var dif: f32 = dot(n, l); // Diffuse light
    dif = clamp(dif, 0.0, 1.0); // Clamp so it doesnt go below 0

    // Shadows
    // var d: f32 = rayMarch(p+n*SURFACE_DIST*2., l);
    var dm: DistInfo = rayMarch(p+n*SURFACE_DIST*2., l);
    if (dm.distance < MAX_DIST) {
        dif *= .1;
    }

    return dif;
}

fn Trace(_ray: Ray, seed: u32) -> vec3f {
    var ray: Ray = _ray;

    var incomingLight: vec3f = vec3f(0.0);
    var rayColor: vec3f = vec3f(1.0);

    for (var i: u32 = 0; i <= u_params.maxLightBounce; i++) {
        var hitInfo: DistInfo = rayMarch(ray.origin, ray.dir);
        var material: RayTracingMaterial = hitInfo.material;

        var p = ray.origin + ray.dir * hitInfo.distance;
        var normal = GetNormal(p);

        if (hitInfo.distance < MAX_DIST) {
            ray.origin = p + normal * (SURFACE_DIST+0.001);

            var diffuseDir = normalize(normal + RandomDirection(seed+i));
            var specularDir = reflect(ray.dir, normal);
            var isSpecularBounce: f32 = f32(material.specularProbability >= random_uniform(seed+i+7268));
            ray.dir = normalize(mix(diffuseDir, specularDir, material.smoothness * isSpecularBounce));

            var emittedLight: vec3f = material.emissionColor * material.emissionStrength;
            incomingLight += emittedLight * rayColor;
            rayColor *= mix(material.color, material.specularColor, isSpecularBounce);
        } else {
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
    // var finalColor = pixelColor;

    // return vec4f(pixelColor / f32(u_params.numRaysPerPixel), 1.0);
    return vec4f(finalColor, 1.0);

    // return vec4f(vec3f(random_uniform(seed)), 1.0);
    // return vec4f(vec3f(f32(pixelIndex) / f32(numPixels.x * numPixels.y)), 1.0);
    // return vec4f(uv01, 0.0, 1.0);
    // return vec4f(uv, 0.0, 1.0);
}
