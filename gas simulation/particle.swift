//
//  particle.swift
//  gas simulation
//
//  Created by Charlie Snell on 1/29/16.
//  Copyright © 2016 sea_software. All rights reserved.
//

import Foundation
import SpriteKit

class Particle: SKSpriteNode{
    var deltaX: CGFloat
    var deltaY: CGFloat
    var keniticEnergy: CGFloat
    var mass: CGFloat
    var wallDelta: CGFloat

    init(){
        
        self.deltaX = 0.0
        self.deltaY = 0.0
        self.keniticEnergy = 0.0
        self.mass = 0.0
        self.wallDelta = 0.0
        
        
        let texture = SKTexture(imageNamed: "particle")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        
        self.randomizeDirection()
        
        self.size.width = 10
        self.size.height = 10
        self.anchorPoint.x = 0.5
        self.anchorPoint.y = 0.5
        self.mass = 32.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func ready(){
        self.position.x = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * ((self.parent?.frame.maxX)! - (self.parent?.frame.minX)!) + (self.parent?.frame.minX)!
        self.position.y = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * ((self.parent?.frame.maxY)! - (self.parent?.frame.minY)!) + (self.parent?.frame.minY)!
    }
    
    func randomizeDirection(){
        self.deltaX = sqrt(CGFloat(Float(arc4random()) / Float(UINT32_MAX)))
        if CGFloat(Float(arc4random()) / Float(UINT32_MAX)) >= 0.5{
            self.deltaX *= -1
        }
        self.deltaY = sqrt(1.0 - self.deltaX * self.deltaX)
        if CGFloat(Float(arc4random()) / Float(UINT32_MAX)) >= 0.5{
            self.deltaY *= -1
        }
        
    }
    
    func calculateWallCollisions(){
        let boolC = self.position.x - ((self.parent?.frame.minX)! - (self.wallDelta / 2.0)) <= self.size.width / 2.0
        let boolD = ((self.parent?.frame.maxX)! + (self.wallDelta / 2.0)) - self.position.x <= self.size.width / 2.0
        if boolC || boolD{
            self.deltaX *= -1
            
            if boolC{
                self.position.x = ((self.parent?.frame.minX)! - (self.wallDelta / 2.0)) + 6
            }
            else{
                self.position.x = ((self.parent?.frame.maxX)! + (self.wallDelta / 2.0)) - 6
            }
        }
        let ptA = ((self.parent?.frame.minY)! + 100)
        let ptB = ((self.parent?.frame.maxY)! - 100)
        let boolA = self.position.y - (ptA - (self.wallDelta / 2.0)) <= self.size.width / 2.0
        let boolB = (ptB + (self.wallDelta / 2.0)) - self.position.y <= self.size.width / 2.0
        if boolA || boolB{
            self.deltaY *= -1
            
            if boolA{
                self.position.y = (((self.parent?.frame.minY)! + 100) - (self.wallDelta / 2.0)) + 6
            }
            else{
                self.position.y = (((self.parent?.frame.maxY)! - 100) + (self.wallDelta / 2.0)) - 6
            }
        }
    }
    
    func calculateVelocity() -> CGFloat{
        return sqrt((self.keniticEnergy * 2) / (mass / 1000.0))
    }
    
    func update(){
        self.position.x += ((self.deltaX * self.calculateVelocity()) / 60.0)
        self.position.y += ((self.deltaY * self.calculateVelocity()) / 60.0)
        self.calculateWallCollisions()
    }
}