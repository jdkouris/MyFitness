//
//  FoursquareAPI.swift
//  MyFitness
//
//  Created by John Kouris on 12/24/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import Foundation
import MapKit

class FoursquareAPI {
    static let shared = FoursquareAPI()

    var isQueryPending = false

    private init() { }

    func query(location: CLLocation, completionHandler: @escaping ([[String: Any]]) -> Void) {
        if isQueryPending { return }
        isQueryPending = true
        var places = [[String: Any]]()
        
        let clientId        = URLQueryItem(name: "client_id", value: APIKeys.foursquareClientID)
        let clientSecret    = URLQueryItem(name: "client_secret", value: APIKeys.foursquareClientSecret)
        let version         = URLQueryItem(name: "v", value: "20190401")
        let coordinate      = URLQueryItem(name: "ll", value: "\(location.coordinate.latitude),\(location.coordinate.longitude)")
        let query           = URLQueryItem(name: "query", value: "fitness")
        let intent          = URLQueryItem(name: "intent", value: "browse")
        let radius          = URLQueryItem(name: "radius", value: "1000")
        
        var urlComponents = URLComponents(string: "https://api.foursquare.com/v2/venues/search")!
        urlComponents.queryItems = [clientId, clientSecret, version, coordinate, query, intent, radius]
        
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
            defer {
                self.isQueryPending = false
            }
            
            if error != nil {
                print("***** ERROR ***** \(error!.localizedDescription)")
                return
            }
            
            if data == nil || response == nil {
                print("***** SOMETHING WENT WRONG *****")
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: [])
                
                if let jsonObject = jsonData as? [String: Any],
                   let response = jsonObject["response"] as? [String: Any],
                   let venues = response["venues"] as? [[String: Any]] {
                    
                    for venue in venues {
                        if let name = venue["name"] as? String,
                           let location = venue["location"] as? [String: Any],
                           let latitude = location["lat"] as? Double,
                           let longitude = location["lng"] as? Double,
                           let formattedAddress = location["formattedAddress"] as? [String] {
                            
                            places.append([
                                "name": name,
                                "address": formattedAddress.joined(separator: " "),
                                "latitude": latitude,
                                "longitude": longitude
                            ])
                        }
                    }
                }
                
                places.sort() { item1, item2 in
                    let distance1 = location.distance(from: CLLocation(latitude: item1["latitude"] as! CLLocationDegrees, longitude: item1["longitude"] as! CLLocationDegrees))
                    let distance2 = location.distance(from: CLLocation(latitude: item2["latitude"] as! CLLocationDegrees, longitude: item2["longitude"] as! CLLocationDegrees))

                    return distance1 < distance2
                }
                
            } catch {
                print("*** JSON ERROR *** \(error.localizedDescription)")
                return
            }
            
            self.isQueryPending = false
            
            DispatchQueue.main.async {
                completionHandler(places)
            }
        }
        task.resume()
    }
}
