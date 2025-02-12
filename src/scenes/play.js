class Play extends Phaser.Scene {
    constructor() {
        super("playScene")
    }

    create() {
        console.log('playScene')

        //place tile sprite
        this.sky = this.add.tileSprite(0,0,640,480, 'sky').setOrigin(0,0)
        this.grass = this.add.tileSprite(0,0,640, 480, 'grass').setOrigin(0,0)
        this.road = this.add.tileSprite(0,0,640, 480, 'road').setOrigin(0 ,0)
        
        this.sky.depth = 3
        this.road.depth = 2

        //grabbable items
        //this.bottle01 = new Collectible(this, game.config.width / 4, game.config.height / 2, 'bottle')
        //this.butt01 = new Collectible(this, game.config.width / 1.35 , game.config.height / 2, 'butt')

        //create the queue for storing obstacles
        this.obstacleQueue = []
        this.currentObstacle = null

        this.iterations = 5 //determines length of obstacle sequence
        this.missedCount = 0 //determines how many objects have been missed
        this.isGameOver = false

        //Hitboxes that determine obstacle overlap with player input
        this.leftHitbox = this.physics.add.sprite(game.config.width / 4, game.config.height / 1.3, null).setVisible(false).setSize(100, 50)
        this.rightHitbox = this.physics.add.sprite(game.config.width / 1.35, game.config.height / 1.3, null).setVisible(false).setSize(100, 50)
        this.middleHitbox = this.physics.add.sprite(game.config.width / 2, game.config.height / 1.2, null).setVisible(true).setSize(100, 50).setDepth(20)

        this.spawnObstacle()

        //define keys for gameplay
        this.keyGrabLeft = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.A)
        this.keyGrabRight = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.D)
        this.keyJump = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.SPACE)

    }  

    update() {
        //moving sky background
        this.sky.tilePositionX -= 1
        this.road.tilePositionY -= 3

        //listen for key presses
        if(Phaser.Input.Keyboard.JustDown(this.keyGrabLeft)) {
            this.activateHitbox('left')
        } else if (Phaser.Input.Keyboard.JustDown(this.keyGrabRight)) {
            this.activateHitbox('right')
        } else if (Phaser.Input.Keyboard.JustDown(this.keyJump)) {
            this.jumpOver()
        }

    }

    spawnObstacle() {
        if(this.isGameOver) {
            return
        }

        //randomly select obstacle types
        let types = ['left', 'right', 'middle']
        let type = Phaser.Math.RND.pick(types)

        let obstacle

        switch ((type)) { //add proper obstacle based on random selection
            case 'left':
                obstacle = this.physics.add.sprite(game.config.width / 4, game.config.height / 2, 'bottle')
                console.log('bottle')
                break
        
            case 'right':
                obstacle = this.physics.add.sprite(game.config.width / 1.35 , game.config.height / 2, 'butt')
                console.log('butt')
                break
            
            case 'middle':
                console.log('hole')
                obstacle = this.physics.add.sprite(game.config.width / 2, game.config.height / 2, 'hole' ).setDepth(20)
                break
        }

        obstacle.body.setVelocityY(this.speed) //set falling speed for obstacle
        obstacle.type = type

        this.physics.add.overlap(obstacle, this.leftHitbox, () => this.handleHit(obstacle, 'left'))
        this.physics.add.overlap(obstacle, this.rightHitbox, () => this.handleHit(obstacle, 'right'))
        this.physics.add.overlap(obstacle, this.middleHitbox, () => this.handleMiddleHit(obstacle))

        this.obstacleQueue.push(obstacle)

        //schedule next obstacle
        this.time.delayedCall(1000 - this.speed, this.spawnObstacle, [], this)

    }
       
    activateHitbox(side) {
        if(this.isGameOver) return

        if(side === 'left') {
            this.leftHitbox.setActive(true).setVisible(true)
            this.time.delayedCall(200, () => this.leftHitbox.setActive(false).setVisible(false), [], this)
        } else if (side === 'right') {
            this.rightHitbox.setActive(true).setVisible(true)
            this.time.delayedCall(200, () => this.rightHitbox.setActive(false).setVisible(false), [], this)
        }

        console.log('hitbox activated')
    }

    jumpOver() {
        if (this.isGameOver) return

        this.middleHitbox.setActive(false).setVisible(false)
        this.time.delayedCall(500, () => this.middleHitbox.setActive(true).setVisible(true), [], this)

    }

    handleHit(obstacle, side) {
        if(obstacle.type === side) {
            obstacle.destroy()
            this.obstacleQueue.shift()
            this.speed = Math.max(this.speed + 5, 500)
            this.iterations++
        }
    }

    handleMiddleHit(obstacle) {
        if(this.middleHitbox.active) {
            this.isGameOver = true
            console.log('gameover')
        }
    }
}

