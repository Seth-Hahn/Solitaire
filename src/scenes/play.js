class Play extends Phaser.Scene {
    constructor() {
        super("playScene")
    }

    create() {
        console.log('playScene')

        //place tile sprite
        this.sky = this.add.tileSprite(0,0,640,480, 'sky').setOrigin(0,0)
        this.grass = this.add.tileSprite(0,0,640, 480, 'grass').setOrigin(0,0)
    }  

    update() {
        //moving sky background
        this.sky.tilePositionX -= 1
    }
}