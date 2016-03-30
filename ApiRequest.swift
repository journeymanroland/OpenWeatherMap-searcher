//
//  ApiRequest.swift
//  JSON Example
//
//  Created by Roland Gill on 2/6/16.
//  Copyright © 2016 Appfish. All rights reserved.
//

import Foundation

var city = "test"

protocol ReloadJSONDataDelegate {
    func refreshData(data: CurrentWeatherFromZip)
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////// get weather from zip code 

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct CurrentWeatherFromZip {
    let fullDataObj: [String: AnyObject]?
    let temperature: Double!
    let description: String!
    
    init(fullDataObj: [String: AnyObject]) {
        self.fullDataObj = fullDataObj
        self.description = fullDataObj["name"] as? String
        self.temperature = fullDataObj["main"]!["temp"] as! Double
    }
    
}

class ApiRequest {
    // constants
    let weatherAPIKey = ",us&appid=7dc3a8cdbcb1e914c37d9c4f0fedbca4&units=metric" // my unique API key
    let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?zip=" // base url
    var output = "test"
    
    // expects to have delegate
    var delegate: ReloadJSONDataDelegate?
    var weather: String?
    var temperature: Double?

    // get local weather from zipcode
    func parseJSONObj(weather: NSData) throws { // check if json is valid & convertible to dictionary
        guard let json = try NSJSONSerialization.JSONObjectWithData(weather, options: NSJSONReadingOptions.MutableContainers) as? [String: AnyObject] else {
            throw InputError.InvalidData
        }
        
        let currentWFromZip = CurrentWeatherFromZip(fullDataObj: json)
        print(currentWFromZip.description)
        delegate?.refreshData(currentWFromZip)
    }
    
    func weatherFromZip(zip: Int) {
        let weatherURLString = BASE_URL + "\(zip)" + weatherAPIKey 
        let searchAddress = NSURL(string: weatherURLString)! // declare NSURL to be searched
        
        // get shared NSURLSession
        let task = NSURLSession.sharedSession().dataTaskWithURL(searchAddress) { (data, response, error) -> Void in
            if let jsonData = data { // unwrap data returned by API req

                do {
                    try self.parseJSONObj(jsonData)
                    //print(jsonData)
                } catch {
                    print("error: \(error)")
                }
            }
        }
        task.resume()
    }
    
    
    
}
