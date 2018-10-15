//
//  WeatherVC.swift
//  MojotGrad
//
//  Created by Teddy on 1/11/18.
//  Copyright © 2018 Teddy. All rights reserved.
//
import Foundation
import UIKit
import CoreLocation
import IGListKit

class WeatherVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    //@IBOutlet weak var tableView: UITableView!
    let network = NetworkManager.sharedInstance
    var currentWeather = CurrentWeather()
    var forecasts = [Forecast]()
    var forecast: Forecast!
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        network.reachability.whenReachable = { _ in
            self.adapter.performUpdates(animated: true, completion: nil)
        }
        
        network.reachability.whenUnreachable = { _ in
            self.showAlert(withTitle: "Network Disabled", message: "Please enable WiFi or Cellular Data")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NetworkManager.stopNotifier()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLocationAndUpdateMainUI()
       adapter.collectionView = collectionView
        adapter.dataSource = self
        //collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "WeatherCollectionViewCell")
        //setupTableView()
    }
    
//    func setupTableView(){
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(WeatherCell.self)
//    }
    
    func getLocationAndUpdateMainUI(){
        LocationManager.shared.getLocationWithCompletionHandler { (lat, long) in
            self.downloadWeatherInfo()
            self.downloadForecasts()
        }
    }
    
    func downloadWeatherInfo(){
        ApiManager.shared.downloadCurrentWeatherInfo(currentWeather: self.currentWeather, completed: { (_,error)  in
            if error == nil {
                self.updateMainUI(currentWeather: self.currentWeather)
            } else {
                print(error?.localizedDescription)
            }
    })
    }
    
    func downloadForecasts(){
        ApiManager.shared.downloadForecastsData(forecasts: self.forecasts, completed: { (forecasts,error) in
            if error == nil {
                self.forecasts = forecasts!
                //self.tableView.reloadData()
                self.adapter.performUpdates(animated: true, completion: nil)
            } else {
                //error
            }
        })
    }
    
    func updateMainUI(currentWeather: CurrentWeather){
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }
}

extension WeatherVC: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return forecasts as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return SectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
//extension WeatherVC: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherCell {
//            let forecast = forecasts[indexPath.row]
//            cell.configureCell(forecast: forecast)
//            return cell
//        } else {
//            return WeatherCell()
//        }
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return forecasts.count-1
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80
//    }
//}
