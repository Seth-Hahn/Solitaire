// Name : Seth Hahn
// Title: Maple Man Goes Green


let config = {
    type: Phaser.AUTO,
    width: 640,
    height: 480,
    scene: [Menu, Play],
    physics: {
        default: "arcade",
        arcade: {
            debug: false,
        }
    }
}

let game = new Phaser.Game(config)
