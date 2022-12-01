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
    
    typealias mapInfo = (Double, Double, Int)
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let gpsButtonTapped: Signal<Void>
        let allButtonTapped: Signal<Void>
        let boyButtonTapped: Signal<Void>
        let girlButtonTapped: Signal<Void>
        let searchButtonTapped: Signal<Void>
        let locationChanged: Observable<CLLocation?>
        let checkLocation: Observable<MKCoordinateRegion>
    }
    
    struct Output {
        let showAlert: Signal<String>
        let homeTabMode: Signal<HomeTabMode>
        let changeAllButton: Signal<Void>
        let changeBoyButton: Signal<Void>
        let changeGirlButton: Signal<Void>
        let showRequestLocationALert: Signal<(String, String, String, String)>
        let setNewRegion: Signal<CLLocationCoordinate2D>
        let moveToSearchView: Signal<Void>
        let setCustomPin: Signal<mapInfo>
        let removeCustomPin: Signal<Void>
        let getQueueDB: Signal<[String]>
        let getCenter: Signal<CLLocationCoordinate2D>
    }
    
    private var queueDB: [String] = []
    private var currentLocation = CLLocationCoordinate2D()
    private let locationManager = CLLocationManager()
    
    private var userLocation = UserLocationModel(lat: 0.0, long: 0.0)
    private var num = -1
    
    private let showAlertRelay = PublishRelay<String>()
    private let homeTabModeRelay = PublishRelay<HomeTabMode>()
    private let changeAllButtonRelay = PublishRelay<Void>()
    private let changeBoyButtonRelay = PublishRelay<Void>()
    private let changeGirlButtonRelay = PublishRelay<Void>()
    private let showRequestLocationALertRelay = PublishRelay<(String, String, String, String)>()
    private let setNewRegionRelay = PublishRelay<CLLocationCoordinate2D>()
    private let moveToSearchViewRelay = PublishRelay<Void>()
    private let setCustomPinRelay = PublishRelay<mapInfo>()
    private let removeCustomPinRelay = PublishRelay<Void>()
    private let getQueueDBRelay = PublishRelay<[String]>()
    private let getCenterRelay = PublishRelay<CLLocationCoordinate2D>()
    
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
                self?.checkUserDeviceLocationServiceAuthorization()
            })
            .disposed(by: disposeBag)
        
        input.allButtonTapped
            .emit(onNext: { [weak self] in
                self?.num = -1
                self?.changeAllButtonRelay.accept(())
                self?.searchSeSAC()
            })
            .disposed(by: disposeBag)
        
        input.boyButtonTapped
            .emit(onNext: { [weak self] in
                self?.num = 1
                self?.changeBoyButtonRelay.accept(())
                self?.searchSeSAC()
            })
            .disposed(by: disposeBag)
        
        input.girlButtonTapped
            .emit(onNext: { [weak self] in
                self?.num = 0
                self?.changeGirlButtonRelay.accept(())
                self?.searchSeSAC()
            })
            .disposed(by: disposeBag)
        
        input.searchButtonTapped
            .emit(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.searchSeSAC()
                let db = self.queueDB
                self.getQueueDBRelay.accept(db)
                self.getCenterRelay.accept(CLLocationCoordinate2D(latitude: self.userLocation.lat, longitude: self.userLocation.long))
                self.moveToSearchViewRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        input.locationChanged
            .subscribe(onNext: { [weak self] location in
                guard let currentLocation = location?.coordinate else { return }
                self?.currentLocation = currentLocation
            })
            .disposed(by: disposeBag)
        
        input.checkLocation
            .skip(2)
            .distinctUntilChanged({
                ($0.center.longitude == $1.center.longitude && $0.center.latitude == $1.center.latitude)
            })
            .subscribe(onNext: { [weak self] location in
                self?.userLocation = UserLocationModel(lat: location.center.latitude, long: location.center.longitude)
                self?.searchSeSAC()
            })
            .disposed(by: disposeBag)
        
        return Output(
            showAlert: showAlertRelay.asSignal(),
            homeTabMode: homeTabModeRelay.asSignal(),
            changeAllButton: changeAllButtonRelay.asSignal(),
            changeBoyButton: changeBoyButtonRelay.asSignal(),
            changeGirlButton: changeGirlButtonRelay.asSignal(),
            showRequestLocationALert: showRequestLocationALertRelay.asSignal(),
            setNewRegion: setNewRegionRelay.asSignal(),
            moveToSearchView: moveToSearchViewRelay.asSignal(),
            setCustomPin: setCustomPinRelay.asSignal(),
            removeCustomPin: removeCustomPinRelay.asSignal(),
            getQueueDB: getQueueDBRelay.asSignal(),
            getCenter: getCenterRelay.asSignal()
        )
    }
}

extension HomeTabViewModel {
    
    private func setAnnotation(data: QueueDB) {
        setCustomPinRelay.accept(mapInfo(data.lat, data.long, data.sesac))
    }
    
    private func filterGender(genderValue: Int, data: SeSACSearchResultModel) {
        let data = data.fromQueueDB.filter { $0.gender == genderValue }
        data.forEach { [weak self] data in  self?.setAnnotation(data: data)}
    }
    
    private func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        authorizationStatus = locationManager.authorizationStatus
        DispatchQueue.global().async { [weak self] in
            if CLLocationManager.locationServicesEnabled() {
                self?.checkUserCurrentLocationAuthorization(authorizationStatus)
                guard let currentLocation = self?.currentLocation else { return }
                self?.setNewRegionRelay.accept(currentLocation)
                self?.searchSeSAC()
            } else {
                self?.showRequestLocationALertRelay.accept(("위치정보 이용", "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", "설정으로 이동", "취소"))
            }
        }
    }
    
    private func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
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
                guard let data = try? JSONDecoder().decode(MyQueueStateModel.self, from: response.data) else { return }
                data.matched == 1 ? self?.homeTabModeRelay.accept(.message)  : self?.homeTabModeRelay.accept(.matching)
                
            case .failure(let error):
                let error = QueueStateError(rawValue: error.response?.statusCode ?? -1) ?? .unknown
                switch error {
                case .notRequestYet:
                    print(QueueStateError.notRequestYet)
                    
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
    
    private func searchSeSAC() {
        APIService().sesacSearch(dictionary: userLocation.toDictionary) { [weak self] result in
            switch result {
            case .success(let response):
                self?.queueDB.removeAll()
                let data = try! JSONDecoder().decode(SeSACSearchResultModel.self, from: response.data)
                let dbData = data.fromQueueDB
                for i in 0..<dbData.count {
                    for j in 0..<dbData[i].studylist.count {
                        self?.queueDB.append(dbData[i].studylist[j])
                    }
                }
                switch self?.num {
                case -1:
                    data.fromQueueDB.forEach {
                        self?.setAnnotation(data: $0)
                    }
                case 0:
                    self?.removeCustomPinRelay.accept(())
                    self?.filterGender(genderValue: 0, data: data)
                    
                case 1:
                    self?.removeCustomPinRelay.accept(())
                    self?.filterGender(genderValue: 1, data: data)
                    
                default:
                    print("Error")
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
