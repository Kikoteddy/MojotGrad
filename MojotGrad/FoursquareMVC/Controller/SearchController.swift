//
//  SearchController.swift
//  MojotGrad
//
//  Created by Teddy on 1/19/18.
//  Copyright © 2018 Teddy. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire
import RealmSwift
import MapKit

class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var searchResults = [JSON]()
    var currentLocationLatitude: Float!
    var currentLocationLongitude: Float!
    var venues = [Venue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set nav bar title
        title = "☕️"
        
        // show annimation views
        currentLocationLabel.text = ""
        currentLocationLabel.isHidden = true
        tableView.isHidden = true
        
        // set delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(searhForCoffferDone(notification:)), name: NSNotification.Name("ReloadData"), object: nil)
        
        snapToPlace()
        searchForCoffe()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func searchForCoffe(){
        ApiManager.shared.searchForCoffee(completed: {
            self.getAllVenuesForLocation()
        })
    }
    
    func snapToPlace(){
        ApiManager.shared.snapToPlace(completed: { (currentVenueName,error) in
            if error == nil {
                DispatchQueue.main.async {
                    if let v = currentVenueName {
                        self.currentLocationLabel.text = "You're at \(v). Here's some ☕️ nearby."
                    }
                    self.currentLocationLabel.isHidden = false
                }
                self.tableView.isHidden = false
            } else {
                print(error!)
            }
        })
    }
    
    @objc func searhForCoffferDone(notification: Notification){
        self.getAllVenuesForLocation()
    }
    
    func getAllVenuesForLocation() {
        if let location = LocationManager.shared.currentLocation {
            let region = MKCoordinateRegionMakeWithDistance(location, 500, 500)
            let northWestCorner = CLLocationCoordinate2DMake(
                location.latitude + (region.span.latitudeDelta),
                location.longitude - (region.span.longitudeDelta)
            )
            let southEastCorner = CLLocationCoordinate2DMake(
                location.latitude - (region.span.latitudeDelta),
                location.longitude + (region.span.longitudeDelta)
            )
            
            let predicate = NSPredicate(format: "latitude BETWEEN {%f, %f} AND longitude BETWEEN {%f, %f}",
                                        southEastCorner.latitude,
                                        northWestCorner.latitude,
                                        northWestCorner.longitude,
                                        southEastCorner.longitude
            )
            venues = RealmManager.shared.getNearbyVenuesWith(predicate: predicate)
            self.tableView.reloadData()
            return
        }
        venues = RealmManager.shared.getNearbyVenuesWith(predicate: nil)
        self.tableView.reloadData()
    }
    
    // MARK: - TableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SearchCell
        let venue = venues[indexPath.row]
        cell.title.text = venue.name
        cell.rating.text = String(format: "%.1f", venue.rating) + "⭐️"
        cell.distance.text = "\(venue.distance)m"
        cell.address.text = venue.address
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "details", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details" {
            let vc = segue.destination as! DetailsController
            let selectedCell = tableView.indexPathForSelectedRow!
            let venue = venues[selectedCell.row]
            let lat = venue.latitude
            let lng = venue.longitude
            vc.venueName = venue.name
            vc.location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            vc.venueId = venue.id
            tableView.deselectRow(at: selectedCell, animated: false)
        }
    }
}
