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
    private let locationManager = LocationManager()
    
    var places = [[String: Any]]()
    var isQueryPending = false
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupGymMapView()
        gymMapView?.delegate = self
        
        locationManager.start { location in
            self.centerMapView(on: location)
            self.queryFoursquare(with: location)
        }
    }
    
    // MARK: - Update Places on Map
    
    func centerMapView(on location: CLLocation) {
        guard gymMapView != nil else { return }

        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        let adjustedRegion = gymMapView!.regionThatFits(region)

        gymMapView!.setRegion(adjustedRegion, animated: true)
    }
    
    func queryFoursquare(with location: CLLocation) {
        FoursquareAPI.shared.query(location: location) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let places):
                self.places = places
                self.updatePlaces()
                
            case .failure(let error):
                self.presentMFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Dismiss")
            }
            
//            self.tableView.reloadData()
        }
    }
    
    private func updatePlaces() {
        guard gymMapView != nil else { return }
        
        gymMapView.removeAnnotations(gymMapView.annotations)
        
        for place in places {
            if let name = place["name"] as? String,
               let latitude = place["latitude"] as? CLLocationDegrees,
               let longitude = place["longitude"] as? CLLocationDegrees {
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                annotation.title = name
                gymMapView.addAnnotation(annotation)
            }
        }
    }
    
    // MARK: - Configure Methods
    
    private func setupGymMapView() {
        gymMapView = MKMapView(frame: view.bounds)
        gymMapView.translatesAutoresizingMaskIntoConstraints = false
        gymMapView.showsUserLocation = true
        gymMapView.showsBuildings = true
        gymMapView.showsCompass = true
        view.addSubview(gymMapView)
        
        NSLayoutConstraint.activate([
            gymMapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gymMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gymMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gymMapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

// MARK: - Map Extensions

extension GymFinderVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) { return nil }
        
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView")
        
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationView")
            view!.canShowCallout = true
//            view!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            view!.annotation = annotation
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let pin = view.annotation as? MKPointAnnotation {
            
            let latitude: CLLocationDegrees = pin.coordinate.latitude
            let longitude: CLLocationDegrees = pin.coordinate.longitude
            
            let regionDistance: CLLocationDistance = 1000
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
