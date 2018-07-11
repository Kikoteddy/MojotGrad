//
//  VenueRealm.swift
//  MojotGrad
//
//  Created by Teddy on 1/15/18.
//  Copyright © 2018 Teddy. All rights reserved.
//

import Foundation
import RealmSwift
import MapKit

class Venue: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var name:String = ""
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    @objc dynamic var address: String = ""
    @objc dynamic var rating: Double = 0
    @objc dynamic var distance: Double = 0
    
    var coordinate: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
