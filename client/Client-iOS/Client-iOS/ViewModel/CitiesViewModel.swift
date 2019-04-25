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
    private init() {}
    
    //Remote Data
    private var remote = RemoteData()
    
    
    var allCountries = [Country]()
    var allCities = [City]()
    var currentlySelectedCity: City?
    
    //dispose bag
    let bag = DisposeBag()
    let citySubject = PublishSubject<City, Never>()
    
    
    
    func downloadInitialData() {
        remote.downloadCountries()
            .observe { (element) in
                if let list = element.element {
                    self.allCountries = list
                    print(self.allCountries.map({ (country) -> String in
                        return country.name
                    }))
                }
            }.dispose(in: bag)
        
        
        remote.downloadCities()
            .observe { (element) in
                if let list = element.element {
                    self.allCities = list
                }
            }.dispose(in: bag)
        
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
