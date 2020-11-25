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
            annotation.subtitle = "\(location.latitude)"
            gymMapView.addAnnotation(annotation)
            navigateTo(latitude: latitude, longitude: longitude)
        }
    }
    
    private func navigateTo(latitude: Double, longitude: Double) {
        let request = MKDirections.Request()
        guard let userLocation = locationManager.location else { return }
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.gymMapView.addOverlay(route.polyline)
                self.gymMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
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
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
}
