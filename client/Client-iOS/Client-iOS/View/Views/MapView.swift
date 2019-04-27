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
    
    //    let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
    init() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
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
        
        //        let bounds = GMSCoordinateBounds(path: path)
        //        let update = GMSCameraUpdate.fit(bounds)
        //        self.moveCamera(update)
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
