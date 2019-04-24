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
    
    //Network
    private var remote = RemoteData()
    
    
    var allCountries = [Country]()
    var allCities = [City]()
    var selectedCountry: Country?
    var selectedCity: City?
    
    //ReactiveKit dispose bag
    let bag = DisposeBag()
    
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
}
