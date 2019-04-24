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
    var allCountries = [Country]()
    var selectedCountry: Country?
    var selectedCity: City?
    let bag = DisposeBag()
    
    func downloadInitialData() {
        RemoteData.shared.downloadCountries()
            .observe { (element) in
                if let list = element.element {
                    self.allCountries = list
                    print(self.allCountries.map({ (country) -> String in
                        return country.name
                    }))
                }
            }.dispose(in: bag)
        
        
        RemoteData.shared.downloadCities()
            .observe { (element) in
                if let list = element.element {
                    print(list)
                }
            }.dispose(in: bag)
        
    }
}
