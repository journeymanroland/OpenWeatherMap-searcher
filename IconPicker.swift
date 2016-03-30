//
//  IconPicker.swift
//  JSON Example
//
//  Created by Roland Gill on 2/22/16.
//  Copyright © 2016 Roland Gill. All rights reserved.
//

import Foundation

enum ErrorGettingIcon: ErrorType {
    case NotFound
}

class IconPicker {
    var weatherData: FiveDayForecast?
    
    let BASE_ICN_URL = "http://openweathermap.org/img/w/"
    let weathIcons: [String: String] = ["clear sky": "01", "breeze": "01", "few clouds": "02", "scattered clouds": "03", "broken clouds": "04", "shower rain": "09", "rain": "10", "thunderstorm": "11", "snow": "13", "freezing rain": "13", "mist": "50"]
    
    let extremeWeather = ["tornado", "tropical storm", "hurricane", "cold", "hot", "windy", "hail"]
    
    func handleW(string: String) -> String? {
        for keys in weathIcons {
            if string.rangeOfString(keys.0) != nil {
                return(keys.0)
//            } else {
//                return nil
            }
        }
        return nil
    }
    
    
    
    func createIcon(weatherData: ForecastForTime?) -> String {
        
        if let urlcompletion = weatherData?.description as? String,
        let keyHandler = handleW(urlcompletion),
        let icon = weathIcons[keyHandler] {
            let url = BASE_ICN_URL + "\(icon)" + "d" + ".png"
            print(url)
            return url
        
        }
        print("error")
        return "http://openweathermap.org/img/w/01d.png"
    }
    
}

