class Collectible extends Phaser.GameObjects.Sprite {
    constructor(scene, x, y, texture) {
        super(scene, x, y, texture)
        scene.add.existing(this) //add object to the scene
        console.log('bottle constructed')
    }

    update() {
        this.y -= 2
    }
}