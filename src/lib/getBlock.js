import { noise } from '$lib/noise.js'

export const BlockType = {
    AIR: 0,
    GRASS: 1,
    DIRT: 2,
    STONE: 3,
    OAK_LOG: 4,
    OAK_LEAF: 5,
    WATER: 6
}

function octaveNoise2D(x, z, octaves=1, fallOff=2) {
    let h = 0.0

    for (let i = 0 ; i < octaves ; ++i) {
        const v = noise.simplex2( // [-1, 1]
                    x * (i + 1),
                    z * (i + 1)
                )
        h += v / Math.pow(fallOff, i)
    }

    return h
}


function octaveNoise3D(x, y, z, octaves=1, fallOff=2) {
    let h = 0.0

    for (let i = 0 ; i < octaves ; ++i) {
        const v = noise.simplex3(
            x * (i + 1),
            y * (i + 1),
            z * (i + 1)
        )
        h += v /  Math.pow(fallOff, i)
    }

    return h
}

function continentalnessCurve(x) {
//        if (x > 1f) return 0.7646f
//        if (x < -1f) return -0.7646f
    return Math.sin(x * x * x * 0.6) + 0.2
}

function lerp(a, b, t) {
    return a * (1.0 - t) + (b * t)
}

function mapRange(value, min1, max1, min2, max2) {
    return min2 + (value - min1) * (max2 - min2) / (max1 - min1)
}


// current getBlock function from 3D-multi-test server
/*
export function getBlock(x, y, z) {
    const continentalnessNoiseScaleFactor = 1.0 / 900.0
    const continentalness = continentalnessCurve(octaveNoise2D(x * continentalnessNoiseScaleFactor, z * continentalnessNoiseScaleFactor, 3)) // 2D [-1, 1]
    const erosionNoiseScaleFactor = 1.0 / 1800.0
    const erosion = octaveNoise2D(x * erosionNoiseScaleFactor, z * erosionNoiseScaleFactor, 2) // 2D [-1, 1]
//  const peaksAndValleys

    const densityNoiseScaleFactor = 1.0 / 600.0
    const density = octaveNoise3D(x * densityNoiseScaleFactor, y * densityNoiseScaleFactor, z * densityNoiseScaleFactor, 5, 1.3) // 3D [-1, 1]

    const normalizedHeight = y / 128.0
    const squashingFactor = 0.2// 0.08
    const squashing = squashingFactor * (1.0 - mapRange(erosion, -1.0, 1.0, 0.0, 1.0)) // using erosion to affect squashing
    const fill = density * squashing > normalizedHeight - continentalness * 0.4

    if (fill) {
        if (y > 0) return BlockType.GRASS
        if (y === 0) return BlockType.OAK_LOG
        return BlockType.STONE
    }
    return BlockType.AIR
}
*/

export function getBlock(x, y, z) {
    const baseHeight = 0
    const dirtDepth = 3

    const noiseValue = octaveNoise2D(x * 0.0002, z * 0.0002, 3, 1.5) * 8.0
    const noiseValue2 = octaveNoise2D(x * 0.01, z * 0.01, 3, 1.4) * 4.0
    const noiseHeight = Math.pow(2.0, noiseValue) + noiseValue2
    const realheight = baseHeight + (noiseHeight >> 0)

    const dirtNoiseScaleFactor = 1.0 / 65
    const dirtNoise = octaveNoise3D(x * dirtNoiseScaleFactor, y * dirtNoiseScaleFactor, z * dirtNoiseScaleFactor, 3, 1.3) // 3D [-1, 1]

    const caveNoiseScaleFactor = 1.0 / 150.0
    const caveNoiseScaleFactor2 = 1.0 / 300.0
    const caveDensity = octaveNoise3D((x+1000) * caveNoiseScaleFactor, y * caveNoiseScaleFactor, z * caveNoiseScaleFactor, 6, 1.17) // 3D [-1, 1]
    const caveDensity2 = octaveNoise3D((x+3650) * caveNoiseScaleFactor2*0.5, y * caveNoiseScaleFactor2, (z+2042) * caveNoiseScaleFactor2*0.5, 2, 1.6) // 3D [-1, 1]

    const noiseValueCave = octaveNoise2D((x-7452) * 0.0005, (z+1976) * 0.0005, 1) + 0.5

    const caveBaseHeight = 128
    const caveFallOf = 0.01

    if ((caveDensity + caveDensity2) * noiseValueCave - Math.abs((y+caveBaseHeight-realheight + noiseValue*10)*caveFallOf) > 0.0) {
        return BlockType.AIR
    }

    if (y < realheight && dirtNoise > 0.4) return BlockType.DIRT

    if (y < realheight - dirtDepth) return BlockType.STONE
    if (y === realheight) return BlockType.GRASS
    if (y < realheight) return BlockType.DIRT
    return BlockType.AIR
}

// export function getBlock(x, y, z) {
//     const baseHeight = 16
//     // const height = Math.floor(Math.sin(x * 0.2) * 4) + baseHeight
//     const scale = 0.03
//     const amplification = 100

//     // const noiseValue = noise.perlin3(x*scale, y*scale, z*scale)
//     const noiseValue = noise.simplex3(x*scale, y*scale, z*scale)
//     const height = (noiseValue * amplification) >> 0

//     if (y === height) return BlockType.GRASS
//     if (y < height && y > height - 3) return BlockType.DIRT
//     if (y < height) return BlockType.STONE
//     return BlockType.AIR
// }