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
        
        this.sky.depth = 4
        this.road.depth = 2

        //grabbable items
        //this.bottle01 = new Collectible(this, game.config.width / 4, game.config.height / 2, 'bottle')
        //this.butt01 = new Collectible(this, game.config.width / 1.35 , game.config.height / 2, 'butt')

        //create the queue for storing obstacles
        this.obstacleQueue = []
        this.currentObstacle = null

        this.iterations = 5 //determines length of obstacle sequence
        this.missedCount = 0 //determines how many objects have been missed
        this.speed = 100 //speed of falling obstacles
        this.isGameOver = false

        //Hitboxes that determine obstacle overlap with player input
        this.leftHitbox = this.physics.add.sprite(game.config.width / 4, game.config.height / 1.3, null).setVisible(false)
        this.leftHitbox.body.enable = false
        this.rightHitbox = this.physics.add.sprite(game.config.width / 1.35, game.config.height / 1.3, null).setVisible(false)
        this.rightHitbox.body.enable = false
        this.middleHitbox = this.physics.add.sprite(game.config.width / 2, game.config.height / 1.2, null).setVisible(true).setDepth(20)
        this.middleHitbox.body.enable = true

        this.spawnObstacle()

        //define keys for gameplay
        this.keyGrabLeft = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.A)
        this.keyGrabRight = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.D)
        this.keyJump = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.SPACE)

        //display score
        let scoreConfig = {
            fontFamily: 'Courier',
            fontSize: '20px',
            backgroundColor: '#046307',
            color: '#FFFFFF',
            align: 'right',
            padding: {
            top: 5,
            bottom: 5,
            },
        } 
        this.score = 0 //based on pieces of trash collected
        this.scoreLeft = this.add.text(game.config.width / 40 , game.config.height / 40, `Litter Collected: ${this.score}`, scoreConfig).setDepth(50)

        //put player in field
        this.player = this.add.sprite(game.config.width / 2, game.config.height / 1.2, 'player').setDepth(10).setScale(0.5)

        this.player.anims.play('run')
    }  

    update() {
        if(this.isGameOver) {
            this.GameOver()
            if(Phaser.Input.Keyboard.JustDown(this.keyGrabLeft)) {
                this.scene.restart()
            }
            if(Phaser.Input.Keyboard.JustDown(this.keyGrabRight)) {
                // go to menu
            }
        }
        //moving sky background
        this.sky.tilePositionX -= 1
        this.road.tilePositionY -= this.speed / 100

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

        let delayBetweenObstacles = 1000
        for(let i = 0; i < this.iterations; i ++) {
            this.time.delayedCall(i * delayBetweenObstacles, () => { //delay spawns between obstacles
                let types = ['left', 'right', 'middle']
                let type = Phaser.Math.RND.pick(types)

                let obstacle

                switch ((type)) { //add proper obstacle based on random selection
                    case 'left':
                        obstacle = this.physics.add.sprite(game.config.width / 4, game.config.height / 3, 'bottle')
                        this.sound.play('left')
                        break
                
                    case 'right':
                        obstacle = this.physics.add.sprite(game.config.width / 1.35 , game.config.height / 3, 'butt')
                        this.sound.play('right')
                        break
                    
                    case 'middle':
                        console.log('hole')
                        obstacle = this.physics.add.sprite(game.config.width / 2, game.config.height / 3, 'hole' ).setDepth(3).setScale(.5)
                        this.sound.play('jump')
                        break
                }

                obstacle.body.setVelocityY(this.speed) //set falling speed for obstacle
                obstacle.type = type

                //delete objects which pass the bottom of the screen
                this.time.addEvent( {
                    delay: 3000,
                    callback: () => {
                        if(obstacle.y > this.game.config.height) {
                            this.handleMissedObstacle(obstacle)
                        }
                    },
                    loop: false
                })

                this.physics.add.overlap(obstacle, this.leftHitbox, () => this.handleHit(obstacle, 'left'))
                this.physics.add.overlap(obstacle, this.rightHitbox, () => this.handleHit(obstacle, 'right'))
                this.physics.add.overlap(obstacle, this.middleHitbox, () => this.handleMiddleHit(obstacle))

                this.obstacleQueue.push(obstacle)
            })
        }
        //schedule next obstacle
        this.iterations++
        this.speed = Math.min(this.speed + 10, 500)
        delayBetweenObstacles-= 20
        this.time.delayedCall(10000 - this.speed, this.spawnObstacle, [], this)

    }
       
    activateHitbox(side) {
        if(this.isGameOver) return

        if(side === 'left') {
            this.leftHitbox.setVisible(true)
            this.leftHitbox.body.enable = true
            this.time.delayedCall(200, () =>  {
                this.leftHitbox.setVisible(false) 
                this.leftHitbox.body.enable = false
            }, [], this)
        } else if (side === 'right') {
            this.rightHitbox.setVisible(true)
            this.rightHitbox.body.enable = true
            this.time.delayedCall(200, () => {
                this.rightHitbox.setVisible(false)
                this.rightHitbox.body.enable = false
            }, [], this)
        }

        console.log('hitbox activated')
    }

    jumpOver() {
        if (this.isGameOver) return

        this.middleHitbox.setVisible(false)
        this.middleHitbox.body.enable = false
        this.time.delayedCall(850, () => {
            this.middleHitbox.setVisible(true)
            this.middleHitbox.body.enable = true
        }, [], this)

    }

    handleHit(obstacle, side) {
        if(obstacle.type === side) {
            obstacle.destroy()
            this.obstacleQueue.shift()
            this.score++
            this.scoreLeft.text = `Litter Collected: ${this.score}`
        }
    }

    handleMiddleHit(obstacle) {
        if(this.middleHitbox.active) {
            this.isGameOver = true
            console.log('gameover')
        }
    }

    handleMissedObstacle(obstacle) {
        if(obstacle.type !== 'middle') {
            this.missedCount++
            console.log('missed!')
        }

        if(this.missedCount >= 3) {
            this.isGameOver = true
            console.log('gameover')
        }

        obstacle.destroy()
    }

    GameOver() {
        let gameOverConfig = {
            fontFamily: 'Courier',
            fontSize: '20px',
            backgroundColor: '#046307',
            color: '#FFFFFF',
            align: 'right',
            padding: {
            top: 5,
            bottom: 5,
            },
        } 
        this.add.text(game.config.width/2, game.config.height/2, 'GAME OVER', gameOverConfig).setOrigin(0.5).setDepth(50)
        this.add.text(game.config.width/2, game.config.height/2 + 64, 'Press (A) to Restart or (D) for Menu', gameOverConfig).setOrigin(0.5).setDepth(50)
    }
}
