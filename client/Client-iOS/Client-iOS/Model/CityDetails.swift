//
//  CityDetails.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/24/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
struct CityDetails: Codable {
    var working_area = [String]()
    var code = ""
    var name = ""
    var country_code = ""
    var currency = ""
    var time_zone = ""
    var language_code = ""
    var enabled = true
    var busy = false
}
