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


    

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryPicker.selectRow(countryPicker.numberOfRows(inComponent: 0)/2, inComponent: 0, animated: true)
        countryPicker.reloadComponent(1)

        // Do any additional setup after loading the view.
    }
    
    func setup() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        countryPicker.delegate = self
        countryPicker.dataSource = self
        vc.view.addSubview(countryPicker)

        

        
        self.setValue(vc, forKey: "contentViewController")
        self.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        self.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

    }
    
    override func viewDidLayoutSubviews() {

    }


}

extension CityPickerAlertController: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return CitiesViewModel.shared.allCountries.count
        case 1:
            let cities = CitiesViewModel.shared.getCitiesForCountry(countryIndex: pickerView.selectedRow(inComponent: 0))
            return cities.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerView.reloadComponent(1)
            let numberOfCities = countryPicker.numberOfRows(inComponent: 1)
            if numberOfCities > 2 {
                countryPicker.selectRow(numberOfCities/2 - 1, inComponent: 1, animated: true)
            }

            
        }
    }
}

extension CityPickerAlertController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            let names = CitiesViewModel.shared.allCountries.map { (country) -> String in
                return country.name
            }
            return names[row]
        case 1:
            let cities = CitiesViewModel.shared.getCitiesForCountry(countryIndex: countryPicker.selectedRow(inComponent: 0))
            return cities[row].name
        default:
            return ""
        }

    }
}
