//
//  ReachabilityMenager.swift
//  MojotGrad
//
//  Created by Teddy on 1/22/18.
//  Copyright © 2018 Teddy. All rights reserved.
//

import UIKit
import Reachability
import Foundation

// Protocol for listenig network status change
public protocol NetworkStatusListener : class {
    func networkStatusDidChange(status: Reachability.Connection)
}

class ReachabilityMenager: NSObject {
    
    // Array of delegates which are interested to listen to network status change
    var listeners = [NetworkStatusListener]()
    static let shared = ReachabilityMenager()
    let reachability = Reachability()!
    
    var isNetworkAvailable : Bool {
        return reachabilityStatus != .none
    }
    
    var reachabilityStatus: Reachability.Connection = .none
    
    /// Adds a new listener to the listeners array
    ///
    /// - parameter delegate: a new listener
    func addListener(listener: NetworkStatusListener){
        listeners.append(listener)
    }
    
    /// Removes a listener from listeners array
    ///
    /// - parameter delegate: the listener which is to be removed
    func removeListener(listener: NetworkStatusListener){
        listeners = listeners.filter{ $0 !== listener}
    }
    
    @objc func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        switch reachability.connection {
        case .none:
            debugPrint("Network became unreachable")
        case .wifi:
            debugPrint("Network reachable through WiFi")
        case .cellular:
            debugPrint("Network reachable through Cellular Data")
        }
        
        // Sending message to each of the delegates
        for listener in listeners {
            listener.networkStatusDidChange(status: reachability.connection)
        }
        
    }
    
    func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged), name: Notification.Name.reachabilityChanged,object: reachability)
        do{
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    func stopMonitoring(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self,name: Notification.Name.reachabilityChanged, object: reachability)
    }
    
}
