//
//  TempData.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/27/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
import GoogleMaps

class TempData {
    var countries = [Country]()
    var cities = [City]()
    var currentCityDetails: CityDetails?
    var currentlySelectedCity: City?
    var boundingBoxes = [String: GMSCoordinateBounds]() //city code : bounding box
}
