//
//  Extensions.swift
//  Paper Plane
//
//  Created by Cade Williams on 7/6/24.
//  Copyright © 2024 Cade Williams. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    static func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            UIApplication.shared.delegate?.window??.rootViewController?.present(alert, animated: true)
        }
    }
}
