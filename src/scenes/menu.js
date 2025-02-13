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
        this.load.image('comic', './assets/img/mapleManComic.png')
        this.load.image('title', './assets/img/mapleManCover.png')
        this.load.spritesheet('player', './assets/img/mapleManRunning.png', {
            frameWidth: 213,
            frameHeight: 240
        })

        this.load.spritesheet('playerGrab', './assets/img/mapleManGrab.png', {
            frameWidth: 640,
            frameHeight : 480
        })
        //load sounds
        this.load.audio('left', './assets/mp3/left.mp3')
        this.load.audio('right', './assets/mp3/right.mp3')
        this.load.audio('jump', './assets/mp3/jump.mp3')
        this.load.audio('grab', './assets/mp3/grab.mp3')
        this.load.audio('BGM', './assets/mp3/Embrace.mp3')
    }

    create() {

        //looping music
        this.music = this.sound.add('BGM', {loop: true})
        this.music.setVolume(0.3)
        this.music.play()
        //start button
        this.startKey = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.SPACE)
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

        //grabbing animations
        this.anims.create( {
            key: 'grableft',
            frames: [{key: 'playerGrab', frame: 0}],
            frameRate: 1,
            repeat: 0
        })

        this.anims.create( {
            key: 'grabRight',
            frames: [{key: 'playerGrab', frame: 1}],
            frameRate: 1,
            repeat: 0
        })

        //add opening comic to scene
        if(!this.registry.get("comicPlayed")) {
            this.registry.set("comicPlayed", true)
            this.comic = this.add.image(0,0, 'comic').setOrigin(0, 0)

            //screen dimensions to get comic panel sizing
            let screenWidth = this.game.config.width
            let screenHeight = this.game.config.height

            //panel sizes
            let panelWidth = screenWidth / 3
            let panelHeight = screenHeight / 2
            
            // Create 5 rectangles covering panels 2-6
            this.rectangles = [
                0, //this value does nothing but help sequence the panel deletion later on 
                this.add.rectangle(panelWidth * 1.5, panelHeight * .5, panelWidth, panelHeight, 0x000000),  // Panel 2
                this.add.rectangle(panelWidth * 2.5, panelHeight * .5, panelWidth, panelHeight, 0x000000),  // Panel 3
                this.add.rectangle(panelWidth * .5, panelHeight * 1.5, panelWidth, panelHeight, 0x000000),  // Panel 4
                this.add.rectangle(panelWidth * 1.5 , panelHeight * 1.5 , panelWidth, panelHeight, 0x000000),  // Panel 5
                this.add.rectangle(panelWidth * 2.5, panelHeight * 1.5, panelWidth, panelHeight, 0x000000)   // Panel 6
            ];

            for(let i = 1; i <= 5; i++) {
                this.time.delayedCall(i * 3000, () => 
                {
                    this.rectangles[i].destroy()
                }) 
            }
            this.time.delayedCall(18000, () => { //show title screen
            
                this.add.image(0,0, 'title').setOrigin(0, 0)

            })
        } else {
            this.add.image(0,0, 'title').setOrigin(0, 0)
        }
    }




    update() {

        if(Phaser.Input.Keyboard.JustDown(this.startKey)) {
            this.scene.start("playScene")
        }

    }
}