//
//  InfoView.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/23/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveKit

//used to display city information in the lower section of the main view
class InfoView: UIView {
    //upper section contains the city and country labels
    var upperContainer = UIView()
    var cityName = UILabel()
    var countryName = UILabel()
    
    //lower view is divided into 4 sections
    var lowerContainer = UIView()
    
    var currencyContainer = UIView()
    var timeZoneContainer = UIView()
    var languageContainer = UIView()
    var selectContainer = UIView()
    
    var currencyTitle = UILabel()
    var currencyValue = UILabel()
    var timeZoneTitle = UILabel()
    var timeZoneValue = UILabel()
    var languageCodeTitle = UILabel()
    var languageCodeValue = UILabel()
    
    var selectCity = UIButton()
    var currentLocation = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addViews()
        adjustLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        self.backgroundColor = .white
        
        cityName.text = ""
        cityName.textAlignment = .center
        cityName.font = UIFont(name: "Optima-Bold", size: 32)
        
        countryName.text = ""
        countryName.textAlignment = .center
        countryName.font = UIFont(name: "Optima-Bold", size: 16)
        
        selectCity.setTitle("Select City", for: .normal)
        selectCity.setTitleColor(.blue, for: .normal)
        
        currentLocation.setTitle("Current", for: .normal)
        currentLocation.setTitleColor(.blue, for: .normal)
        
        currencyTitle.text = "Curr:"
        currencyTitle.textAlignment = .center
        
        timeZoneTitle.text = "Zone:"
        timeZoneTitle.textAlignment = .center
        
        languageCodeTitle.text = "Lang:"
        languageCodeTitle.textAlignment = .center
    }
    
    func updateCityDetails(cityDetails: CityDetails) {
        self.cityName.text = cityDetails.name
        self.countryName.text = cityDetails.country_code
        self.currencyValue.text = cityDetails.currency
        self.timeZoneValue.text = cityDetails.time_zone
        self.languageCodeValue.text = cityDetails.language_code
    }

    func addViews() {
        addSubview(upperContainer)
        upperContainer.addSubview(cityName)
        upperContainer.addSubview(countryName)
        upperContainer.addSubview(selectCity)
        
        addSubview(lowerContainer)
        lowerContainer.addSubview(currencyContainer)
        lowerContainer.addSubview(timeZoneContainer)
        lowerContainer.addSubview(languageContainer)
        lowerContainer.addSubview(selectContainer)
        
        currencyContainer.addSubview(currencyTitle)
        currencyContainer.addSubview(currencyValue)
        
        timeZoneContainer.addSubview(timeZoneTitle)
        timeZoneContainer.addSubview(timeZoneValue)
        
        languageContainer.addSubview(languageCodeTitle)
        languageContainer.addSubview(languageCodeValue)
        
        selectContainer.addSubview(selectCity)
        selectContainer.addSubview(currentLocation)
    }
    
    func adjustLayouts() {
        //upper section
        upperContainer.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.5)
        }
        cityName.snp.makeConstraints { (make) in
            make.left.top.width.equalTo(upperContainer)
            make.height.equalTo(upperContainer).multipliedBy(0.7)
        }
        countryName.snp.makeConstraints { (make) in
            make.left.bottom.width.equalTo(upperContainer)
            make.height.equalTo(upperContainer).multipliedBy(0.3)

        }
     
        
        //lower section
        lowerContainer.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(upperContainer.snp.bottom)
        }
        
        //containers
        //top left: currency
        currencyContainer.snp.makeConstraints { (make) in
            make.top.left.equalTo(lowerContainer)
            make.width.height.equalTo(lowerContainer).multipliedBy(0.5)
        }
        currencyTitle.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(currencyContainer)
            make.width.equalTo(currencyContainer).multipliedBy(0.5)
        }
        currencyValue.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(currencyContainer)
            make.width.equalTo(currencyTitle)
        }
        
        
        // top right: time zone
        timeZoneContainer.snp_makeConstraints { (make) in
            make.top.right.equalTo(lowerContainer)
            make.width.height.equalTo(lowerContainer).multipliedBy(0.5)
        }
        timeZoneTitle.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(timeZoneContainer)
            make.width.equalTo(timeZoneContainer).multipliedBy(0.5)
        }
        timeZoneValue.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(timeZoneContainer)
            make.width.equalTo(timeZoneTitle)
        }
        
        //lower left: language
        languageContainer.snp.makeConstraints { (make) in
            make.bottom.left.equalTo(lowerContainer)
            make.width.height.equalTo(lowerContainer).multipliedBy(0.5)
        }
        languageCodeTitle.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(languageContainer)
            make.width.equalTo(languageContainer).multipliedBy(0.5)
        }
        languageCodeValue.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(languageContainer)
            make.width.equalTo(languageCodeTitle)
        }
        
        //lower right
        selectContainer.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(lowerContainer)
            make.width.height.equalTo(lowerContainer).multipliedBy(0.5)
        }
        
        selectCity.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(selectContainer)
            make.width.equalTo(selectContainer).multipliedBy(0.5)
        }
        currentLocation.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(selectContainer)
            make.left.equalTo(selectCity.snp.right)
        }
    }
}


