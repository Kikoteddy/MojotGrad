//
//  DetailsController.swift
//  MojotGrad
//
//  Created by Teddy on 1/19/18.
//  Copyright © 2018 Teddy. All rights reserved.
//

import UIKit
import MapKit

class DetailsController: UIViewController, MKMapViewDelegate {
    
    var venueName: String!
    var venueId: String!
    var location: CLLocationCoordinate2D!
    let distanceMeter: CLLocationDistance = 500
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set title
        title = venueName
        
        // set directions button
        let directions = UIBarButtonItem(title: "Directions", style: .plain, target: self, action: #selector(getDirections))
        navigationItem.rightBarButtonItem = directions
        
        // set map zoom
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, 1000, 1000)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.mapType = .standard
        // add a pin to the map
        mapView.delegate = self
        mapView.addAnnotation(CoffeePin(title: "View in Foursquare", name: venueName, foursquareId: venueId, coordinate: location))
    }
    
    @IBAction func centerToUserTapped(_ sender: Any) {
        centerToUserLocation()
    }
    
    func centerToUserLocation(){
        if let center = LocationManager.shared.currentLocation {
        let zoomRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(center, distanceMeter, distanceMeter)
        mapView.setRegion(zoomRegion, animated: true)
        let annotation = MKPointAnnotation()
        let coordinateValue: CLLocationCoordinate2D = center
        annotation.coordinate = coordinateValue
        annotation.title = "You are here"
        self.mapView.addAnnotation(annotation)
        }
    }
    
    // MARK: - Apple Maps directions
    func mapItem() -> MKMapItem{
        let placemark = MKPlacemark(coordinate: location)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = venueName
        return mapItem
    }
    
    @objc func getDirections() {
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    // MARK: - Map Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? CoffeePin {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let encodedAddress = ("https://www.foursquare.com/v/"+venueId).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encodedAddress) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
