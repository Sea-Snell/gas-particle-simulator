//
//  GameScene.swift
//  gas simulation
//
//  Created by Charlie Snell on 1/29/16.
//  Copyright (c) 2016 sea_software. All rights reserved.
//

import SpriteKit

class GameScene: SKScene{
    var particles = [Particle]()
    var slider: NSSlider? = nil
    var kelvenTempLabel: NSTextField? = nil
    var avgKeniticEnergyLabel: NSTextField? = nil
    var preasureLabel: NSTextField? = nil
    var tempLabel: NSTextField? = nil
    var volumeTitleLabel: NSTextField? = nil
    var massTitleLabel: NSTextField? = nil
    var massLabel: NSTextField? = nil
    var volumeLabel: NSTextField? = nil
    var numParticlesLabel: NSTextField? = nil
    var particlesCount: NSTextField? = nil
    var slider2: NSSlider? = nil
    var slider3: NSSlider? = nil
    var slider4: NSSlider? = nil
    var numberParticles = 100
    var wall: SKShapeNode? = nil
    
    var lastSliderVal = 273.0
    var lastSlider2Val = 1000.0
    var lastSlider3Val = 32.0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.slider = NSSlider(frame: NSRect(x: self.frame.minX + 10, y: self.frame.maxY - 80, width: 1300, height: 50))
        
        self.slider?.minValue = 0.0
        self.slider?.maxValue = 1000.0
        self.slider?.continuous = true
        self.slider?.doubleValue = 273.0
        self.view?.addSubview(self.slider!)
        
        self.kelvenTempLabel = NSTextField(frame: NSRect(x: self.frame.minX + 1100, y: self.frame.maxY - 90, width: 200, height: 25))
        self.kelvenTempLabel!.editable = false
        self.kelvenTempLabel!.selectable = false
        self.kelvenTempLabel!.stringValue = String((self.slider?.doubleValue)!) + " K"
        self.kelvenTempLabel?.backgroundColor = NSColor.clearColor()
        self.kelvenTempLabel?.drawsBackground = false
        self.kelvenTempLabel?.bezeled = false
        self.view?.addSubview(self.kelvenTempLabel!)
        
        self.avgKeniticEnergyLabel = NSTextField(frame: NSRect(x: self.frame.minX + 1100, y: self.frame.maxY - 110, width: 200, height: 25))
        self.avgKeniticEnergyLabel!.editable = false
        self.avgKeniticEnergyLabel!.selectable = false
        self.avgKeniticEnergyLabel!.stringValue = String(self.calculateAverageKeniticEnergy(273.0, mass: CGFloat(32.0))) + " J avg"
        self.avgKeniticEnergyLabel?.backgroundColor = NSColor.clearColor()
        self.avgKeniticEnergyLabel?.drawsBackground = false
        self.avgKeniticEnergyLabel?.bezeled = false
        self.view?.addSubview(self.avgKeniticEnergyLabel!)
        
        self.tempLabel = NSTextField(frame: NSRect(x: self.frame.minX + 25, y: self.frame.maxY - 60, width: 200, height: 25))
        self.tempLabel!.editable = false
        self.tempLabel!.selectable = false
        self.tempLabel!.stringValue = "temperature:"
        self.tempLabel?.backgroundColor = NSColor.clearColor()
        self.tempLabel?.drawsBackground = false
        self.tempLabel?.bezeled = false
        self.view?.addSubview(self.tempLabel!)
        
        self.slider2 = NSSlider(frame: NSRect(x: self.frame.minX + 10, y: self.frame.maxY - 130, width: 1000, height: 50))
        
        self.slider2?.minValue = 10000.0
        self.slider2?.maxValue = Double(((self.frame.maxX - self.frame.minX)) * ((self.frame.maxY - self.frame.minY - 200.0)))
        self.slider2?.continuous = true
        self.slider2?.doubleValue = Double(((self.frame.maxX - self.frame.minX)) * ((self.frame.maxY - self.frame.minY - 200.0)))
        self.lastSlider2Val = (self.slider2?.doubleValue)!
        self.view?.addSubview(self.slider2!)
        
        self.preasureLabel = NSTextField(frame: NSRect(x: self.frame.minX + 1100, y: self.frame.maxY - 150, width: 200, height: 25))
        self.preasureLabel!.editable = false
        self.preasureLabel!.selectable = false
        self.preasureLabel!.stringValue = String(self.calculatePreasure(CGFloat((self.slider?.doubleValue)!), volume: (CGFloat((self.slider2?.doubleValue)!)))) + " nPa"
        self.preasureLabel?.backgroundColor = NSColor.clearColor()
        self.preasureLabel?.drawsBackground = false
        self.preasureLabel?.bezeled = false
        self.view?.addSubview(self.preasureLabel!)
        
        self.volumeLabel = NSTextField(frame: NSRect(x: self.frame.minX + 1100, y: self.frame.maxY - 130, width: 200, height: 25))
        self.volumeLabel!.editable = false
        self.volumeLabel!.selectable = false
        self.volumeLabel!.stringValue = String((self.slider2?.doubleValue)!) + " m^2"
        self.volumeLabel?.backgroundColor = NSColor.clearColor()
        self.volumeLabel?.drawsBackground = false
        self.volumeLabel?.bezeled = false
        self.view?.addSubview(self.volumeLabel!)
        
        
        self.volumeTitleLabel = NSTextField(frame: NSRect(x: self.frame.minX + 25, y: self.frame.maxY - 110, width: 200, height: 25))
        self.volumeTitleLabel!.editable = false
        self.volumeTitleLabel!.selectable = false
        self.volumeTitleLabel!.stringValue = "area:"
        self.volumeTitleLabel?.backgroundColor = NSColor.clearColor()
        self.volumeTitleLabel?.drawsBackground = false
        self.volumeTitleLabel?.bezeled = false
        self.view?.addSubview(self.volumeTitleLabel!)
        
        self.wall = SKShapeNode(rect: CGRect(x: self.frame.minX - 3, y: self.frame.minY + 100 - 3, width: self.frame.maxX - self.frame.minX + 3, height: (self.frame.maxY - 100) - (self.frame.minY + 100) + 3))
        self.wall?.fillColor = NSColor.clearColor()
        self.wall?.lineWidth = 3
        self.wall?.strokeColor = NSColor.blackColor()
        self.addChild(self.wall!)
        
        self.slider3 = NSSlider(frame: NSRect(x: self.frame.minX + 10, y: self.frame.maxY - 230, width: 1300, height: 50))
        
        self.slider3?.minValue = 1.0
        self.slider3?.maxValue = 200.0
        self.slider3?.continuous = true
        self.slider3?.doubleValue = 32.0
        
        self.view?.addSubview(self.slider3!)
        
        self.massTitleLabel = NSTextField(frame: NSRect(x: self.frame.minX + 25, y: self.frame.maxY - 210, width: 200, height: 25))
        self.massTitleLabel!.editable = false
        self.massTitleLabel!.selectable = false
        self.massTitleLabel!.stringValue = "mass:"
        self.massTitleLabel?.backgroundColor = NSColor.clearColor()
        self.massTitleLabel?.drawsBackground = false
        self.massTitleLabel?.bezeled = false
        self.view?.addSubview(self.massTitleLabel!)
        
        self.massLabel = NSTextField(frame: NSRect(x: self.frame.minX + 1100, y: self.frame.maxY - 170, width: 200, height: 25))
        self.massLabel!.editable = false
        self.massLabel!.selectable = false
        self.massLabel!.stringValue = String((self.slider3?.doubleValue)!) + " g/mol"
        self.massLabel?.backgroundColor = NSColor.clearColor()
        self.massLabel?.drawsBackground = false
        self.massLabel?.bezeled = false
        self.view?.addSubview(self.massLabel!)
        
        
        
        self.slider4 = NSSlider(frame: NSRect(x: self.frame.minX + 10, y: self.frame.maxY - 180, width: 1000, height: 50))
        
        self.slider4?.minValue = 1.0
        self.slider4?.maxValue = 150.0
        self.slider4?.continuous = false
        self.slider4?.doubleValue = 100.0
        self.view?.addSubview(self.slider4!)
        
        
        self.numParticlesLabel = NSTextField(frame: NSRect(x: self.frame.minX + 25, y: self.frame.maxY - 160, width: 200, height: 25))
        self.numParticlesLabel!.editable = false
        self.numParticlesLabel!.selectable = false
        self.numParticlesLabel!.stringValue = "number of particles:"
        self.numParticlesLabel?.backgroundColor = NSColor.clearColor()
        self.numParticlesLabel?.drawsBackground = false
        self.numParticlesLabel?.bezeled = false
        self.view?.addSubview(self.numParticlesLabel!)
        
        self.particlesCount = NSTextField(frame: NSRect(x: self.frame.minX + 1100, y: self.frame.maxY - 190, width: 200, height: 25))
        self.particlesCount!.editable = false
        self.particlesCount!.selectable = false
        self.particlesCount!.stringValue = String(self.numberParticles) + " particles"
        self.particlesCount?.backgroundColor = NSColor.clearColor()
        self.particlesCount?.drawsBackground = false
        self.particlesCount?.bezeled = false
        self.view?.addSubview(self.particlesCount!)
        
        
        
        for _ in 0..<numberParticles{
            let particle = Particle()
        
            self.addChild(particle)
            
            self.particles.append(particle)
            particle.ready()
            
        }
        
        self.calculateAverageKeniticEnergies(numberParticles, temperature: CGFloat(273), mass: CGFloat((self.slider3?.doubleValue)!))
    }
    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        for i in self.particles{
            i.update()
        }
        
        if self.slider?.doubleValue != 0.0{
            self.calculateCollisions()
        }
        
        if self.slider?.doubleValue != self.lastSliderVal{
            self.calculateAverageKeniticEnergies(self.numberParticles, temperature: CGFloat((self.slider?.doubleValue)!), mass: CGFloat((self.slider3?.doubleValue)!))
            self.kelvenTempLabel!.stringValue = String((self.slider?.doubleValue)!) + " K"
            self.avgKeniticEnergyLabel!.stringValue = String(self.calculateAverageKeniticEnergy(CGFloat((self.slider?.doubleValue)!), mass: CGFloat((self.slider3?.doubleValue)!))) + " J avg"
            self.preasureLabel!.stringValue = String(self.calculatePreasure(CGFloat((self.slider?.doubleValue)!), volume: (CGFloat((self.slider2?.doubleValue)!)))) + " nPa"
            self.lastSliderVal = (self.slider?.doubleValue)!
        }
        
        if self.slider2?.doubleValue != self.lastSlider2Val{
            
            
            self.preasureLabel!.stringValue = String(self.calculatePreasure(CGFloat((self.slider?.doubleValue)!), volume: (CGFloat((self.slider2?.doubleValue)!)))) + " nPa"
            self.volumeLabel!.stringValue = String((self.slider2?.doubleValue)!) + " m^2"
            let wallD = self.calculateWallDelta(CGFloat((self.slider2?.doubleValue)!))
            
            
            self.wall?.removeFromParent()
            let xVal = ((self.frame.minX) - wallD / 2.0) - (self.wall?.lineWidth)!
            
            let tempRect = CGRect(x: xVal, y: ((self.frame.minY + 100) - wallD / 2.0) - (self.wall?.lineWidth)!, width: ((self.frame.maxX + wallD / 2.0) - (self.frame.minX - wallD / 2.0)) + (self.wall?.lineWidth)!, height: (((self.frame.maxY - 100) + wallD / 2.0) - ((self.frame.minY + 100) - wallD / 2.0)) + (self.wall?.lineWidth)!)
            self.wall = SKShapeNode(rect: tempRect)
            self.wall?.fillColor = NSColor.clearColor()
            self.wall?.lineWidth = 3
            self.wall?.strokeColor = NSColor.blackColor()
            self.addChild(self.wall!)
            
            
            for i in self.particles{
                i.wallDelta = wallD
            }
            self.lastSlider2Val = (self.slider2?.doubleValue)!
        }
        
        if self.lastSlider3Val != self.slider3?.doubleValue{
            
            self.massLabel!.stringValue = String((self.slider3?.doubleValue)!) + " g/mol"
            
            for i in self.particles{
                i.mass = CGFloat((self.slider3?.doubleValue)!)
            }
            
            self.lastSlider3Val = (self.slider3?.doubleValue)!
        }
        
        if self.numberParticles != Int((self.slider4?.doubleValue)!){
            if Int((self.slider4?.doubleValue)!) < self.numberParticles{
                for _ in 0..<Int(abs(Int((self.slider4?.doubleValue)!) - self.numberParticles)){
                    self.particles[self.particles.count - 1].removeFromParent()
                    self.particles.removeLast()
                }
            }
            else{
                let wallD = self.calculateWallDelta(CGFloat((self.slider2?.doubleValue)!))
                for _ in 0..<Int(abs(Int((self.slider4?.doubleValue)!) - self.numberParticles)){
                    let particle = Particle()
                    
                    self.addChild(particle)
                    
                    self.particles.append(particle)
                    particle.ready()
                    
                    particle.mass = CGFloat((self.slider3?.doubleValue)!)
                    particle.wallDelta = wallD
                    
                    self.calculateAverageKeniticEnergies(self.numberParticles, temperature: CGFloat((self.slider?.doubleValue)!), mass: CGFloat((self.slider3?.doubleValue)!))
                }
            }
            
            self.numberParticles = Int((self.slider4?.doubleValue)!)
            
            self.preasureLabel!.stringValue = String(self.calculatePreasure(CGFloat((self.slider?.doubleValue)!), volume: (CGFloat((self.slider2?.doubleValue)!)))) + " nPa"
            
            self.particlesCount!.stringValue = String(self.numberParticles) + " particles"
        }
        
        for i in self.particles{
            i.calculateWallCollisions()
        }
    }
    
    func calculateAverageKeniticEnergies(numberParticles: Int, temperature: CGFloat, mass: CGFloat){
        let average = self.calculateAverageKeniticEnergy(temperature, mass: mass)
        
        if numberParticles % 2 == 1{
            self.particles[0].keniticEnergy = average
    
            for i in 1..<(self.particles.count + 1) / 2{
                let randomNumber = arc4random_uniform(UInt32(average))
                self.particles[i].keniticEnergy = CGFloat(randomNumber) + average
                self.particles[(self.particles.count - i)].keniticEnergy = -CGFloat(randomNumber) + average
            }
        }
        else{
            for i in 0..<(self.particles.count) / 2{
                let randomNumber = arc4random_uniform(UInt32(average))
                self.particles[i].keniticEnergy = CGFloat(randomNumber) + average
                self.particles[(self.particles.count - i) - 1].keniticEnergy = -CGFloat(randomNumber) + average
            }
        }
        
    }
    
    func calculateAverageKeniticEnergy(temperature: CGFloat, mass: CGFloat) -> CGFloat{
        let a = self.calculateAverageVelocity(temperature, mass: mass)
        return 0.5 * (mass / 1000.0) * a * a
    }
    
    func calculateAverageVelocity(temperature: CGFloat, mass: CGFloat) -> CGFloat{
        return sqrt((3.0 * 8.314472 * temperature) / (mass / 1000.0))
    }
    
    func calculateCollisions(){
        for i in 0..<self.particles.count{
            for x in i + 1..<self.particles.count{
                let distance = sqrt(pow((self.particles[i].position.x - self.particles[x].position.x), 2.0) + pow((self.particles[i].position.y - self.particles[x].position.y), 2.0))
                if distance <= self.particles[i].size.width{
                    if particles[i].keniticEnergy < particles[x].keniticEnergy{
                        let deltaDist = abs(distance - self.particles[i].size.width)
                
                        self.particles[i].position.x -= self.particles[i].deltaX * deltaDist * 1.1
                        self.particles[i].position.y -= self.particles[i].deltaY * deltaDist * 1.1
                    }
                    else{
                        let deltaDist = abs(distance - self.particles[x].size.width)
                            
                        self.particles[x].position.x -= self.particles[x].deltaX * deltaDist * 1.1
                        self.particles[x].position.y -= self.particles[x].deltaY * deltaDist * 1.1
                    }
                    
                    self.handleCollision(self.particles[i], spriteB: self.particles[x])
                }
            }
        }
    }
    
    func handleCollision(spriteA: Particle, spriteB: Particle){
        var nX = spriteA.position.x - spriteB.position.x
        var nY = spriteA.position.y - spriteB.position.y
        
        let length = sqrt(nX * nX + nY * nY)
        
        if length == 0{
            nX = 0.0
            nY = 0.0
        }
        else{
            nX /= length
            nY /= length
        }
        
        let dot1 = spriteA.deltaX * spriteA.calculateVelocity() * nX + spriteA.deltaY * spriteA.calculateVelocity() * nY
        let dot2 = spriteB.deltaX * spriteB.calculateVelocity() * nX + spriteB.deltaY * spriteB.calculateVelocity() * nY
        
        let optomized = (2.0 * (dot1 - dot2)) / 2
        
        var newAVecX = spriteA.deltaX * spriteA.calculateVelocity() - optomized * nX
        var newAVecY = spriteA.deltaY * spriteA.calculateVelocity() - optomized * nY
        
        var newBVecX = spriteB.deltaX * spriteB.calculateVelocity() - optomized * nX
        var newBVecY = spriteB.deltaY * spriteB.calculateVelocity() - optomized * nY
        
        if sqrt(newAVecX * newAVecX + newAVecY * newAVecY) == 0{
            newAVecX = 0.0
            newAVecY = 0.0
        }
        else{
            newAVecX /= sqrt(newAVecX * newAVecX + newAVecY * newAVecY)
            newAVecY /= sqrt(newAVecX * newAVecX + newAVecY * newAVecY)
        }
        
        if sqrt(newBVecX * newBVecX + newBVecY * newBVecY) == 0{
            newBVecX = 0.0
            newBVecY = 0.0
        }
        else{
            newBVecX /= sqrt(newBVecX * newBVecX + newBVecY * newBVecY)
            newBVecY /= sqrt(newBVecX * newBVecX + newBVecY * newBVecY)
        }
        
        
        spriteA.deltaX = newAVecX
        spriteA.deltaY = newAVecY
        
        spriteB.deltaX = newBVecX
        spriteB.deltaY = newBVecY
        
        
        if spriteA.keniticEnergy > spriteB.keniticEnergy{
            let temp = (spriteA.keniticEnergy - spriteB.keniticEnergy) * 0.8
            
            spriteA.keniticEnergy -= temp
            spriteB.keniticEnergy += temp
        }
        else{
            let temp = (spriteB.keniticEnergy - spriteA.keniticEnergy) * 0.8
            
            spriteB.keniticEnergy -= temp
            spriteA.keniticEnergy += temp
        }
    }
    
    func calculatePreasure(temp: CGFloat, volume: CGFloat) -> CGFloat{
        return ((8.314472 * temp * (CGFloat(self.numberParticles) / CGFloat(602000000000000000000000.0))) / (volume * 1000)) * 1000000000000
    }
    
    func calculateWallDelta(volume: CGFloat) -> CGFloat{
        let side1 = self.frame.maxX - self.frame.minX
        let side2 = (self.frame.maxY - 100) - (self.frame.minY + 100)
        return ((side1 + side2) - sqrt((side1 + side2) * (side1 + side2) - (4 * (-1) * ((volume) - (side1 * side2))))) / -2.0
    }
}
