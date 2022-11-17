//
//  HomeTabViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/15.
//

import UIKit
import CoreLocation
import MapKit

import RxCocoa
import RxSwift
import SnapKit
import Toast

final class HomeTabViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    private let annotation = MKPointAnnotation()
    private let mapView = MKMapView()
    private let button = UIButton()
    private let genderView = UIView()
    private let allButton = UIButton()
    private let boyButton = UIButton()
    private let girlButton = UIButton()
    private let gpsButton = UIButton()
    
    private let viewWillAppearEvent = PublishRelay<Void>()
    private let viewModel = HomeTabViewModel()
    private lazy var input = HomeTabViewModel.Input(
        viewWillAppear: viewWillAppearEvent.asObservable(),
        gpsButtonTapped: gpsButton.rx.tap.asSignal(),
        allButtonTapped: allButton.rx.tap.asSignal(),
        boyButtonTapped: boyButton.rx.tap.asSignal(),
        girlButtonTapped: girlButton.rx.tap.asSignal()
    )
    
    private lazy var output = viewModel.transform(input: input)
    private let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearEvent.accept(())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
        bind()
    }
    
    private func setComponents() {
        [mapView, button, genderView, gpsButton].forEach {
            view.addSubview($0)
        }
        [allButton, boyButton, girlButton].forEach {
            genderView.addSubview($0)
        }
        setComponentsValue()
    }
    
    private func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        button.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.right.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        genderView.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(52)
            make.height.equalTo(144)
            make.width.equalTo(48)
        }
        allButton.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.width.height.equalTo(48)
            make.bottom.equalTo(boyButton.snp.top)
        }
        boyButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.width.height.equalTo(48)
            make.bottom.equalTo(girlButton.snp.top)
        }
        girlButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.width.height.equalTo(48)
        }
        
        gpsButton.snp.makeConstraints { make in
            make.top.equalTo(genderView.snp.bottom).offset(16)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.width.height.equalTo(48)
        }
    }
    
    private func setComponentsValue() {
        view.backgroundColor = SLPAssets.CustomColor.white.color
        genderView.backgroundColor = SLPAssets.CustomColor.white.color
        allButton.backgroundColor = SLPAssets.CustomColor.green.color
        button.setImage(SLPAssets.CustomImage.searchButton.image, for: .normal)
        gpsButton.setImage(SLPAssets.CustomImage.gpsButton.image, for: .normal)
        [genderView, allButton, boyButton, girlButton, gpsButton].forEach {
            $0.layer.cornerRadius = 8
        }
        [boyButton, girlButton].forEach {
            $0.setTitleColor(.black, for: .normal)
        }
        allButton.setTitleColor(.white, for: .normal)
        allButton.setTitle("전체", for: .normal)
        boyButton.setTitle("남자", for: .normal)
        girlButton.setTitle("여자", for: .normal)
    }
    
    private func setAllButtonColor() {
        allButton.setTitleColor(.white, for: .normal)
        allButton.backgroundColor = SLPAssets.CustomColor.green.color
        boyButton.setTitleColor(.black, for: .normal)
        boyButton.backgroundColor = SLPAssets.CustomColor.white.color
        girlButton.setTitleColor(.black, for: .normal)
        girlButton.backgroundColor = SLPAssets.CustomColor.white.color
    }
    
    private func setBoyButtonColor() {
        boyButton.setTitleColor(.white, for: .normal)
        boyButton.backgroundColor = SLPAssets.CustomColor.green.color
        girlButton.setTitleColor(.black, for: .normal)
        girlButton.backgroundColor = SLPAssets.CustomColor.white.color
        allButton.setTitleColor(.black, for: .normal)
        allButton.backgroundColor = SLPAssets.CustomColor.white.color
    }
    
    private func girlButtonColor() {
        girlButton.setTitleColor(.white, for: .normal)
        girlButton.backgroundColor = SLPAssets.CustomColor.green.color
        boyButton.setTitleColor(.black, for: .normal)
        boyButton.backgroundColor = SLPAssets.CustomColor.white.color
        allButton.setTitleColor(.black, for: .normal)
        allButton.backgroundColor = SLPAssets.CustomColor.white.color
    }
    
    private func bind() {
        
    }
}
