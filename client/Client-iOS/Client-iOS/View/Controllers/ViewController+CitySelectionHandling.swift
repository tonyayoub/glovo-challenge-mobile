//
//  ViewController+CitySelectionHandling.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/27/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
extension ViewController: CitySelectionHandling {
    func handleAllCitiesSummaryDownloaded(cities: [City]) {
        print("all cities downloaded")
        for city in cities {
            CitiesViewModel.shared.citiesBoundaries[city.code] = mapView.getBoundingOfPolygons(polyLines: city.working_area)
            DispatchQueue.main.async {
                self.mapView.drawPolygons(polyLines: city.working_area)
            }
        }
        
    }
    
    func handleCitySelected(newCity: City) {
        print("city changed to \(newCity.name)")
        CitiesViewModel.shared.downloadCityDetails(city: newCity)
        if let box = CitiesViewModel.shared.citiesBoundaries[newCity.code] {
            DispatchQueue.main.async {
                self.mapView.moveCameraToBoundingBox(box: box)
            }
        }
    }
    
    func handleCityDetailsReady(newDetails: CityDetails) {
        print("city details ready \(newDetails.name)")
        DispatchQueue.main.async {
            self.infoView.updateCityDetails(cityDetails: newDetails)
        }
    }
}
