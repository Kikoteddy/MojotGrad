//
//  DataModel.swift
//  MojotGrad
//
//  Created by Teddy on 1/14/18.
//  Copyright © 2018 Teddy. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var locations: CLLocation?
    var locationManager : CLLocationManager?
    var currentLocation : CLLocationCoordinate2D?
    var lat : Float?
    var lon : Float?
    var locationManagerCallback: ((Float?,Float?) -> ())?
    
    static let shared: LocationManager = {
        let instance = LocationManager()
        return instance
    }()
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
    }
    
    func getLocationWithCompletionHandler(completion: @escaping (Float?,Float?) -> ()) -> Void {
        if locationManager != nil {
            locationManager?.stopUpdatingLocation()
            locationManager?.delegate = nil
            locationManager = nil
        }
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        let requestWhenInUseSelector = NSSelectorFromString("requestWhenInUseAuthorization")
        let requestAlwaysSelector = NSSelectorFromString("requestAlwaysAuthorization")
        
        if (locationManager?.responds(to: requestWhenInUseSelector))! {
            
            locationManager?.requestWhenInUseAuthorization()
            
        }else if (locationManager?.responds(to: requestAlwaysSelector))!{
            
            locationManager?.requestAlwaysAuthorization()
        }
        locationManager?.startUpdatingLocation()
        locationManagerCallback = completion
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locations = locations.last
        currentLocation = self.locations?.coordinate
        lat = Float(currentLocation!.latitude)
        lon = Float(currentLocation!.longitude)
        locationManagerCallback?(lat, lon)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

}
