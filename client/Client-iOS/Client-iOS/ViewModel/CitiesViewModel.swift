//
//  CitiesViewModel.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/24/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
import ReactiveKit
import GoogleMaps

class CitiesViewModel {
    //Singleton
    static let shared = CitiesViewModel()
    private init() {
        
    }
    
    //Remote Data
    private var remote = RemoteData()
    
    
    var allCountries = [Country]()
    var allCities = [City]()
    var currentCityDetails: CityDetails?
    var currentlySelectedCity: City?
    
    //dispose bag
    let bag = DisposeBag()
    
    //Subjects - keep being updated
    let summaryOfAllCitiesDownloaded = PublishSubject<[City], Never>()
    let citySelected = PublishSubject<City, Never>()
    let cityDetailsDownloaded = PublishSubject<CityDetails, Never>()
    
    
    
    func downloadInitialData() {
        //simulate slow connection
        //sleep(5)
        
        remote.downloadCountries()
            .observeNext { (countries) in
            self.allCountries = countries
        }
            .dispose(in: bag)
        
  
        remote.downloadCities()
            .observeNext { (cities) in
            self.allCities = cities
            self.summaryOfAllCitiesDownloaded.on(.next(cities)) //notifies observers about new event
        }
            .dispose(in: bag)
    }
    
    func downloadCityDetails(city: City) {
        //bind the city details Subject to a city details Signal returned from Remote.DownloadCity
        cityDetailsDownloaded.bind(signal: remote.downloadCity(city: city)).dispose(in: bag)
    }
    func getCitiesForCountry(countryIndex: Int) -> [City] {
        let countryCode = allCountries[countryIndex].code
        return allCities.filter({ (city) -> Bool in
            return city.country_code == countryCode
        })
    }
    

    func updateCurrentCity() {
        if let newCity = currentlySelectedCity {
            citySelected.on(.next(newCity))
        }
    }
}
