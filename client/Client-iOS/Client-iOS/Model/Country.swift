//
//  Country.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/23/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
struct Country: Codable {
    var name = ""
    var code = ""
    var cities = [City]()
}
