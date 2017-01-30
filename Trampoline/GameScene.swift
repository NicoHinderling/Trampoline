//
//  GameScene.swift
//  Trampoline
//
//  Created by Nicolas Hinderling on 1/26/17.
//  Copyright © 2017 Nicolas Hinderling. All rights reserved.
//

import SpriteKit

// Constants
let buttonPadding = CGFloat(10)
let buttonHeightWidth = CGFloat(100)
let buttonSize = CGSize(width: buttonHeightWidth, height: buttonHeightWidth)
let defaultY = buttonHeightWidth*0.5 + buttonPadding

enum direction {
    case left
    case right
}

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    let cam = SKCameraNode()
    let player = SKSpriteNode(imageNamed: "hero")
    let trampoline = SKSpriteNode(imageNamed: "trampoline")
    
    let leftButton = SKSpriteNode(imageNamed: "left-button")
    let rightButton = SKSpriteNode(imageNamed: "right-button")
    let jumpButton = SKSpriteNode(imageNamed: "jump-button")
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white

        self.camera = cam
        
        player.size = CGSize(width: player.size.width * 0.75, height: player.size.height * 0.75)

        player.position = CGPoint(x: 150, y: 400)
        player.physicsBody = SKPhysicsBody(texture: player.texture!,
                                               size: player.texture!.size())
        player.physicsBody?.usesPreciseCollisionDetection = true

        
        var splinePoints = [CGPoint(x: 0, y: 300),
//                           CGPoint(x: 200, y: 350),
//                           CGPoint(x: 400, y: 350),
                           CGPoint(x: 1000, y: 300)]
        
        
        let ground = SKShapeNode(splinePoints: &splinePoints,
                                 count: splinePoints.count)
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        ground.physicsBody?.isDynamic = false
        
        ground.strokeColor = SKColor.black
        

        
        addChild(player)
        addChild(ground)
        
        trampoline.position = CGPoint(x: 600, y: 300)
        addChild(trampoline)
        
        addControls()

        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
    }
    
    override func update(_ currentTime: TimeInterval) {
        cam.position = player.position
     
        let xDefaultFrame = cam.position.x - (self.frame.width * 0.5)
        let yDefaultFrame = cam.position.y - (self.frame.height * 0.5)
        
        leftButton.position = CGPoint(x: xDefaultFrame + buttonHeightWidth*0.5 + buttonPadding, y: yDefaultFrame + defaultY)
        rightButton.position = CGPoint(x: xDefaultFrame + buttonHeightWidth*1.5 + buttonPadding*2, y: yDefaultFrame + defaultY)
        jumpButton.position = CGPoint(x: xDefaultFrame + self.frame.maxX - (buttonHeightWidth*0.5 + buttonPadding), y: yDefaultFrame + defaultY)
    }
    
    
    
    
    func addControls() {
        let buttons = [leftButton, rightButton, jumpButton]
        buttons.forEach {
            $0.size = buttonSize
        }
        
        leftButton.position = CGPoint(x: buttonHeightWidth*0.5 + buttonPadding, y: defaultY)
        rightButton.position = CGPoint(x: buttonHeightWidth*1.5 + buttonPadding*2, y: defaultY)
        jumpButton.position = CGPoint(x: self.frame.maxX - (buttonHeightWidth*0.5 + buttonPadding), y: defaultY)
        
        self.addChild(leftButton)
        self.addChild(rightButton)
        self.addChild(jumpButton)
    }
    
    
    func moveHero(direction: direction?) {
        removeAction(forKey: "moving")
        let movement = SKAction.moveBy(x: (direction == .left ? -100 : 100), y: 0, duration: 1)
        player.run(SKAction.repeatForever(movement), withKey:  "moving")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        if leftButton.contains(touchLocation) {
            moveHero(direction: .left)
        } else if rightButton.contains(touchLocation) {
            moveHero(direction: .right)
        } else if jumpButton.contains(touchLocation) {
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
        }
    }
}
