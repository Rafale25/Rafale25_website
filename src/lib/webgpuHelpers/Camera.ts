import { Mat4, Vec4, Vec3 } from "gl-matrix"

function clamp(number, min, max) {
    return Math.max(min, Math.min(number, max));
}

export class Camera {
    fov: number
    aspectRatio: number
    nearPlane: number
    farPlane: number

    position: Vec3
    yaw: number
    pitch: number
    roll: number

    _movement: Vec3
    speed: number

    up: Vec3
    right: Vec3
    forward: Vec3
    worldUp: Vec3

    constructor(fov: number, aspectRatio: number = 16/9,  position: Vec3, yaw: number, pitch: number) {
        this.fov = fov
        this.aspectRatio = aspectRatio
        this.nearPlane = 0.1
        this.farPlane = 1000.0

        this.position = position
        this.yaw = yaw
        this.pitch = pitch
        this.roll = 0.0

        this.speed = 1.0
        this._movement = Vec3.create()

        this.up = Vec3.fromValues(0.0, 1.0, 0.0)
        this.right = Vec3.fromValues(1.0, 0.0, 0.0)
        this.forward = Vec3.fromValues(0.0, 0.0, 1.0)
        this.worldUp = Vec3.fromValues(0.0, 1.0, 0.0)
    }

    getView() {
        let mat: Mat4
        let center: Vec3

        Vec3.add(center, this.position, this.forward)
        Mat4.lookAt(mat, this.position, center, this.worldUp)
        return mat
    }

    getProjection() {
        let mat: Mat4
        Mat4.perspectiveZO(mat, this.fov, this.aspectRatio, this.nearPlane, this.farPlane)
        return mat
    }

    update(dt: number = 1.0) {
        let dir = Vec3.clone(this._movement)
        dir.scale(this.speed * dt)

        this.position.add(dir)
        this._movement = Vec3.fromValues(0,0,0)

        this._updateVectors()
    }

    move(direction: Vec3) {
        let rotateMat = Mat4.create()
        rotateMat.rotate(-this.yaw, Vec3.fromValues(0, 1, 0))

        let dir: Vec4
        Vec4.transformMat4(dir,
            Vec4.fromValues(direction[0], direction[1], direction[2], 1.0),
            rotateMat
        )
        dir[1] = -dir[1];

        this._movement.add(Vec3.fromValues(dir[0], dir[1], dir[2]))
    }

    onMouseMotion(dx: number, dy: number)
    {
        const _mouseSensitivity = 1.0

        this.yaw += dx * _mouseSensitivity;
        this.pitch += -dy * _mouseSensitivity;

        const epsilon = 0.001;

        this.pitch = clamp(this.pitch, -Math.PI/2 + epsilon, Math.PI/2 - epsilon);
    }

    _updateVectors() {
        this.forward[0] = Math.cos(this.yaw) * Math.cos(this.pitch);
        this.forward[1] = Math.sin(this.pitch);
        this.forward[2] = Math.sin(this.yaw) * Math.cos(this.pitch);

        this.forward.normalize()

        Vec3.cross(this.right, this.forward, this.worldUp)
        this.right.normalize()

        Vec3.cross(this.up, this.right, this.forward)
        this.up.normalize()
    }
}
