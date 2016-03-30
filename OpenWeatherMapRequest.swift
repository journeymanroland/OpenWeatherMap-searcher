//
//  OpenWeatherMapRequest.swift
//  JSON Example
//
//  Created by Roland Gill on 3/2/16.
//  Copyright © 2016 Appfish. All rights reserved.
//

import Foundation

protocol ReadCurrentGPSDataDelegate {
    func presentCurrent(weatherData: CurrentWeather)
}

protocol ReadExtendedGPSDelegate {
    func presentExtended(weatherData: FiveDayForecast)
}


class OpenWeatherMapRequest {
    private let weatherAPIKey = "&appid=7dc3a8cdbcb1e914c37d9c4f0fedbca4&units=metric"
    var gpsDelegate: ReadCurrentGPSDataDelegate?
    var xtndDelegate: ReadExtendedGPSDelegate?
    
    
    // function to parse JSON
    func parseJSON(jsonData: NSData) throws {
        guard let jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? [String: AnyObject] else {
                throw InputError.InvalidData
        }

        // call on delegate to receive data
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let wthr = CurrentWeather(fullForecast: jsonResult)
            let fc = FiveDayForecast(fullForecast: jsonResult)
            
            self.gpsDelegate?.presentCurrent(wthr)
            self.xtndDelegate?.presentExtended(fc)
        }
    }
    
    func getWeatherFromGPS(latitude: Double, longitude: Double, report: ForecastType) {
        let BASE_URL = "http://api.openweathermap.org/data/2.5/\(report.url())?lat=\(latitude)&lon=\(longitude)"
        let weatherURLString = BASE_URL + weatherAPIKey
        let searchAddress = NSURL(string: weatherURLString)! // declare NSURL to be searched
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(searchAddress) { (data, response, error) -> Void in // create url task
            if let jsonData = data {
                do {
                    try self.parseJSON(jsonData) // try error throwing function
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        task.resume() // start datatask
    
    }
    
}
