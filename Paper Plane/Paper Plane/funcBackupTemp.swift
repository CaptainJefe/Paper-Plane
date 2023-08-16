////
////  funcBackupTemp.swift
////  Paper Plane
////
////  Created by Cade Williams on 8/15/23.
////  Copyright © 2023 Cade Williams. All rights reserved.
////
//
//@objc func planeMode() {
//    let currentLocationX = plane.position.x
//    let currentLocationY = plane.position.y
//
//    let moveDown = SKAction.moveTo(y: currentLocationY - 1500, duration: 40)
//    let repeatDown = SKAction.repeatForever(moveDown)
//
//    let moveLeft = SKAction.moveTo(x: currentLocationX - 1212.5, duration: 40) // old x value was (x: -1025)
////        let leftSeq = SKAction.sequence([moveLeft, moveDown])
//    let repeatLeft = SKAction.repeatForever(moveLeft)
//
//    let moveRight = SKAction.moveTo(x: currentLocationX + 1212.5, duration: 40) // old x value was (x: 1400)
//    let repeatRight = SKAction.repeatForever(moveRight)
//
//    let keepXPosition = SKAction.moveTo(x: currentLocationX, duration: 40)
//    let repeatXPosition = SKAction.repeatForever(keepXPosition)
//    
//
////        if mode == 4 {
////            plane.isPaused = true
////        } else {
////            plane.isPaused = false
////        }
//
//    switch mode {
//    case 0:
//        plane.texture = SKTexture(imageNamed: "Plane 1")
//        plane.speed = 7
//        plane.run(repeatLeft)
//        plane.run(repeatDown)
//
//    case 1:
//        plane.texture = SKTexture(imageNamed: "Plane 2")
//        plane.speed = 5
//        plane.run(repeatLeft)
//        plane.run(repeatDown)
//
//    case 2:
//        plane.texture = SKTexture(imageNamed: "Plane 3")
//        plane.speed = 3
//        plane.run(repeatLeft)
//        plane.run(repeatDown)
//
//    case 3:
//        plane.texture = SKTexture(imageNamed: "Plane 4")
//        plane.speed = 1
//        plane.run(repeatLeft)
//        plane.run(repeatDown)
//
//    case 4:
//        plane.texture = SKTexture(imageNamed: "Plane 5")
//        //            let move = SKAction.moveBy(x: 0, y: 0, duration: 40)
//        //            let loop = SKAction.repeatForever(move)
//        //            plane.run(loop)
//        plane.run(repeatXPosition) // redundant?
//        plane.run(repeatDown)
//
//    case 5:
//        plane.texture = SKTexture(imageNamed: "Plane 6")
//        plane.speed = 4
//        plane.run(repeatRight)
//        plane.run(repeatDown)
//
//    case 6:
//        plane.texture = SKTexture(imageNamed: "Plane 7")
//        plane.speed = 5
//        plane.run(repeatRight)
//        plane.run(repeatDown)
//
//    case 7:
//        plane.texture = SKTexture(imageNamed: "Plane 8")
//        plane.speed = 6
//        plane.run(repeatRight)
//        plane.run(repeatDown)
//
//    case 8:
//        plane.texture = SKTexture(imageNamed: "Plane 9")
//        plane.speed = 8
//        plane.run(repeatRight)
//        plane.run(repeatDown)
//
//    default:
//        break
//    }
//}
