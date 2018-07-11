//
//  UniqueIdGenerator.swift
//  Immer
//
//  Created by Darko Spasovski on 2/21/17.
//  Copyright © 2017 Movic. All rights reserved.
//

import UIKit

class UniqueIdGenerator: NSObject {
    
    static let generator = UniqueIdGenerator()
    static let key = "deviceUniqueId"
    
    override init (){}
    
    private func generateUniqueId() -> String{
        let appId = UIDevice.current.identifierForVendor?.uuidString
        save(deviceId: appId!)
        return appId!
    }
    
    public func getUniqueId() -> String{
        let deviceId = hasDeviceId() ? getDeviceId() : generateUniqueId()
        return "\(deviceId)_\(getRandomGuid())".lowercased()
    }
    
    private func hasDeviceId() -> Bool{
        if (UserDefaults.standard.object(forKey: UniqueIdGenerator.key) != nil) {
            return true
        }
        return false
    }
    
    private func save(deviceId: String){
        UserDefaults.standard.set(deviceId, forKey: UniqueIdGenerator.key)
        UserDefaults.standard.synchronize()
    }
    
    private func getDeviceId() -> String{
        return UserDefaults.standard.object(forKey: UniqueIdGenerator.key) as! String
    }
    
    private func getRandomGuid() -> String{
        let uuid = UUID().uuidString
        return uuid;
    }
}
