//
//  Temp Test Code.swift
//  PlaneTest
//
//  Created by Cade Williams on 9/25/22.
//  Copyright © 2022 Cade Williams. All rights reserved.
//

//import Foundation
//
//class TestCode {
//    
//    // reference and trial and error
//    func waitOnPlatforms() {
//        print("platformCount = \(platformCount)")
//        print("waitOnPlatforms Called")
//        if platformCount > 0 {
//            let platformTrigger = platformArray.filter { $0.position.y < (frame.height / 2) } // Dont care about duplicate position platforms
////            let platformTrigger = filteredPlatforms.filter{ $0.position.y < (frame.height / 4) } // Get highest current platform below the desired platform spacing ((frame.height / 4))
//            print("count is \(platformArray.count)")
//            
//            print("platformTrigger: \(platformTrigger.count)")
//            if platformTrigger.count > 0 {
//                print("count is > 0")
//                let topPlatform = platformTrigger.sorted(by: { $0.position.y > $1.position.y})[0]
//                DispatchQueue.global(qos: .background).async {
//                    while topPlatform.position.y < (self.frame.height / 2) {
//                        if topPlatform.position.y >= (self.frame.height / 2) {
//                            self.createPlatforms(yPosition: self.frame.minY)
//                            self.platformArray.append(topPlatform)
//                            
//    //                        break
//                        }
//                    }
//                }
//                
//                    print(platformGroup.count)
//                    print(topPlatform)
//                
//            }
//            
//        }
//        
//    }
//}
