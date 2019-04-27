//
//  ViewController.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/23/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import UIKit
import GoogleMaps
import ReactiveKit

class ViewController: UIViewController {

    var infoView = InfoView()
    var mapView = MapView()
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D?
    var currentLocationDisplayedAtStartUp = false
    let locationChanged = PublishSubject<CLLocationCoordinate2D, Never>()


    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViews()
        addViews()
        adjustLayouts()
        initializeViewModel()
        initializeLocation()
        initializeMap()
    }
    override func viewDidLayoutSubviews() {
       // adjustLayouts()
    }
    
    func initializeViews() {
        infoView.selectCity.reactive.controlEvents(.touchUpInside).observeNext {
            self.showCityPicker()
        }.dispose(in: bag)
        
        infoView.currentLocation.reactive.controlEvents(.touchUpInside).observeNext {
            self.displayCurrentLocation()
        }.dispose(in: bag)
    }
    

    func initializeViewModel() {
        DispatchQueue.global().async {
            CitiesViewModel.shared.downloadInitialData()
        }
        
        //subscribe to new events:
        //1. cities list downloaded
        //2. city selected (manually or by navigating to location)
        //3. details of selected city downloaded
        //4. location updated
        
        CitiesViewModel.shared.summaryOfAllCitiesDownloaded.observeNext { (cities) in
            self.handleAllCitiesSummaryDownloaded(cities: cities)
        }.dispose(in: bag)
        
        CitiesViewModel.shared.citySelected.observeNext { (city) in
            self.handleCitySelected(newCity: city)
        }.dispose(in: bag)
        
        CitiesViewModel.shared.cityDetailsDownloaded.observeNext { [unowned self](cityDetails) in
            self.handleCityDetailsReady(newDetails: cityDetails)
        }.dispose(in: bag)
        
        locationChanged.observeNext { (loc) in
            print("observed location: \(loc)")
            self.currentLocation = loc
            if !self.currentLocationDisplayedAtStartUp {
                self.displayCurrentLocation()
                self.currentLocationDisplayedAtStartUp = true
            }
        }.dispose(in: bag)
    }

    func addViews() {
        view.addSubview(mapView)
        view.addSubview(infoView)
    }
    
    // adjust layout for the two main views
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
            showConnectionError()
            CitiesViewModel.shared.downloadInitialData()
        }
    }
    
    func suggestManualSelection(message: String) {
        let alert = UIAlertController(title: "Location Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
            self.showCityPicker()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showConnectionError() {
        let alert = UIAlertController(title: "Connection Error", message: "Remote data not available", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}


