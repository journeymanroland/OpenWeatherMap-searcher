//
//  JSON.swift
//  JSON Example
//
//  Created by Roland Gill on 3/29/16.
//  Copyright © 2016 Appfish. All rights reserved.
//

import Foundation


enum InputError: ErrorType {
    case InvalidData
}

enum ForecastType {
    case Forecast, Weather
    
    func url() -> String {
        switch self {
        case .Forecast:
            return "forecast"
        case .Weather:
            return "weather"
        }
        
    }
}

struct CurrentWeather { // parsed json object of current weather conditions
    let fullForecast: [String:AnyObject]?
    let main: [String:AnyObject]?
    let temp: Double?
    let location: String?
    
    init(fullForecast: [String: AnyObject]) {
        self.fullForecast = fullForecast // all json data
        self.main = fullForecast["main"] as? [String:AnyObject]
        self.location = fullForecast["name"] as? String
        
        if let mn = self.main { //
            self.temp = mn["temp"] as? Double
        } else {
            self.temp = 0
        }
    }
}

struct ForecastForTime {
    let temperature: Double!
    let description: AnyObject!
    let dateTxt: String!
    //let weather: [String: AnyObject]?
    func formatDateLabel(dateString: String) -> String? {
        // interpret string as date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let forcastDate = dateFormatter.dateFromString(dateString)
        // convert to formatted string
        
        dateFormatter.dateStyle = .ShortStyle // compact style for tbl cells
        dateFormatter.timeStyle = .ShortStyle
        if let fcdt = forcastDate {
            let tCellDate = dateFormatter.stringFromDate(fcdt)
            return tCellDate
        } else {
            return nil
        }
        
    }
    
}

struct FiveDayForecast { // parsed json object of a 5 day forecast, every 3 hours
    let fullForecast: [String: AnyObject]?
    let list: [[String: AnyObject]]?
    let city: [String: AnyObject]?
    let errorCode: AnyObject!
    var allForecasts = [ForecastForTime]() // list of forecasts for each time interval
    
    init(fullForecast: [String: AnyObject]) {
        self.fullForecast = fullForecast
        self.list = fullForecast["list"] as? [[String: AnyObject]]
        self.city = fullForecast["city"] as? [String:AnyObject]
        self.errorCode = fullForecast["cod"]
        print(errorCode)
        
        //      // create forecast object for every 3h time interval
        if let list = self.list {
            for item in list {
                let temp = item["main"]!["temp"] as! Double
                let desc = item["weather"]![0]["description"]
                let dTxt = item["dt_txt"] as! String
                
                let forecastForTime = ForecastForTime(temperature: temp, description: desc, dateTxt: dTxt)
                allForecasts.append(forecastForTime)
            }
        }
        print(allForecasts.map { $0.temperature })
    }
    
    func listOfDates() -> [String] {
        var list = [String]()
        for item in self.allForecasts {
            if let wthr = item.formatDateLabel(item.dateTxt) {
                list.append(wthr)
            }
        }
        return list
    }
    
}


    