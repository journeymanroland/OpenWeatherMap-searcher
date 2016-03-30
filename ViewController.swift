//
//  ViewController.swift
//  JSON Example
//
//  Created by Rob Percival on 23/06/2015.
//  Copyright © 2015 Appfish. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, ReloadJSONDataDelegate, CLLocationManagerDelegate, ReadCurrentGPSDataDelegate, ReadExtendedGPSDelegate {
    var searchLocation: CLLocation?
    var gpsForecast: String?
    var locationMgr: CLLocationManager = CLLocationManager()
    let gpsReq =  OpenWeatherMapRequest()// get weather data from GPS coords
    let req = ApiRequest()
    var intervals: FiveDayForecast?
    @IBOutlet weak var zipSearchBox: UITextField!
    @IBOutlet weak var localWeather: UILabel!
    
    @IBAction func searchWeather(sender: AnyObject) {
        
        // create delegate that will listen to request
        req.delegate = self

        if let zip = NSNumberFormatter().numberFromString(zipSearchBox.text!)?.integerValue {
            print("searching")
            req.weatherFromZip(zip)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        gpsReq.gpsDelegate = self // assign delegates
        gpsReq.xtndDelegate = self
        
        locationMgr.delegate = self // set location mgr delegate
        locationMgr.desiredAccuracy = kCLLocationAccuracyBest // set accuracy of GPS tracking
        locationMgr.requestWhenInUseAuthorization() // don't use location services when app is in the background
        locationMgr.startUpdatingLocation()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showIntervals" {
            if let destTableCtrlr = segue.destinationViewController as? ExtendedForecastTableView {
                destTableCtrlr.extended = intervals
            }
        }
    }
    
    @IBAction func getWeatherFromGPS(sender: UIButton) {
        if let weatherFromGPS = self.gpsForecast {
            localWeather.text! = weatherFromGPS
        } else {
            localWeather.text! = "Oops! Make sure your GPS is on."
        }
    }
   
    func refreshData(weather: CurrentWeatherFromZip) {
        NSOperationQueue.mainQueue().addOperationWithBlock({
            self.localWeather.text! = "The temperature in \(weather.description) is \(weather.temperature) °C"
        })
    }

    func presentCurrent(weatherData: CurrentWeather) { // notify view to update its data
        if let location = weatherData.location,
        temperature = weatherData.temp {
            self.gpsForecast = "The temperature in \(location) is \(temperature) °C"
        }
        
    }
    
    func presentExtended(weatherData: FiveDayForecast) {
        intervals = weatherData
        if let city = weatherData.city {
            print(city)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        
        if locations.count > 0 { // will only get location once
            locationMgr.stopUpdatingLocation()
        }
        
        let latitude:CLLocationDegrees = userLocation.coordinate.latitude
        let longitude:CLLocationDegrees = userLocation.coordinate.longitude

        // data task
        gpsReq.getWeatherFromGPS(latitude, longitude: longitude, report: .Forecast)
    }
    
}

