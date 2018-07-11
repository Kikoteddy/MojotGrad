//
//  RealmManager.swift
//  MojotGrad
//
//  Created by Teddy on 1/19/18.
//  Copyright © 2018 Teddy. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON



class RealmManager: NSObject {
    
    static let shared: RealmManager = RealmManager()
    var realm: Realm?
    internal var config = Realm.Configuration()
    
    func setup(completed: Completion) {
        config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent("MojotGrad.realm")
        
        print(config.fileURL!.absoluteString)
        
        var currentSchema = UInt64(Utils.shared.userDetails!.integer(forKey: "MojotGradRealmSchemaVersion"))
        // update schema version
        config.schemaVersion = currentSchema
        
        do {
            realm = try Realm(configuration: config)
        } catch {
            if error.localizedDescription.contains("Migration is required due to the following errors") {
                currentSchema += 1
                
                config = Realm.Configuration(
                    // Set the new schema version. This must be greater than the previously used
                    // version (if you've never set a schema version before, the version is 0).
                    schemaVersion: currentSchema,
                    
                    // Set the block which will be called automatically when opening a Realm with
                    // a schema version lower than the one set above
                    migrationBlock: { migration, oldSchemaVersion in
                        // We haven’t migrated anything yet, so oldSchemaVersion == 0
                        if oldSchemaVersion < 1 {
                            // Nothing to do!
                            // Realm will automatically detect new properties and removed properties
                            // And will update the schema on disk automatically
                        }
                })
                
                config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent("MojotGrad.realm")
                config.schemaVersion = currentSchema
                Utils.shared.userDetails!.set(currentSchema, forKey: "MojotGradRealmSchemaVersion")
                
                setup(completed: { error in
                    completed(error)
                })
            } else if error.localizedDescription.contains("Provided schema version") {
                currentSchema += 1
                config.schemaVersion = currentSchema
                Utils.shared.userDetails!.set(currentSchema, forKey: "MojotGradRealmSchemaVersion")
                setup(completed: { error in
                    completed(error)
                })
            }
        }
    }
    
    var totalVenues: Int {
        if let count = realm?.objects(Venue.self) {
            return count.count
        }
        return 0
    }
    
    func deleteAll(){
        let results: Results<Venue>? = realm?.objects(Venue.self)
        if results != nil {
            try! realm?.write {
                realm?.deleteAll()
            }
        }
    }
    
    func addToRealm(venues: [Venue]){
        do {
            try realm?.write {
                realm?.add(venues, update: true)
            }
        } catch let err as NSError {
            print("Why you no realm? \(err)")
        }
    }
    
    func getNearbyVenuesWith(predicate: NSPredicate?) -> [Venue] {
        if let predicate = predicate {
            let venues = realm?.objects(Venue.self).filter(predicate)
            return Array(venues!)
        }
        return Array((realm?.objects(Venue.self))!)
    }


    
    
    
    
}
