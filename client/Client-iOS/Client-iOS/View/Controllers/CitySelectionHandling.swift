//
//  CitySelectionHandling.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/27/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
protocol CitySelectionHandling{
    func handleCitySelected(newCity: City)
    func handleAllCitiesSummaryDownloaded(cities: [City])
    func handleCityDetailsReady(newDetails: CityDetails)
}
