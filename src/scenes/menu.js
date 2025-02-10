class Menu extends Phaser.Scene {
    constructor() {
        super("menuScene")
    }

    preload() {
        //load images and sprites
        this.load.image('grass', './assets/img/backgroundGrass.png')
        this.load.image('sky', './assets/img/backgroundSky.png')
    }

    create() {
        console.log("menuscene")
        this.scene.start("playScene")
    }

    update() {

    }
}