//
//  MapView.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/23/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import UIKit
import GoogleMaps

class MapView: GMSMapView {
    
    init() {
        let camera = GMSCameraPosition.camera(withLatitude: 41.39440574740914, longitude: 2.146495096385479, zoom: 12.083862)
        super.init(frame: CGRect.zero, camera: camera)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getBoundingOfPolygons(polyLines: [String]) -> GMSCoordinateBounds {
        var bounds = GMSCoordinateBounds()
        for polyLine in polyLines {
            if let path = GMSPath(fromEncodedPath: polyLine) {
                bounds = bounds.includingPath(path)
            }
        }
        return bounds
    }
    
    func drawPolygons(polyLines: [String]) {
        for polyLine in polyLines {
            if let path = GMSPath(fromEncodedPath: polyLine) {
                let polygon = GMSPolygon(path: path)
                polygon.map = self
            }
        }
    }
    
    func moveCameraToBoundingBox(box: GMSCoordinateBounds) {
        let update = GMSCameraUpdate.fit(box)
        self.moveCamera(update)
    }
    
    func getPathFromCoordinates(coordinatesList: [CLLocationCoordinate2D]) -> GMSMutablePath {
        let path = GMSMutablePath()
        for coord in coordinatesList {
            path.add(coord)
        }
        return path
    }
    
    
    
}
