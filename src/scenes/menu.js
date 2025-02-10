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
    }

    create() {
        console.log("menuscene")
        this.scene.start("playScene")
    }

    update() {

    }
}