//
//  ViewController.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/23/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SnapKit
import GoogleMaps

class ViewController: UIViewController {

    var viewModel = CitiesViewModel()
    var infoView = InfoView()
    var mapView = MKMapView()
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViews()
        initializeViewModel()
        createGoogleMap()
//        addViews()
//        adjustLayouts()
    }
    
    override func viewDidLayoutSubviews() {
       // adjustLayouts()
    }
    
    func initializeViews() {
        
    }
    
    func initializeViewModel() {
        viewModel.downloadInitialData()
    }
    func addViews() {
        view.addSubview(mapView)
        view.addSubview(infoView)
    }
    
    func adjustLayouts() {
       
        //map view
        mapView.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.7)
        }
        
        //information panel
        infoView.snp.makeConstraints { (make) in
            make.bottom.right.left.equalTo(view)
            make.top.equalTo(mapView.snp.bottom)
            
        }
    }
    
    func createGoogleMap() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }

}
