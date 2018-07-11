//
//  HomeController.swift
//  MojotGrad

//  Created by Teddy on 1/19/18.
//  Copyright © 2018 Teddy. All rights reserved.


import UIKit
import CoreLocation
import TransitionButton
import RealmSwift
import Reachability

class HomeController: CustomTransitionViewController, CLLocationManagerDelegate {

    @IBOutlet weak var coffeeButton: UIButton!
    let network = NetworkManager.sharedInstance
    var currentLocationLatitude: Float!
    var currentLocationLongitude: Float!
    var flag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coffeeButton.addTarget(self, action: #selector(getCurrentLocation1), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //ReachabilityMenager.shared.addListener(listener: self)
        network.reachability.whenReachable = { _ in
            self.coffeeButton.isHidden = false
        }
        
        network.reachability.whenUnreachable = { _ in
            self.coffeeButton.isHidden = true
            self.showAlert(withTitle: "Network Disabled", message: "Please enable WiFi or Cellular Data")
        }
        flag = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //ReachabilityMenager.shared.removeListener(listener: self)
        NetworkManager.stopNotifier()
    }

    // Figure out where the user is
    @objc func getCurrentLocation1() {
        LocationManager.shared.getLocationWithCompletionHandler { (lat, long) in
            if self.flag {
                self.currentLocationLatitude = lat
                self.currentLocationLongitude = long
                self.flag = false
                self.performSegue(withIdentifier: "showSearch", sender: self)
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass the latitude and longitude to the new view controller
        if segue.identifier == "showSearch" {
            let vc = segue.destination as! SearchController
            vc.currentLocationLatitude = currentLocationLatitude
            vc.currentLocationLongitude = currentLocationLongitude
        }
    }
}
