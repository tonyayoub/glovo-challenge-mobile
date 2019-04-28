//
//  CityTableAlertController.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/24/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import UIKit

class CityTableAlertController: UIAlertController {
    let countryTable = UITableView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
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
        //countryTable.reloadComponent(1)
        //updateSelectedCountryAndCity(countryIndex: 0, cityIndex: 0)
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
//        countryTable.delegate = self
        countryTable.dataSource = self
        countryTable.register(UITableViewCell.self, forCellReuseIdentifier: "CityCell")
        vc.view.addSubview(countryTable)
        
        self.setValue(vc, forKey: "contentViewController")
        self.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            CitiesViewModel.shared.updateCurrentCity()
        }))
        self.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
    
    
    
}

extension CityTableAlertController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return CitiesViewModel.shared.countries.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return CitiesViewModel.shared.countries[section].name
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CitiesViewModel.shared.getCitiesForCountry(countryIndex: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = countryTable.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        let cities = CitiesViewModel.shared.getCitiesForCountry(countryIndex: indexPath.section)
        cell.textLabel?.text = cities[indexPath.row].name
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    
}
