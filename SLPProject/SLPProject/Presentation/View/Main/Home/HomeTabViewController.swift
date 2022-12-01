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

enum HomeTabMode: Codable {
    case search
    case matching
    case message
    
    var image: UIImage {
        switch self {
        case .search: return SLPAssets.CustomImage.searchButton.image
        case .matching: return SLPAssets.CustomImage.matchingButton.image
        case .message: return SLPAssets.CustomImage.messageButton.image
        }
    }
}

final class HomeTabViewController: UIViewController {
    
    var homeTabMode: HomeTabMode = .search
    
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
    
    private var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    private var searchCollectionModel: [SearchCollecionModel] = []
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        homeTabMode = UserDefaults.homeTabMode
        button.setImage(homeTabMode.image, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
        bind()
        viewDidLoadEvent.accept(())
    }
    
    private func setMapViewDelegate() {
        mapView.delegate = self
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
    }
    
    private func setLocatinManagerAuth() {
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
        setMapViewDelegate()
        setLocatinManagerAuth()
    }
    
    private func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
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
    
    private func addCustomPin(sesac_image: Int, coordinate: CLLocationCoordinate2D) {
        let pin = CustomAnnotation(sesac_image: sesac_image, coordinate: coordinate)
        mapView.addAnnotation(pin)
    }
    
    private func removeCustomPin() {
        let annotations = mapView.annotations.filter({ !($0 is MKUserLocation) })
        mapView.removeAnnotations(annotations)
    }
    
    private func checkButtonTypeAndPushVC() {
        switch homeTabMode {
        case .search:
            let vc = SearchStudyViewController()
            vc.viewModel.location = location
            vc.viewModel.dbData = searchCollectionModel
            navigationController?.pushViewController(vc, animated: true)
        case .matching:
            let vc = NearUserViewController()
            vc.viewModel.userLocation = UserLocationModel(lat: location.latitude, long: location.longitude)
            navigationController?.pushViewController(vc, animated: true)
        case .message:
            let vc = ChatViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func bind() {
        output.homeTabMode
            .emit { [weak self] mode in
                self?.homeTabMode = mode
                self?.button.setImage(mode.image, for: .normal)
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
        
        output.getQueueDB
            .emit(onNext: { [weak self] queueDBTitle in
                self?.searchCollectionModel.removeAll()
                let uniquedDBTitle = queueDBTitle.uniqued()
                uniquedDBTitle.forEach {
                    self?.searchCollectionModel.append(SearchCollecionModel(title: $0))
                }
            })
            .disposed(by: disposeBag)
        
        output.getCenter
            .emit(onNext: { [weak self] location in
                self?.location = location
            })
            .disposed(by: disposeBag)
        
        output.moveToSearchView
            .emit(onNext: {[weak self] _ in
                self?.checkButtonTypeAndPushVC()
            })
            .disposed(by: disposeBag)
        
        output.setCustomPin
            .emit(onNext: {[weak self] mapInfo in
                self?.addCustomPin(sesac_image: mapInfo.2, coordinate: CLLocationCoordinate2D(latitude: mapInfo.0, longitude: mapInfo.1))
            })
            .disposed(by: disposeBag)
        
        output.removeCustomPin
            .emit(onNext: {[weak self] _ in
                self?.removeCustomPin()
            })
            .disposed(by: disposeBag)
    }
}

extension HomeTabViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomAnnotation else {
            return nil
        }
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: CustomAnnotationView.identifier)
            annotationView?.canShowCallout = false
            annotationView?.contentMode = .scaleAspectFit
        } else {
            annotationView?.annotation = annotation
        }
        let sesacImage: UIImage!
        let size = CGSize(width: 85, height: 85)
        UIGraphicsBeginImageContext(size)
        switch annotation.sesac_image {
        case 0:
            sesacImage = SLPAssets.CustomImage.sesac_face_1.image
            
        case 1:
            sesacImage = SLPAssets.CustomImage.sesac_face_2.image
            
        case 2:
            sesacImage = SLPAssets.CustomImage.sesac_face_3.image
            
        case 3:
            sesacImage = SLPAssets.CustomImage.sesac_face_4.image
            
        case 4:
            sesacImage = SLPAssets.CustomImage.sesac_face_5.image
            
        default:
            sesacImage = SLPAssets.CustomImage.sesac_face_1.image
        }
        
        sesacImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView?.image = resizedImage
        return annotationView
    }
}
