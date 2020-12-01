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
    
    // MARK: - Properties and Variables
    
    var gymMapView: MKMapView!
    private let locationManager = CLLocationManager()
    private var userTrackingButton: MKUserTrackingButton!
    var arrayOfResults: [MKMapItem] = []
    
    var gym: MKPointOfInterestCategory = .fitnessCenter
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        attemptLocationAccess()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        locationManager.requestWhenInUseAuthorization()
        
        setupGymMapView()
        setupUserTrackingButton()
    }
    
    // MARK: - Location Methods
    
    func attemptLocationAccess() {
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                
                let ac = UIAlertController(title: "Error Finding Gyms", message: "You need to enable location services in order to get gyms near you.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings)
                    }
                }
                ac.addAction(settingsAction)
                
                present(ac, animated: true, completion: nil)
                
                return
            case .authorizedAlways, .authorizedWhenInUse:
                
                locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
                locationManager.delegate = self
                locationManager.requestLocation()
                
                guard let location = locationManager.location else { return }
                gymMapView.centerToLocation(location)
                gymMapView.showsUserLocation = true
                
                searchInMap()
                
            @unknown default:
                break
            }
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
            self.arrayOfResults.removeAll()
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
    
    // MARK: - Configure Methods
    
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

// MARK: - Extensions for Maps

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
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let pin = view.annotation as? MKPointAnnotation {
            
            let latitude: CLLocationDegrees = pin.coordinate.latitude
            let longitude: CLLocationDegrees = pin.coordinate.longitude
            
            let regionDistance:CLLocationDistance = 1000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = pin.title
            mapItem.openInMaps(launchOptions: options)
        }
    }
    
}
