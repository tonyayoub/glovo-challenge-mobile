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
    lazy var mapView: GMSMapView = {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        return GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViews()
        addViews()
        adjustLayouts()
        initializeViewModel()

    }
    
    override func viewDidAppear(_ animated: Bool) {
//        showCityPicker()
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
    
    func showCityPicker() {
        let vc = SelectCityViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
//        pickerView.delegate = self
//        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: "Choose distance", message: "", preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
    }
    
    func createGoogleMap() -> GMSMapView{
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        return GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
    }

}
