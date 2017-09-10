//
//  Weather.swift
//  Weather or Not
//
//  Created by Daniel Huang on 9/7/17.
//  Copyright © 2017 Daniel Huang. All rights reserved.
//

import Foundation
import CoreLocation

// My own custom Weather type to process the JSON data from Dark Sky API
struct Weather {
    
    let summary: String
    let icon: String
    let temperature: Double
    
    //define the error type conforming to the Error protocol
    enum  SerializationError:Error {
        case missing(String)  //ex: key does not exist
        case invalid(String, Any)
    }
    
    
    //initializer
    
    init(json:[String: Any]) throws {
        
        guard let summary = json["summary"] as? String else {
            throw SerializationError.missing("summary is missing")}
        guard let icon = json["icon"] as? String else {
            throw SerializationError.missing(("icon is missing"))
        }
        
        guard let temperature = json["temperatureMax"] as? Double else {
            throw SerializationError.missing("temp is missing")
            
        }
        
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
        
    }
    
    
    //declared as static so that we don't need a weather object to call the var/func
    
    //Use my API key provided by Dark Sky
    static let basePath = "https://api.darksky.net/forecast/5e4c53e319f8b16dc837664e200c25a5/"
    
    
    
    //the stactic function called by Weather struct; it will return an array of Weather objects
    static func forecast(withLocation location: CLLocationCoordinate2D, completion: @escaping ([Weather])->()) {
        
        
        let url = basePath + "\(location.latitude),\(location.longitude)"
        
        let request = URLRequest(url:URL(string: url)!)  //create a url request
        
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            var forecastArray :[Weather] = []
            if let data = data {
                do {
                    //here's where the FUN part begins
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                    if let dailyForecasts = json["daily"] as? [String:Any]{
                        //go another layer deeper in JSON data
                        if let dailyData = dailyForecasts["data"] as? [[String: Any]] {
                            
                            for dataPoint in dailyData {
                                if let weatherObject = try? Weather(json: dataPoint){
                                    forecastArray.append(weatherObject)  //create the weather object and store them all in the array by iterating thru the json data
                                }
                                
                                
                            }
                            
                        }
                        
                    }
                }
                }catch {
                    print(error.localizedDescription)
                    
                }
                
                completion(forecastArray)   //!!!!DON'T FORGET to call the completion handler
            }
            
            
        }
        
        
        task.resume()
        
        
        
        
        
        
    }

}
