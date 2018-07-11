//
//  ApiManager.swift
//  MojotGrad
//
//  Created by Teddy on 1/11/18.
//  Copyright © 2018 Teddy. All rights reserved.
//
import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation
import RealmSwift

class ApiManager {
    
    static let shared = ApiManager()
    var searchResults = [JSON]()
    var venues: [Venue] = [Venue]()
    
    func downloadCurrentWeatherInfo(currentWeather: CurrentWeather ,completed: @escaping DownloadCompleted){
        Alamofire.request(CURRENT_WEATHER_URL).responseJSON { response in
            if response.result.isFailure{
                completed(nil,response.error)
                return
            }
            if let jsonResponse = response.result.value {
                let json = JSON(jsonResponse)
                let cWeather = self.parseCurrentWeatherInfo(currentWeather: currentWeather, json: json)
                completed(cWeather,nil)
            }
        }
    }
    
    func parseCurrentWeatherInfo(currentWeather: CurrentWeather , json: JSON) -> CurrentWeather {
        if let name = json["name"].string {
            currentWeather._cityName = name
        } else {
            currentWeather._cityName = ""
        }
        if let mainTemp = json["main"]["temp"].double {
            let kelvinToCelsius = (mainTemp - 273.15)
            currentWeather._currentTemp = kelvinToCelsius.rounded()
        } else {
            currentWeather._currentTemp = 0.0
        }
        
        if let weatherMain = json["weather"][0]["main"].string {
            currentWeather._weatherType = weatherMain.capitalized
        } else {
            currentWeather._weatherType = ""
        }
        return currentWeather
    }
    
    func downloadForecastsData(forecasts: [Forecast], completed: @escaping fDownloadCompleted){
        Alamofire.request(FORECAST_URL).responseJSON { response in
            
            if response.result.isFailure{
                completed(nil,response.error)
                return
            }
            if let jsonResponse = response.result.value {
                let json = JSON(jsonResponse)
                let fWeather = self.parseForecastData(forecasts: forecasts, json: json)
                completed(fWeather,nil)
            }
        }
    }
    
    func parseForecastData(forecasts: [Forecast], json: JSON) -> [Forecast] {
       
        var forecasts = [Forecast]()
        
        if let list = json["list"].array {
            
            for json in list {
                
                let forecast = Forecast()
                
                forecast.id = UniqueIdGenerator.generator.getUniqueId()
                
                if let temp = json["temp"].dictionary {
                    if let min = temp["min"]?.double {
                        let kelvinToCelsius = (min - 273.15)
                        forecast._lowTemp = "\(kelvinToCelsius.rounded())"
                    }
                    
                    if let max = temp["max"]?.double {
                        let kelvinToCelsius = (max - 273.15)
                        forecast._highTemp = "\(kelvinToCelsius.rounded())"
                    }
                }
                
                if let weatherMain = json["weather"][0]["main"].string {
                    forecast._weatherType = weatherMain
                }
                
                if let date = json["dt"].double {
                    let unixConvertedDate = Date(timeIntervalSince1970: date)
                    forecast.date = unixConvertedDate.dayOfTheWeek()
                }
                forecasts.append(forecast)
            }
            forecasts.remove(at: 0)
            
        }
        
        return forecasts
    }
    
    func downloadForecastData(completed: @escaping fDownloadCompleted) {
        Alamofire.request(FORECAST_URL).responseJSON { response in
            if response.result.isFailure {
                completed(nil, response.error)
                return
            }
            var forecasts = [Forecast]()
            let result = response.result.value
         
            if let dict = result as? Dictionary<String,Any> {
                if let list = dict["list"] as? [Dictionary<String,Any>]{
                    for obj in list {
                        let forecast = Forecast(weatherDict: obj)
                        forecasts.append(forecast)
                    }
                }
            }
            forecasts.remove(at: 0)
            completed(forecasts,nil)
        }
    }
    
    func snapToPlace(completed: @escaping (String?,_ error: Error?)->()) {
        Alamofire.request(FOURSQUARE_URL).responseJSON { response in
            
            if response.result.isFailure {
                completed(nil, response.error)
                return
            }
            
            var currentVenueName: String?
            if let jsonResponse = response.result.value {
                let json = JSON(jsonResponse)
                if let currentVenueNam = json["response"]["venues"][0]["name"].string {
                    currentVenueName = currentVenueNam
                }
                self.searchResults = json["response"]["venues"].array!
            }
            completed(currentVenueName,nil)
        }
    }
    
    func searchForCoffee(completed: @escaping DownloadComplete) {
        
        Alamofire.request(FOURSQUARE_URL_EXPLORE).responseJSON { response in
            if let jsonResponse = response.result.value {
                let json = JSON(jsonResponse)
                self.searchResults = json["response"]["groups"][0]["items"].arrayValue
                self.parseSearchForCoffeResults(searchResults: self.searchResults)
            }
            RealmManager.shared.addToRealm(venues: self.venues)
            NotificationCenter.default.post(name: Notification.Name("ReloadData"), object: nil, userInfo: ["darko":"ubav"])
        }
    }
    
    func parseSearchForCoffeResults(searchResults: [JSON]) {
        for venue: JSON in searchResults {
            let venueObject: Venue = Venue()
            if let id = venue["venue"]["id"].string {
                venueObject.id = id
            }
            
            if let name = venue["venue"]["name"].string {
                venueObject.name = name
            }
            if let rating = venue["venue"]["rating"].double{
                venueObject.rating = rating
            }
            
            if let location = venue["venue"]["location"].dictionary {
                
                if let longitude = location["lng"]?.double{
                    venueObject.longitude = longitude
                }
                if let latitude = location["lat"]?.double{
                    venueObject.latitude = latitude
                }
                if let distance = location["distance"]?.double{
                    venueObject.distance = distance
                }
                if let address = location["address"]?.string{
                    venueObject.address = address
                }
            }
            venues.append(venueObject)
        }
    }
}
