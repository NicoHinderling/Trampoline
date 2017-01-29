//
//  GameScene.swift
//  Trampoline
//
//  Created by Nicolas Hinderling on 1/26/17.
//  Copyright © 2017 Nicolas Hinderling. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "hero")
    let rightButton = SKSpriteNode(imageNamed: "right-button")
    
    var leftButtonPressed = false
    var rightButtonPressed = false
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.6)
        
        addChild(player)
        
        addControls()
        
        //        physicsWorld.gravity = CGVector.zero
        //        physicsWorld.contactDelegate = self
    }
    
    
    
    
    func addControls() {
        rightButton.position = CGPoint(x:self.frame.midX * 0.2, y:self.frame.midY * 0.2)
        
        self.addChild(rightButton)
        
        
    }
    
    func moveHero() {
        guard !(leftButtonPressed && rightButtonPressed) else { return }
        
        //        while (leftButtonPressed || rightButtonPressed) {
        if leftButtonPressed {
            print("smash the fuck outta that left button")
        } else {
            let actionMove = SKAction.move(to: CGPoint(x: player.position.x + size.width * 0.1, y: player.position.y), duration: TimeInterval(0.1))
            player.run(SKAction.sequence([actionMove]))
            moveHero()
        }
        
        //        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        if rightButton.contains(touchLocation) {
            print("Right button pressed!")
            rightButtonPressed = true
            moveHero()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        if rightButton.contains(touchLocation) {
            print("Right button no longer pressed.")
            rightButtonPressed = false
            moveHero()
        }
        
    }
}
