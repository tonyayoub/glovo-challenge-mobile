//
//  CitiesViewModel.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/24/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation

class CitiesViewModel {
    var allCountries = [Country]()
    var selectedCountry: Country?
    var selectedCity: City?
    
    func downloadInitialData() {
        RemoteData.shared.downloadCountriesAndCities()
    }
}
