<script>
    import { onMount } from "svelte";

    function randRange(min, max) { // min and max included
        return (Math.random() * (max - min) + min)
    }

    class Vector {
        constructor(x=0, y=0) {
            this.x = x
            this.y = y
        }

        static add(other) {
            return new Vector(this.x + other.x, this.y + other.y)
        }

        static sub(other) {
            return new Vector(this.x - other.x, this.y - other.y)
        }

        static mul(scalar) {
            return new Vector(this.x * scalar, this.y * scalar)
        }

        static div(scalar) {
            return new Vector(this.x / scalar, this.y / scalar)
        }

        static distance(v1, v2) {
            const dx = x2 - x1
            const dy = y2 - y1
            return Math.sqrt(dx*dx + dy*dy)
        }

        static distance2(x1, y1, x2, y2) {
            const dx = x2 - x1
            const dy = y2 - y1
            return dx*dx + dy*dy
        }

        add(other) {
            this.x += other.x
            this.y += other.y
        }

        sub(other) {
            this.x -= other.x
            this.y -= other.y
        }

        mul(scalar) {
            this.x *= scalar
            this.y *= scalar
        }

        div(scalar) {
            this.x /= scalar
            this.y /= scalar
        }

        length() {
            return Math.sqrt(this.x*this.x + this.y*this.y)
        }

        normalize() {
            return this.div( this.length() )
        }
    }

    class Letter {
        constructor(letter, x, y, vx=0, vy=0, rot=0, rot_vel=0) {
            this.element = document.createElement('span')
            this.element.innerHTML = letter
            this.element.style.position = 'fixed' // prevents parent from resizing
            this.element.style.left = '0px'
            this.element.style.top = '0px'
            this.element.style.fontSize = 'calc(1.25rem + 0.50rem)'
            // this.element.style.transform = 'rotate(90deg)'

            document.body.appendChild(this.element)

            this.letter = letter
            this.pos = new Vector(x, y)
            this.vel = new Vector(vx, vy)
            this.rot = rot
            this.rot_vel = rot_vel
        }

        update() {
            this.element.style.left = `${this.pos.x}px`
            this.element.style.top = `${this.pos.y}px`
        }
    }

    let intervalID;
    let inputField;

    const waitingLettersIn = []
    const waitingLettersOut = []
    const physicLetters = []

    let timerLetterLaunch = 0
    const timerLetterLaunchDelay = 0

    const loop = () => {
        if (!inputField) return;

        const rect = inputField.getBoundingClientRect()

        if (--timerLetterLaunch <= 0) {
            timerLetterLaunch = timerLetterLaunchDelay

            if (waitingLettersOut.length > 0) {
                physicLetters.push(
                    new Letter(
                        waitingLettersOut.pop(),
                        rect.x + rect.width - 2,
                        rect.y - 4,
                        randRange(2, 6),
                        randRange(0, -6)
                    )
                )
            }
        }


        // simulate
        const gravity = 0.2
        for (const letter of physicLetters) {
            letter.vel.y += gravity

            letter.pos.add(letter.vel)
            letter.rot += letter.rot_vel
        }

        // remove letter out of screen
        for (let i = physicLetters.length - 1 ; i >= 0 ; --i) {
            if (physicLetters[i].pos.x < -50 ||
                physicLetters[i].pos.x > document.body.clientWidth + 50 ||
                physicLetters[i].pos.y < -50 ||
                physicLetters[i].pos.y > document.body.clientHeight + 50
            ) {
                physicLetters[i].element.remove() // TODO: make the element remove itself on destroy
                physicLetters.splice(i, 1)
            }
        }

        // ctx.clearRect(0, 0, canvas.width, canvas.height)

        for (const letter of physicLetters) {
            letter.update()
        }
    }

    onMount(() => {
        inputField.onkeydown = (e) => {
        // e.preventDefault()

        const start = e.target.selectionStart;
        const end = e.target.selectionEnd;

        const newLetters = []

        // if deleting letters
        if (e.code === 'Backspace') {
            if (start === 0 && end === 0) return

            // add letters of selection to newLetters
            newLetters.push(
                ...e.target.value.substring(start - 1, end).split('')
            )
        } else {
            // console.log(e.key)
        }

        // spawn deleted letter(s)
        for (const letter of newLetters) {
            waitingLettersOut.push(letter)
        }
    }
        clearInterval(intervalID);
        intervalID = setInterval(loop, 1000.0 / 60.0)
    })

</script>

<main class="m-0 w-screen h-screen bg-neutral-400 overflow-hidden">
    <div class="absolute left-[10%] top-[15%]">
        <input class="text-xl" bind:this={inputField} type="text" maxlength="128">
    </div>
</main>
