//
//  CitiesViewModel.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/24/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
import ReactiveKit
import CoreLocation
import GoogleMaps

class CitiesViewModel {
    //Singleton to be accessible to both ViewController and CityTableViewController
    static let shared = CitiesViewModel()
    private init() {
    }
    
    private var remote = RemoteData()
    private var temp = TempData()

    //dispose bag
    let bag = DisposeBag()
    
    //Subjects
    let summaryOfAllCitiesDownloaded = PublishSubject<[City], Error>()
    let citySelected = PublishSubject<City, Never>()
    let cityDetailsDownloaded = PublishSubject<CityDetails, Error>()
    
    // MARK: - Properties to access Data
    var cities: [City] {
        return temp.cities
    }
    
    var countries: [Country] {
        return temp.countries
    }
    
    var countryNames: [String] {
        return temp.countries.map {
            $0.name
        }
    }

    var pickedCity: City? {
        get {
            return temp.currentlySelectedCity
        }
        set {
            temp.currentlySelectedCity = newValue
        }
    }
    
    var citiesBoundaries: [String: GMSCoordinateBounds] {
        get {
            return temp.boundingBoxes
        }
        set {
            temp.boundingBoxes = newValue
        }
    }
    
    func downloadInitialData() {
        //simulate slow connection
        //sleep(5)
        
        remote.downloadCountries()
            .observeNext { (countries) in
            self.temp.countries = countries
        }
            .dispose(in: bag)
        
        remote.downloadCities()
            .observeNext { (cities) in
            self.temp.cities = cities
            self.summaryOfAllCitiesDownloaded.on(.next(cities)) //notifies observers about new event
        }
            .dispose(in: bag)
    }
    
    func downloadCityDetails(city: City) {
        //bind the city details Subject to a city details Signal returned from Remote.DownloadCity
        cityDetailsDownloaded.bind(signal: remote.downloadCity(city: city)).dispose(in: bag)
    }
    
    func changePickedCity(countryIndex: Int, cityIndex: Int) {
        temp.currentlySelectedCity = getCitiesForCountry(countryIndex: countryIndex)[cityIndex]
    }
    
    func getCitiesForCountry(countryIndex: Int) -> [City] {
        let countryCode = temp.countries[countryIndex].code
        return temp.cities.filter({ (city) -> Bool in
            return city.country_code == countryCode
        })
    }
    
    func selectCity(city: City) {
        citySelected.on(.next(city))
    }
    
    //get the city that contains a specific coordinate
    func getCityWithWorkingAreaContainingLocation(loc: CLLocationCoordinate2D) -> City? {
        var res: City? = nil
        for cityCode in temp.boundingBoxes.keys {
            if let box = temp.boundingBoxes[cityCode] {
                if box.contains(loc) {
                    res = temp.cities.filter({ (city) -> Bool in
                        city.code == cityCode
                    }).first
                }
            }
        }
        return res
    }
}
