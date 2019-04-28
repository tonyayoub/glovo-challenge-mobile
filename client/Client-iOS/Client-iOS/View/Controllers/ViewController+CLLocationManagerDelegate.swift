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
    
    // Handles incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationChanged.on(.next(location.coordinate))
        }
    }
    
    // Handles authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            suggestManualSelection(message: "Location services denied. Would you like to select a city manually?")
        }
    }
    
    //shows current location on map if it is contained inside a working area
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
