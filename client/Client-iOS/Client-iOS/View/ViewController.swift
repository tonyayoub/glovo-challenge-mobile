//
//  ViewController.swift
//  Client-iOS
//
//  Created by Tony Ayoub on 4/23/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SnapKit

class ViewController: UIViewController {

    var infoView = InfoView()
    var mapView = MKMapView()
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        adjustLayouts()
    }
    
    override func viewDidLayoutSubviews() {
        adjustLayouts()
    }
    
    func addViews() {
        view.addSubview(mapView)
        view.addSubview(infoView)
    }
    
    func adjustLayouts() {
       
        //map view
        mapView.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.7)
        }
        
        //information panel
        infoView.snp.makeConstraints { (make) in
            make.bottom.right.left.equalTo(view)
            make.top.equalTo(mapView.snp.bottom)
            
        }
    }

}
