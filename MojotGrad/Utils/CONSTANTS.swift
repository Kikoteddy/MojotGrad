//
//  CONSTANTS.swift
//  MojotGrad
//
//  Created by Teddy on 1/11/18.
//  Copyright © 2018 Teddy. All rights reserved.
//

import Foundation

public typealias Completion = (_ error: Error?) -> ()
let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "f4372bc4f84bece7d6e5bc17fe053c67"
var clientID = "SCG24ENUTH21J1NEUJSUDDJ5XSJ0JQNAQCSYUV4QU2D5OQ4H"
var secretClient = "CEZK5OIJYZA5GO1V0GCKB5MQ0RGEUNLOWSTOJJ4VAUJU50AW"

typealias DownloadComplete = () -> ()

typealias DownloadCompleted = (_ currentWeather: CurrentWeather?,_ error: Error?) -> ()
typealias fDownloadCompleted = (_ forecasts: [Forecast]?,_ error: Error?) -> ()

var latitude = LocationManager.shared.lat
var longitude = LocationManager.shared.lon

let CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude!)&lon=\(longitude!)&appid=\(API_KEY)"
let FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(latitude!)&lon=\(longitude!)&appid=\(API_KEY)"

let FOURSQUARE_URL = "https://api.foursquare.com/v2/venues/search?ll=\(latitude!),\(longitude!)&intent=checkin&radius=500&categoryId=4bf58dd8d48988d1e0931735&client_id=\(clientID)&client_secret=\(secretClient)&v=20180114"

let FOURSQUARE_URL_EXPLORE = "https://api.foursquare.com/v2/venues/explore?ll=\(latitude!),\(longitude!)&client_id=\(clientID)&client_secret=\(secretClient)&v=20180114&section=coffee&radius=500"
