//
//  RemoteData.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/24/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation

class RemoteData {
    
    //Singleton
    static let shared = RemoteData()
    private init() {}
    
    //URLs
    let urlCountries = URL.init(string: "http://localhost:3000/api/countries/")
    let urlCities = URL.init(string: "http://localhost:3000/api/cities/")
    
    //URL Strings
    let urlStringCountries = "http://localhost:3000/api/countries/"

    let urlStringOneCity = "http://localhost:3000/api/cities/:"
    
    func downloadCountriesAndCities() {
        guard let url = URL.init(string: urlStringCountries) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            print(String.init(data: data!, encoding: .ascii) ?? "no data")

        }
        
        task.resume()
        /*
        if let url = URL.init(string: urlString) {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                print(String.init(data: data!, encoding: .ascii) ?? "no data")
                if let newMusic = try? JSONDecoder().decode(Music.self, from: data!) {
                    print (newMusic.guid ?? "no guid")
                    print (newMusic.music_url ?? "no url")
                }
            })
            task.resume()
        }
        
        */
    }
}
