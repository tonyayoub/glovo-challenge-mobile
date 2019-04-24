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
    
    //Singleton
    static let shared = RemoteData()
    private init() {}
    
    //URLs
    let urlCountries = URL.init(string: "http://localhost:3000/api/countries/")
    let urlCities = URL.init(string: "http://localhost:3000/api/cities/")
    
    //URL Strings

    let urlStringOneCity = "http://localhost:3000/api/cities/:"
    
    func downloadCountriesAndCities() {
        guard let url = urlCountries else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (downloadedData, response, error) in
            if let data = downloadedData {
                print(String.init(data: data, encoding: .ascii) ?? "no data")
                if let list = try? JSONDecoder().decode([Country].self, from: data) {
                    print(list)
                }
            }


        }
        
        task.resume()
    }
    
    

    func downloadCountries() -> Signal<[Country], Error> {
        return Signal<[Country], Error> { [unowned self]observer in
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
    
    func downloadCities() -> Signal<[City], Error> {
        return Signal<[City], Error> { [unowned self]observer in
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
    func downloadCountriesAndCitiesSignal(){
        let counter = Signal<Int, Never> { observer in
            
            // send first three positive integers
            observer.next(1)
            observer.next(2)
            observer.next(3)
            // send completed event
            observer.completed()
            
            return BlockDisposable({
                print("block caled ...........!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
            })
        }
        
        let bag = DisposeBag()
        counter.observe { (event) in
            print(event.element ?? 0)
        }.dispose(in: bag)
        
        
        
    }
}
