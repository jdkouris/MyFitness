//
//  GymFinderVC.swift
//  MyFitness
//
//  Created by John Kouris on 2/26/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Contacts

class GymFinderVC: UIViewController {
    
    var gymMapView: MKMapView!
    private let locationManager = CLLocationManager()
    private var userTrackingButton: MKUserTrackingButton!
    var arrayOfResults: [MKMapItem] = []
    
    var gym: MKPointOfInterestCategory = .fitnessCenter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        locationManager.requestWhenInUseAuthorization()
        
        setupGymMapView()
        setupUserTrackingButton()
        attemptLocationAccess()
        searchInMap()
    }
    
    func attemptLocationAccess() {
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }

        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestLocation()
        }
        
        guard let location = locationManager.location else { return }
        gymMapView.centerToLocation(location)
    }
    
    func searchInMap() {
        // Create request
        let request = MKLocalSearch.Request()
        // Including array of MLPointOfInterestCategory
        request.pointOfInterestFilter = MKPointOfInterestFilter(including: [gym])
        // Run search
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: { (response, error) in
            
            if let response = response {
                for item in response.mapItems {
                    self.addPinToMapView(title: item.name,
                                         latitude: item.placemark.location!.coordinate.latitude,
                                         longitude: item.placemark.location!.coordinate.longitude)
                    self.arrayOfResults.append(item)
                }
            }
        })
    }
    
    func addPinToMapView(title: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        if let title = title {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = title
            gymMapView.addAnnotation(annotation)
        }
    }
    
    private func setupGymMapView() {
        gymMapView = MKMapView(frame: view.bounds)
        gymMapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gymMapView)
        gymMapView.delegate = self
        
        NSLayoutConstraint.activate([
            gymMapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gymMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gymMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gymMapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupUserTrackingButton() {
        userTrackingButton = MKUserTrackingButton(mapView: gymMapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userTrackingButton)
        
        NSLayoutConstraint.activate([
            userTrackingButton.leadingAnchor.constraint(equalTo: gymMapView.leadingAnchor, constant: 30),
            userTrackingButton.bottomAnchor.constraint(equalTo: gymMapView.bottomAnchor, constant: -30)
        ])
    }
    
}

extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 2000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

extension GymFinderVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { return }
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }
    
}

extension GymFinderVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
    }
}
