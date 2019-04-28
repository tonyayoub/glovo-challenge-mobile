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
    let summaryOfAllCitiesDownloaded = PublishSubject<[City], Never>()
    let citySelected = PublishSubject<City, Never>()
    let cityDetailsDownloaded = PublishSubject<CityDetails, Never>()
    
    //Properties to access Data
    var cities: [City] {
        return temp.allCities
    }
    
    var countries: [Country] {
        return temp.allCountries
    }
    
    var countryNames: [String] {
        return temp.allCountries.map {
            $0.name
        }
    }
    
    var citiesDictionary: [Country: [City]] {
        return temp.countriesAndCities
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
            self.temp.allCountries = countries
        }
            .dispose(in: bag)
        
  
        remote.downloadCities()
            .observeNext { (cities) in
            self.temp.allCities = cities
            self.fillDictionary()
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
        let countryCode = temp.allCountries[countryIndex].code
        return temp.allCities.filter({ (city) -> Bool in
            return city.country_code == countryCode
        })
    }
    
    func updateCurrentCity(newCity: City) {
        citySelected.on(.next(newCity))
    }
    
    func getCountryWithCode(code: String) -> Country? {
        return temp.allCountries.filter{ country in
            country.code == code
        }.first
    }
    
    func fillDictionary() {
        for city in temp.allCities {
            if let cityCountry = getCountryWithCode(code: city.country_code) {
                if let _ = temp.countriesAndCities[cityCountry] {
                    temp.countriesAndCities[cityCountry]?.append(city)
                }
                else { //new country will be inserted
                    var newCitiesList = [City]()
                    newCitiesList.append(city)
                    temp.countriesAndCities[cityCountry] = newCitiesList
                }
            }
            
        }
    }
    func getCityWithWorkingAreaContainingLocation(loc: CLLocationCoordinate2D) -> City? {
        var res: City? = nil
        for cityCode in temp.boundingBoxes.keys {
            if let box = temp.boundingBoxes[cityCode] {
                if box.contains(loc) {
                    res = temp.allCities.filter({ (city) -> Bool in
                        city.code == cityCode
                    }).first
                }
            }
        }
        return res
    }
}
