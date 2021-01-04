//
//  LocationManager.swift
//  MyFitness
//
//  Created by John Kouris on 12/24/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import Foundation
import MapKit

class LocationManager: NSObject {
    static let shared = LocationManager()
    var locationManager = CLLocationManager()
    var onLocationUpdate: ((CLLocation) -> Void)?
    
    func start(completionHandler: @escaping (CLLocation) -> Void) {
        locationManager.requestWhenInUseAuthorization()

        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 100.0
        locationManager.delegate = self

        locationManager.startUpdatingLocation()

        onLocationUpdate = completionHandler
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }

        onLocationUpdate?(newLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            return
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            start { (location) in
                self.locationManager.startUpdatingLocation()
            }
        @unknown default:
            return
        }
    }
}
