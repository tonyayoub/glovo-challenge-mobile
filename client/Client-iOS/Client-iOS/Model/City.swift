//
//  City.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/23/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
struct City: Codable {
    var name = ""
    var code = ""
    var currency = ""
    var time_zone = ""
    var language_code = ""
    var country_code = ""
    var working_area = [String]()
    var enabled = true
    var busy = false
    
}
