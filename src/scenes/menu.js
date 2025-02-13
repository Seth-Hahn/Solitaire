class Menu extends Phaser.Scene {
    constructor() {
        super("menuScene")
    }

    preload() {
        //load images and sprites
        this.load.image('grass', './assets/img/backgroundGrass.png')
        this.load.image('sky', './assets/img/backgroundSky.png')
        this.load.image('road', './assets/img/backgroundRoad.png')
        this.load.image('bottle', './assets/img/collectibleBottle.png')
        this.load.image('butt', "./assets/img/collectibleButt.png" )
        this.load.image('hole', './assets/img/obstacleHole.png' )

        this.load.spritesheet('player', './assets/img/mapleManRunning.png', {
            frameWidth: 213,
            frameHeight: 240
        })
        //load sounds
        this.load.audio('left', './assets/mp3/left.mp3')
        this.load.audio('right', './assets/mp3/right.mp3')
        this.load.audio('jump', './assets/mp3/jump.mp3')
    }

    create() {
        //running animation
        this.anims.create( {
            key: 'run',
            frames: this.anims.generateFrameNumbers('player', {start: 0 , end: 1}),
            frameRate: 15,
            repeat: -1
            
        })

        //jumping animation
        this.anims.create( {
            key: 'jump',
            frames: [{key: 'player', frame: 2}],
            frameRate: 1,
            repeat: 0
        })

        this.scene.start("playScene")
    }

    update() {

    }
}