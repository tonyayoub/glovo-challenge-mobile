//
//  MapView.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/23/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import UIKit
import GoogleMaps
import MKPolygon_GPC

class MapView: GMSMapView {
    var markers = [GMSMarker]()
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
    
    func drawMarkerAtCenterOfBounds(box: GMSCoordinateBounds, title: String, data: Any) {
        let sw = box.southWest
        let ne = box.northEast
        let avglat = (sw.latitude + ne.latitude) / 2 //this is approximate not accurate because earth is not flat
        let avglong = (sw.longitude + ne.longitude) / 2
        let markerLoc = CLLocationCoordinate2D(latitude: avglat, longitude: avglong)
        drawMarkerInLocation(loc: markerLoc, title: title, data: data)
    }
    
    func drawPolygons(polyLines: [String]) {
        print("polygons drawn")
        for polyLine in polyLines {
            if let path = GMSPath(fromEncodedPath: polyLine) {
                var bounds = GMSCoordinateBounds(path: path)
                let polygon = GMSPolygon(path: path)
                polygon.map = self
            }
        }
    }
    
    func getCenterOfBounds(bounds: GMSCoordinateBounds) -> CLLocationCoordinate2D? {
        var sw = bounds.southWest
        var ne = bounds.northEast
        return nil
    }
    func getCoordinatesForPath(path: GMSPath) -> [CLLocationCoordinate2D] {
        var res = [CLLocationCoordinate2D]()
        for i in 0...path.count() {
            res.append(path.coordinate(at: i))
        }
        return res
    }
    func getUnionOfPolygons(polylines: [String]) -> GMSPolygon? {
        let pathCoordinates: [CLLocationCoordinate2D] = getCoordinatesForPath(path: GMSPath(fromEncodedPath: polylines.first!)!)
        var res = MKPolygon(coordinates: pathCoordinates, count: pathCoordinates.count)
        
        for polyLine in polylines {
            let pathCoordinates: [CLLocationCoordinate2D] = getCoordinatesForPath(path: GMSPath(fromEncodedPath: polyLine)!)
            var mkPolygon = MKPolygon(coordinates: pathCoordinates, count: pathCoordinates.count)
            res = res.fromUnion(with: mkPolygon)
        }
        
        var x = res.points()
        for i in 0...res.pointCount {
            var p = res.points()[i].coordinate
            print(p)
        }
        
        return nil
//        var newCoordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
//        let coordsPointer = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: newCoordinates.count)
////        coordsPointer.initialize(from: newCoordinates, count: newCoordinates.count)
//
//
//        var range: NSRange = NSRange(
//        res.getCoordinates(coordsPointer, range: 0...newCoordinates.count)
    }
    func moveCameraToBoundingBox(box: GMSCoordinateBounds) {
        let update = GMSCameraUpdate.fit(box)
        
        self.animate(with: update)
    }
    
    
    
    func drawMarkerInLocation(loc: CLLocationCoordinate2D, title: String, data: Any) {
        let marker = GMSMarker(position: loc)
        marker.title = title
        marker.map = self
        marker.userData = data
        markers.append(marker)
    }
    
    func showAllMarkers(hide: Bool) {
        for marker in markers {
            if hide {
                marker.map = nil
            }
            else {
                marker.map = self
            }
        }
    }
    
}
