//
//  HomeTabViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/18.
//

import Foundation
import MapKit
import CoreLocation

import RxCocoa
import RxCoreLocation
import RxSwift

final class HomeTabViewModel {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let gpsButtonTapped: Signal<Void>
        let allButtonTapped: Signal<Void>
        let boyButtonTapped: Signal<Void>
        let girlButtonTapped: Signal<Void>
        let searchButtonTapped: Signal<Void>
        let locationChanged: ControlEvent<CLLocationsEvent>
    }
    
    struct Output {
        let showAlert: Signal<String>
        let changeButtonImage: Signal<String>
        let changeAllButton: Signal<Void>
        let changeBoyButton: Signal<Void>
        let changeGirlButton: Signal<Void>
        let showRequestLocationALert: Signal<(String, String, String, String)>
        let setNewRegion: Signal<CLLocationCoordinate2D>
    }
    
    private var currentLocation = CLLocation()
    private let locationManager = CLLocationManager()
    var userLocation = UserLocationModel(lat: 0.0, long: 0.0)
    var userSearch = UserSearchModel(lat: 0.0, long: 0.0, studylist: [])
    
    private let showAlertRelay = PublishRelay<String>()
    private let changeButtonImageRelay = PublishRelay<String>()
    private let changeAllButtonRelay = PublishRelay<Void>()
    private let changeBoyButtonRelay = PublishRelay<Void>()
    private let changeGirlButtonRelay = PublishRelay<Void>()
    private let showRequestLocationALertRelay = PublishRelay<(String, String, String, String)>()
    private let setNewRegionRelay = PublishRelay<CLLocationCoordinate2D>()
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.checkUserDeviceLocationServiceAuthorization()
                self?.checkMyQueueState()
            })
            .disposed(by: disposeBag)
        
        input.gpsButtonTapped
            .emit(onNext: { [weak self] _ in
                guard let currentLocation = self?.currentLocation.coordinate else { return }
                self?.setNewRegionRelay.accept(currentLocation)
            })
            .disposed(by: disposeBag)
        
        input.allButtonTapped
            .emit(onNext: { [weak self] in
                self?.changeAllButtonRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        input.boyButtonTapped
            .emit(onNext: { [weak self] in
                self?.changeBoyButtonRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        input.girlButtonTapped
            .emit(onNext: { [weak self] in
                self?.changeGirlButtonRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        input.searchButtonTapped
            .emit(onNext: { [weak self] in
                self?.requestSearchSeSAC()
            })
            .disposed(by: disposeBag)
        
        input.locationChanged
            .subscribe(onNext: {[weak self] _, locations in
                guard !locations.isEmpty,
                    let currentLocation = locations.last else { return }
                self?.setNewRegionRelay.accept(currentLocation.coordinate)
                self?.currentLocation = currentLocation
            })
            .disposed(by: disposeBag)
        
        return Output(
            showAlert: showAlertRelay.asSignal(),
            changeButtonImage: changeButtonImageRelay.asSignal(),
            changeAllButton: changeAllButtonRelay.asSignal(),
            changeBoyButton: changeBoyButtonRelay.asSignal(),
            changeGirlButton: changeGirlButtonRelay.asSignal(),
            showRequestLocationALert: showRequestLocationALertRelay.asSignal(),
            setNewRegion: setNewRegionRelay.asSignal()
        )
    }
}

extension HomeTabViewModel {
    func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        authorizationStatus = locationManager.authorizationStatus
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.checkUserCurrentLocationAuthorization(authorizationStatus)
            } else {
                self.showRequestLocationALertRelay.accept(("위치정보 이용", "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", "설정으로 이동", "취소"))
            }
        }
    }
    
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            showRequestLocationALertRelay.accept(("위치정보 이용", "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", "설정으로 이동", "취소"))
            
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default: print("DEFAULT")
        }
    }
    
    private func checkMyQueueState() {
        APIService().checkMyQueueState { [weak self] result in
            switch result {
            case .success(let response):
                print(response)
                self?.changeButtonImageRelay.accept(SLPAssets.RawString.matchingButtonString.text)
                
            case .failure(let error):
                let error = QueueStateError(rawValue: error.response?.statusCode ?? -1) ?? .unknown
                switch error {
                case .notRequestYet:
                    print(QueueStateError.notRequestYet)
                    self?.changeButtonImageRelay.accept(SLPAssets.RawString.searchButtonString.text)
                    
                case .tokenError:
                    print(QueueStateError.tokenError)
                    
                case .unregisteredError:
                    print(QueueStateError.unregisteredError)
                    
                case .serverError:
                    print(QueueStateError.serverError)
                    
                case .clientError:
                    print(QueueStateError.clientError)
                    
                case .unknown:
                    print(QueueStateError.unknown)
                }
            }
        }
    }
    
    private func requestSearchSeSAC() {
        APIService().requestSearchSeSAC(dictionary: userSearch.toDictionary) { [weak self] result in
            switch result {
            case .success(let response):
                let data = try! JSONDecoder().decode(UserSearchModel.self, from: response.data)
                self?.changeButtonImageRelay.accept(SLPAssets.RawString.matchingButtonString.text)
                print(data)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func searchSeSAC() {
        APIService().requestSearchSeSAC(dictionary: userLocation.toDictionary) { result in
            switch result {
            case .success(let response):
                let data = try! JSONDecoder().decode(UserLocationModel.self, from: response.data)
                print(data)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func stopSearchSeSAC() {
        APIService().stopSearchSeSAC { result in
            switch result {
            case .success(let response):
                print(response)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
