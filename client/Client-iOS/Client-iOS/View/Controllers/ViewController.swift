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
    lazy var mapView = MapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViews()
        addViews()
        adjustLayouts()
        mapView.test()
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
        DispatchQueue.main.async {
            self.mapView.drawAllCitiesPolygons(cities: cities)
        }
    }
    func handleCitySelected(newCity: City) {
        print("city changed to \(newCity.name)")
        CitiesViewModel.shared.downloadCityDetails(city: newCity)
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
        if CitiesViewModel.shared.allCities.count >= 1 {
            self.present(pickCityAlert, animated: true)
        }
        else {
            print("Connection Error")
        }
    }


}
