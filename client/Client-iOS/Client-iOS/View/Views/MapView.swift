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
        let camera = GMSCameraPosition.camera(withLatitude: 41.39440574740914, longitude: 2.146495096385479, zoom: 10)
        super.init(frame: CGRect.zero, camera: camera)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //calculate the bounding box of an array of polylines to be used to fit them on screen
    func getBoundingOfPolygons(polyLines: [String]) -> GMSCoordinateBounds {
        var bounds = GMSCoordinateBounds()
        for polyLine in polyLines {
            if let path = GMSPath(fromEncodedPath: polyLine) {
                bounds = bounds.includingPath(path)
            }
        }
        return bounds
    }
    
    //draw markers on the map and saves user defined object
    func drawMarkerAtCenterOfBounds(box: GMSCoordinateBounds, title: String, data: Any) {
        let sw = box.southWest
        let ne = box.northEast
        let avglat = (sw.latitude + ne.latitude) / 2 //this is approximate not accurate because earth is not flat
        let avglong = (sw.longitude + ne.longitude) / 2
        let markerLoc = CLLocationCoordinate2D(latitude: avglat, longitude: avglong)
        drawMarkerInLocation(loc: markerLoc, title: title, data: data)
    }
    
    //draw a number of polygons on the map
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
        self.animate(with: update)
    }
    
    func drawMarkerInLocation(loc: CLLocationCoordinate2D, title: String, data: Any) {
        let marker = GMSMarker(position: loc)
        marker.title = title
        marker.map = self
        marker.userData = data
        markers.append(marker)
    }
    
    // to show or hide markers as per the zooming level
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
    
    //uses GPC algorithm to draw a union of polygons - not working correctly with all cities - not used now
    func drawUnionPolygon(polyLines: [String]) {
        let unionPth = getUnionOfPolygons(polylines: polyLines)
        let polygon = GMSPolygon(path: unionPth)
        polygon.map = self
    }
    
    func getCoordinatesForPath(path: GMSPath) -> [CLLocationCoordinate2D] {
        var res = [CLLocationCoordinate2D]()
        for i in 0..<path.count() {
            res.append(path.coordinate(at: i))
        }
        return res
    }
    func getUnionOfPolygons(polylines: [String]) -> GMSPath? {
        let firstPoly = polylines.first!
        let firstPath = GMSPath(fromEncodedPath: firstPoly)!
        let coords = getCoordinatesForPath(path: firstPath)
        
        var unionMapKitPolygon = MKPolygon(coordinates: coords, count: coords.count)
        unionMapKitPolygon = MKPolygon()
        for polyLine in polylines {
            if polyLine == "" {
                continue
            }
            let pathCoordinates: [CLLocationCoordinate2D] = getCoordinatesForPath(path: GMSPath(fromEncodedPath: polyLine)!)
            let mkPolygon = MKPolygon(coordinates: pathCoordinates, count: pathCoordinates.count)
            unionMapKitPolygon = unionMapKitPolygon.fromUnion(with: mkPolygon)
        }
        
        
        var unionPoints = [CLLocationCoordinate2D]()
        let gmsPath = GMSMutablePath()
        for i in 0..<unionMapKitPolygon.pointCount {
            gmsPath.add(unionMapKitPolygon.points()[i].coordinate)
            unionPoints.append(unionMapKitPolygon.points()[i].coordinate)
        }
        
        return gmsPath
    }
    
}
