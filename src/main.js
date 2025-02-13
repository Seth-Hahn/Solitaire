// Name : Seth Hahn
// Title: Maple Man Goes Green
// Hours Working: 15
//creative tilt :  
// TECHNICAL - my spawnobstacle function in play.js
// uses multiple delay calls as well as recursion to 
// create an infinite obstacle course which gets 
// randomly generated and increases in speed and difficulty
// overtime.
//
// VISUAL / ART - Besides having created all the art assets
// myself in photoshop. I am particularly proud of how a 
// randomly generated "beat" is formed through the various
// sound effects. As a pseudo-rythym game alongside being an
// endless runner, I found it important to have the music
// be made in real time (besides the background music).
//
//
//
//
//
//
//


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
