//
//  Forecast.swift
//  MojotGrad
//
//  Created by Teddy on 1/11/18.
//  Copyright © 2018 Teddy. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import IGListKit

class Forecast {
    
    init(){}
    
    var id: String!
    var _weekDay: String!
    var _weatherType: String!
    var _highTemp: String!
    var _lowTemp: String!
    var date: String = ""
    
    var weekDay: String {
        if _weekDay == nil {
            _weekDay = ""
        }
        return _weekDay
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var highTemp: String {
        if _highTemp == nil {
            _highTemp = ""
        }
        return _highTemp
    }
    
    var lowTemp: String {
        if _lowTemp == nil {
            _lowTemp = ""
        }
        return _lowTemp
    }
    
    init(weatherDict: JSON) {
        if let temp = weatherDict["temp"].dictionary {
            if let min = temp["min"]?.double{
                let kelvinToCelsius = (min - 273.15)
                self._lowTemp = "\(kelvinToCelsius.rounded())"
            }
            if let max = temp["max"]?.double {
                let kelvinToCelsius = (max - 273.15)
                self._highTemp = "\(kelvinToCelsius.rounded())"
            }
        }
        
        if let weatherMain = weatherDict["weather"][0]["main"].string {
            self._weatherType = weatherMain
        }
        
        if let date = weatherDict["dt"].double {
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.timeStyle = .none
            self._weekDay = unixConvertedDate.dayOfTheWeek()
        }
    }
    
    init(weatherDict: Dictionary<String, Any>) {
        if let temp = weatherDict["temp"] as? Dictionary<String, Any> {
            if let min = temp["min"] as? Double {
                let kelvinToCelsius = (min - 273.15)
                self._lowTemp = "\(kelvinToCelsius.rounded())"
            }

            if let max = temp["max"] as? Double {
                let kelvinToCelsius = (max - 273.15)
                self._highTemp = "\(kelvinToCelsius.rounded())"
            }
        }

        if let weather = weatherDict["weather"] as? [Dictionary<String, Any>] {
            if let main = weather[0]["main"] as? String {
                self._weatherType = main
            }
        }

        if let date = weatherDict["dt"] as? Double {
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.timeStyle = .none
            self._weekDay = unixConvertedDate.dayOfTheWeek()
        }
    }
}

extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}

extension Forecast: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return date as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        let obj = object as! Forecast
        if obj.date == obj.date {
            return true
        }
        return false
    }
}
