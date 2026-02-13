//
//  Extensions.swift
//  Paper Plane
//
//  Created by Cade Williams on 7/6/24.
//  Copyright © 2024 Cade Williams. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

extension UIViewController {
    
    static func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            UIApplication.shared.delegate?.window??.rootViewController?.present(alert, animated: true)
        }
    }
}


extension SKColor {
  convenience init(hex: Int, alpha: CGFloat = 1.0) {
    let red = CGFloat((hex >> 16) & 0xFF) / 255.0
    let green = CGFloat((hex >> 8) & 0xFF) / 255.0
    let blue = CGFloat(hex & 0xFF) / 255.0
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}


func rad2deg(number: Double) -> Double {
    return number * 180 / .pi
}

extension SKNode {
  func createLabelWithShadow(text: String,
                             fontName: String,
                             fontSize: CGFloat,
                             fontColor: SKColor,
                             shadowColor: SKColor,
                             position: CGPoint,
                             zPosiion: CGFloat,
                             alpha: CGFloat,
                             name: String) -> (main: SKLabelNode, shadow: SKLabelNode) {
    
    let mainLabel = SKLabelNode(fontNamed: fontName)
    mainLabel.text = text
    mainLabel.fontSize = fontSize
    mainLabel.fontColor = fontColor
    mainLabel.position = position
    mainLabel.zPosition = zPosiion
    mainLabel.alpha = alpha
    mainLabel.name = name
//    addChild(mainLabel) // if this is not added, add each node to the scene with addChild(node.main) and addChild(node.shadow)
    
    let shadowLabel = SKLabelNode(fontNamed: fontName)
    shadowLabel.text = text
    shadowLabel.fontSize = fontSize
    shadowLabel.fontColor = shadowColor
    shadowLabel.position = CGPoint(x: position.x, y: position.y - fontSize / 12)
    shadowLabel.zPosition = zPosiion - 1
    shadowLabel.alpha = alpha
//    addChild(shadowLabel)
    
    return (main: mainLabel, shadow: shadowLabel)
  }
}
  
  
//  extension SKNode {
//
//      // MARK: - Public Functions
//      
//      /// Creates a label with a shadow and adds it to the node.
//      @discardableResult // Prevents warning if the returned SKLabelNode isn't used
//      public func createLabelWithShadow(
//          text: String,
//          fontName: String,
//          fontSize: CGFloat,
//          fontColor: SKColor,
//          shadowColor: SKColor,
//          position: CGPoint,
//          zPosition: CGFloat,
//          alpha: CGFloat = 1.0,
//          name: String
//      ) -> SKLabelNode {
//          // This function just calls the private helper and returns its main label.
//          let labels = createAndAddLabels(
//              text: text, fontName: fontName, fontSize: fontSize,
//              fontColor: fontColor, shadowColor: shadowColor, position: position,
//              zPosition: zPosition, alpha: alpha, name: name
//          )
//          return labels.main
//      }
//
//      /// Creates a label with a shadow, adds it to the node, and also adds both labels to a provided container array.
//      @discardableResult
//      public func createLabelWithShadow(
//          text: String,
//          fontName: String,
//          fontSize: CGFloat,
//          fontColor: SKColor,
//          shadowColor: SKColor,
//          position: CGPoint,
//          zPosition: CGFloat,
//          alpha: CGFloat = 1.0,
//          name: String,
//          container: inout [SKNode] // The container is no longer optional
//      ) -> SKLabelNode {
//          // 1. Call the private helper to do the main work.
//          let labels = createAndAddLabels(
//              text: text, fontName: fontName, fontSize: fontSize,
//              fontColor: fontColor, shadowColor: shadowColor, position: position,
//              zPosition: zPosition, alpha: alpha, name: name
//          )
//          
//          // 2. Do the one extra step: add the results to the container.
//          container.append(labels.main)
//          container.append(labels.shadow)
//          
//          // 3. Return the main label.
//          return labels.main
//      }
//
//      // MARK: - Private Helper
//      
//      /// The private "workhorse" function. It creates, configures, and adds the labels to the scene graph.
//      /// It returns both created labels in a tuple.
//      private func createAndAddLabels(
//          text: String,
//          fontName: String,
//          fontSize: CGFloat,
//          fontColor: SKColor,
//          shadowColor: SKColor,
//          position: CGPoint,
//          zPosition: CGFloat,
//          alpha: CGFloat,
//          name: String
//      ) -> (main: SKLabelNode, shadow: SKLabelNode) {
//          
//          // --- Main Label ---
//          let mainLabel = SKLabelNode(fontNamed: fontName)
//          mainLabel.text = text
//          mainLabel.fontSize = fontSize
//          mainLabel.fontColor = fontColor
//          mainLabel.position = position
//          mainLabel.zPosition = zPosition
//          mainLabel.alpha = alpha
//          mainLabel.name = name
//          self.addChild(mainLabel)
//          
//          // --- Shadow Label ---
//          let shadowLabel = SKLabelNode(fontNamed: fontName)
//          shadowLabel.text = text
//          shadowLabel.fontSize = fontSize
//          shadowLabel.fontColor = shadowColor
//          shadowLabel.position = CGPoint(x: position.x, y: position.y - fontSize / 12)
//          shadowLabel.zPosition = zPosition - 1
//          shadowLabel.alpha = alpha
//          shadowLabel.name = "\(name)_shadow"
//          self.addChild(shadowLabel)
//          
//          return (main: mainLabel, shadow: shadowLabel)
//      }
//  }
  
