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
        this.bottle01 = new Collectible(this, game.config.width / 4, game.config.height / 2, 'bottle')
        this.butt01 = new Collectible(this, game.config.width / 1.35 , game.config.height / 2, 'butt')
    }  

    update() {
        //moving sky background
        this.sky.tilePositionX -= 1
        this.road.tilePositionY -= 3

    }
}