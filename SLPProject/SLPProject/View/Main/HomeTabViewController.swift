//
//  HomeTabViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/15.
//

import UIKit
import CoreLocation
import MapKit

import SnapKit

final class HomeTabViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    private let mapView = MKMapView()
    private let annotation = MKPointAnnotation()

    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
    }
    
    private func setComponents() {
        setComponentsValue()
        view.addSubview(mapView)
    }
    
    private func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setComponentsValue() {
        view.backgroundColor = SLPAssets.CustomColor.white.color
    }
}
