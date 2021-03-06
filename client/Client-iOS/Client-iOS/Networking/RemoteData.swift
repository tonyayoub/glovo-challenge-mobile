//
//  RemoteData.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/24/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond

class RemoteData {
    
    #if targetEnvironment(simulator)
    let urlCountries = URL.init(string: "http://localhost:3000/api/countries/")
    let urlCities = URL.init(string: "http://localhost:3000/api/cities/")
    let urlStringOneCity = "http://localhost:3000/api/cities/"
    #else
    //URLs
    let urlCountries = URL.init(string: "http://192.168.43.126:3000/api/countries/")
    let urlCities = URL.init(string: "http://192.168.43.126:3000/api/cities/")
    let urlStringOneCity = "http://192.168.43.126:3000/api/cities/"
    #endif

    func downloadCountries() -> Signal<[Country], Never> {
        return Signal<[Country], Never> { [unowned self]observer in
            guard let url = self.urlCountries else {
                return BlockDisposable({
                })
            }
            let task = URLSession.shared.dataTask(with: url) { (downloadedData, response, error) in
                if let data = downloadedData {
                    if let countries = try? JSONDecoder().decode([Country].self, from: data) {
                        observer.next(countries)
                        observer.completed()
                    }
                }
            }
            task.resume()
            return BlockDisposable({
                task.cancel()
            })
        }
    }
    
    func downloadCities() -> Signal<[City], Never> {
        return Signal<[City], Never> { [unowned self]observer in
            guard let url = self.urlCities else {
                return BlockDisposable({
                })
            }
            let task = URLSession.shared.dataTask(with: url) { (downloadedData, response, error) in
                if let data = downloadedData {
                    if let cities = try? JSONDecoder().decode([City].self, from: data) {
                        observer.next(cities)
                        observer.completed()
                    }
                }
            }
            task.resume()
            return BlockDisposable({
                task.cancel()
            })
        }
    }
    
    func downloadCity(city: City) -> Signal<CityDetails, Never> {
        return Signal<CityDetails, Never> { [unowned self]observer in
            let urlString = "\(self.urlStringOneCity)\(city.code)"
            guard let url = URL.init(string: urlString) else {
                
                return BlockDisposable({
                })
            }
            let task = URLSession.shared.dataTask(with: url) { (downloadedData, response, error) in
                if let data = downloadedData {
                    if let city = try? JSONDecoder().decode(CityDetails.self, from: data) {
                        observer.next(city)
                        observer.completed()
                    }
                }
            }
            task.resume()
            return BlockDisposable({
                task.cancel()
            })
        }
    }
}
