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
import RxCoreLocation
import RxSwift
import RxMKMapView
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
    private let annotationButton = UIButton()
    
    private let viewDidLoadEvent = PublishRelay<Void>()
    private let viewModel = HomeTabViewModel()
    
    private lazy var input = HomeTabViewModel.Input(
        viewDidLoad: viewDidLoadEvent.asObservable(),
        gpsButtonTapped: gpsButton.rx.tap.asSignal(),
        allButtonTapped: allButton.rx.tap.asSignal(),
        boyButtonTapped: boyButton.rx.tap.asSignal(),
        girlButtonTapped: girlButton.rx.tap.asSignal(),
        searchButtonTapped: button.rx.tap.asSignal(),
        locationChanged: locationManager.rx.location.asObservable(),
        checkLocation: mapView.rx.region.asObservable()
    )
    
    private lazy var output = viewModel.transform(input: input)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
        bind()
        viewDidLoadEvent.accept(())
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    private func setComponents() {
        [mapView, button, genderView, gpsButton, annotationButton].forEach {
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
        annotationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(48)
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
        
        annotationButton.setImage(SLPAssets.CustomImage.mapMarker.image, for: .normal)
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
    
    private func setGirlButtonColor() {
        girlButton.setTitleColor(.white, for: .normal)
        girlButton.backgroundColor = SLPAssets.CustomColor.green.color
        boyButton.setTitleColor(.black, for: .normal)
        boyButton.backgroundColor = SLPAssets.CustomColor.white.color
        allButton.setTitleColor(.black, for: .normal)
        allButton.backgroundColor = SLPAssets.CustomColor.white.color
    }
    
    private func setRegion(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 700, longitudinalMeters: 700)
        mapView.setRegion(region, animated: true)
    }
    
    private func bind() {
        
        output.changeButtonImage
            .emit { [weak self] imgStr in
                self?.button.setImage(UIImage(named: imgStr), for: .normal)
        }
        .disposed(by: disposeBag)
        
        output.changeAllButton
            .emit { [weak self] _ in
                self?.setAllButtonColor()
            }
            .disposed(by: disposeBag)
        
        output.changeBoyButton
            .emit { [weak self] _ in
                self?.setBoyButtonColor()
            }
            .disposed(by: disposeBag)
        
        output.changeGirlButton
            .emit { [weak self] _ in
                self?.setGirlButtonColor()
            }
            .disposed(by: disposeBag)
        
        output.showRequestLocationALert
            .emit { [weak self] text in
                self?.showRequestLocationAlert(text0: text.0, text1: text.1, text2: text.2, text3: text.3)
            }
            .disposed(by: disposeBag)
        
        output.setNewRegion
            .emit(onNext: {[weak self] center in
                self?.setRegion(center: center)
            })
            .disposed(by: disposeBag)
        
        output.moveToSearchView
            .emit(onNext: {[weak self] _ in
                let vc = SeSACSearchViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
