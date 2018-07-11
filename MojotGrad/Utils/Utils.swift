//
//  Utils.swift
//  MojotGrad
//
//  Created by Teddy on 1/22/18.
//  Copyright © 2018 Teddy. All rights reserved.
//

import Foundation
import UIKit

class Utils: NSObject {
    
    static let shared = Utils()
    
    var userDetails = UserDefaults(suiteName: "com.wayan")
}

extension UIViewController {
    
    func showAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showLocationAlert() {
        let alert = UIAlertController(title: "Location Disabled", message: "Please enable location for Mr. Jitters", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
