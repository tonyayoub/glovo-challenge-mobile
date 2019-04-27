//
//  ViewController.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/23/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import ReactiveKit

class ViewController: UIViewController {

    var infoView = InfoView()
    lazy var mapView = MapView()
    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViews()
        addViews()
        adjustLayouts()
        initializeViewModel()
        initializeLocation()
    }
    override func viewDidLayoutSubviews() {
       // adjustLayouts()
    }
    
    func initializeViews() {
        infoView.selectCity.reactive.controlEvents(.touchUpInside).observeNext {
            self.showCityPicker()
        }.dispose(in: bag)
    }
    
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
    func initializeViewModel() {
        DispatchQueue.global().async {
            CitiesViewModel.shared.downloadInitialData()
        }
        
        //subscribe to new events:
        //1. cities list downloaded
        //2. city selected (manually or by navigating to location)
        //3. details of selected city downloaded
        
        CitiesViewModel.shared.summaryOfAllCitiesDownloaded.observeNext { (cities) in
            self.handleAllCitiesSummaryDownloaded(cities: cities)
        }.dispose(in: bag)
        
        CitiesViewModel.shared.citySelected.observeNext { (city) in
            self.handleCitySelected(newCity: city)
        }.dispose(in: bag)
        
        CitiesViewModel.shared.cityDetailsDownloaded.observeNext { [unowned self](cityDetails) in
            self.handleCityDetailsReady(newDetails: cityDetails)
        }.dispose(in: bag)
        

    }
    func handleAllCitiesSummaryDownloaded(cities: [City]) {
        print("all cities downloaded")
        for city in cities {
            CitiesViewModel.shared.citiesBoundaries[city.code] = mapView.getBoundingOfPolygons(polyLines: city.working_area)
            DispatchQueue.main.async {
                self.mapView.drawPolygons(polyLines: city.working_area)
            }
        }
        
    }
    
    func handleCitySelected(newCity: City) {
        print("city changed to \(newCity.name)")
        CitiesViewModel.shared.downloadCityDetails(city: newCity)
        if let box = CitiesViewModel.shared.citiesBoundaries[newCity.code] {
            DispatchQueue.main.async {
                self.mapView.moveCameraToBoundingBox(box: box)
            }
        }
    }
    
    func handleCityDetailsReady(newDetails: CityDetails) {
        print("city details ready \(newDetails.name)")
        DispatchQueue.main.async {
            self.infoView.updateCityDetails(cityDetails: newDetails)
        }
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
        if CitiesViewModel.shared.cities.count >= 1 {
            self.present(pickCityAlert, animated: true)
        }
        else {
            print("Connection Error")
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        let loc2D = location.coordinate
        print(loc2D)
        if let city = CitiesViewModel.shared.getCityWithWorkingAreaContainingLocation(loc: loc2D) {
            handleCitySelected(newCity: city)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        case .notDetermined:
            print("Location status is unknown.")
        @unknown default:
            print("Location status not determined.")
        }
    }

}
