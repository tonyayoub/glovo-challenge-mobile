//
//  CityPickerAlertController.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/24/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import UIKit

class CityPickerAlertController: UIAlertController {
    let countryPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
    var citiesInSelectedCountry = [City]()
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryPicker.reloadComponent(1)
        updateSelectedCountryAndCity(countryIndex: 0, cityIndex: 0)
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        countryPicker.delegate = self
        countryPicker.dataSource = self
        vc.view.addSubview(countryPicker)
        
        self.setValue(vc, forKey: "contentViewController")
        self.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            CitiesViewModel.shared.updateCurrentCity()
        }))
        self.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
    
    
}

extension CityPickerAlertController: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return CitiesViewModel.shared.countries.count
        case 1:
            let cities = CitiesViewModel.shared.getCitiesForCountry(countryIndex: pickerView.selectedRow(inComponent: 0))
            return cities.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //selecting a country
        if component == 0 {
            
            pickerView.reloadComponent(1)
            updateSelectedCountryAndCity(countryIndex: row, cityIndex: 0)
        }
            //selecting a city
        else if component == 1 {
            updateSelectedCountryAndCity(countryIndex: countryPicker.selectedRow(inComponent: 0), cityIndex: row)
        }
    }
    
    func updateSelectedCountryAndCity(countryIndex: Int, cityIndex: Int) {
        CitiesViewModel.shared.changePickedCity(countryIndex: countryIndex, cityIndex: cityIndex)
    }
}



extension CityPickerAlertController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return CitiesViewModel.shared.countryNames[row]
        case 1:
            citiesInSelectedCountry = CitiesViewModel.shared.getCitiesForCountry(countryIndex: countryPicker.selectedRow(inComponent: 0))
            return citiesInSelectedCountry[row].name
        default:
            return ""
        }
        
    }
}
