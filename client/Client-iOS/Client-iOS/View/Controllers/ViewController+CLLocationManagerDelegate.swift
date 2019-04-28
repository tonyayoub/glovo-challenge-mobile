//
//  ViewController+CLLocationManagerDelegate.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/27/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

extension ViewController: CLLocationManagerDelegate {
    func initializeLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager?.startUpdatingLocation()
        }
        else {
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationChanged.on(.next(location.coordinate))
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            suggestManualSelection(message: "Location services denied. Would you like to select a city manually?")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        case .notDetermined:
            print("Location status is unknown.")
        @unknown default:
            print("Location status not determined.")
        }
    }
    
    func displayCurrentLocation() {
        guard let currentLoc = currentLocation else {
            suggestManualSelection(message: "Your current location is not available. Would you like to select a city manually?")
            return
        }
        if let city = CitiesViewModel.shared.getCityWithWorkingAreaContainingLocation(loc: currentLoc) {
            handleCitySelected(newCity: city)
        }
        else {
            mapView.moveCamera(GMSCameraUpdate.setTarget(currentLoc))
            suggestManualSelection(message: "Your current location is outside working areas. Would you like to select a city manually?")
        }
    }
    
}
