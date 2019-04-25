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
import ReactiveKit

class ViewController: UIViewController {

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
        infoView.selectCity.reactive.controlEvents(.touchUpInside).observeNext {
            self.showCityPicker()
        }.dispose(in: bag)

    }
    
    func initializeViewModel() {
        CitiesViewModel.shared.downloadInitialData()
        CitiesViewModel.shared.citySubject.observeNext { (city) in
            self.handleCityChanged(newCity: city)
        }.dispose(in: CitiesViewModel.shared.bag)
        
        CitiesViewModel.shared.cityDetailsSubject.observeNext { (cityDetails) in
            self.handleCityDetailsReady(newDetails: cityDetails)
        }.dispose(in: bag)
    }
    func handleCityChanged(newCity: City) {
        print("city changed to \(newCity.name)")
        CitiesViewModel.shared.downloadCityDetails(city: newCity)
    }
    
    func handleCityDetailsReady(newDetails: CityDetails) {
        print("city details ready \(newDetails.name)")
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
        let pickCityAlert = CityPickerAlertController(title: "Choose City", message: "", preferredStyle: UIAlertController.Style.alert)
        self.present(pickCityAlert, animated: true)
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
