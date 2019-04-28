//
//  ViewController+GMSMapViewDelegate.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/27/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
import GoogleMaps

extension ViewController: GMSMapViewDelegate {
    func initializeMap() {
        mapView.delegate = self
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if let map = mapView as? MapView {
            map.showAllMarkers(hide: (mapView.camera.zoom > 8))
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let city = marker.userData as? City {
            handleCitySelected(newCity: city)
        }
        return true
    }
}
