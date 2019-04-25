//
//  CitiesViewModel.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/24/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
import ReactiveKit

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
    let citySubject = PublishSubject<City, Never>()
    let cityDetailsSubject = PublishSubject<CityDetails, Never>()
    
    
    
    func downloadInitialData() {
        remote.downloadCountries()
            .observeNext { (countries) in
            self.allCountries = countries
        }
            .dispose(in: bag)
        
        remote.downloadCities()
            .observeNext { (cities) in
            self.allCities = cities
        }
            .dispose(in: bag)
    }
    
    func downloadCityDetails(city: City) {
        cityDetailsSubject.bind(signal: remote.downloadCity(city: city)).dispose(in: bag)
    }
    func getCitiesForCountry(countryIndex: Int) -> [City] {
        let countryCode = allCountries[countryIndex].code
        return allCities.filter({ (city) -> Bool in
            return city.country_code == countryCode
        })
    }
    

    func updateCurrentCity() {
        if let newCity = currentlySelectedCity {
            citySubject.on(.next(newCity))
        }
    }
}
