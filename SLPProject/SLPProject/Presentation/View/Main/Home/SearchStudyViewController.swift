//
//  SearchStudyViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/15.
//

import UIKit

import RxCocoa
import CoreLocation
import RxDataSources
import RxSwift
import SnapKit
import Toast

final class SearchStudyViewController: UIViewController {
    
    private var backButton = UIBarButtonItem()
    private let searchBar = UISearchBar()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let searchButton = UIButton()
    
    let viewModel = SearchStudyViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var input = SearchStudyViewModel.Input(
        backButtonTapped: backButton.rx.tap.asSignal(),
        searchBarButtonTapped: searchBar.rx.searchButtonClicked
            .withLatestFrom(
                searchBar.rx.text.orEmpty
            )
            .asSignal(onErrorJustReturn: ""),
        cellTapped: collectionView.rx.itemSelected.asSignal(),
        searchButtonTapped: searchButton.rx.tap.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    
    var sections = BehaviorRelay(value: [
        SearchCollecionSectionModel(header: "지금 주변에는", items: [
        ]),
        SearchCollecionSectionModel(header: "내가 하고 싶은", items: [
        ])
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
        bind()
        bindCollectionView()
    }
    
    private func setComponents() {
        [collectionView, searchButton].forEach {
            view.addSubview($0)
        }
        registerCollectionView()
        setComponentsValue()
        setNavigation()
    }
    
    private func setNavigation() {
        navigationController?.isNavigationBarHidden = false
        backButton = UIBarButtonItem(image: SLPAssets.CustomImage.backButton.image, style: .plain, target: navigationController, action: nil)
        backButton.tintColor = SLPAssets.CustomColor.black.color
        navigationItem.leftBarButtonItem = backButton
        navigationItem.titleView = searchBar
    }
    
    private func registerCollectionView() {
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifider)
        collectionView.register(SearchHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SearchHeader.identifier)
        collectionView.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.size.width, height: 30)
        }
    }
    
    private func setConstraints() {
        searchButton.snp.makeConstraints { make in
            make.bottom.right.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.height.equalTo(48)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(searchButton.snp.top).offset(-32)
        }
    }
    
    private func setComponentsValue() {
        view.backgroundColor = SLPAssets.CustomColor.white.color
        searchBar.delegate = self
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        searchBar.becomeFirstResponder()
        
        searchButton.setTitle("새싹 찾기", for: .normal)
        searchButton.setTitleColor(SLPAssets.CustomColor.white.color, for: .normal)
        searchButton.layer.cornerRadius = 8
        searchButton.backgroundColor = SLPAssets.CustomColor.green.color
        setRecommended()
    }
    
    private func setRecommended() {
        let array = sections.value
        sections.accept( viewModel.acceptDB(array: array))
    }
    
    private func bind() {
        output.popVC
            .emit(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showToast
            .emit(onNext: { [weak self] text in
                self?.view.makeToast(text)
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        output.addCollectionModel
            .emit(onNext: { [weak self] model in
                guard let secion = self?.sections else { return }
                self?.viewModel.setSectionValue(model: model, section: secion)
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        output.deleteStudy
            .emit(onNext: { [weak self] indexPath in
                guard let section = self?.sections else { return }
                self?.viewModel.deleteSectionValue(indexPath: indexPath, section: section)
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        output.moveToNearUserVC
            .emit(onNext: { [weak self] _ in
                guard let latitude = self?.viewModel.location.latitude else { return }
                guard let longtitude = self?.viewModel.location.longitude else { return }
                let vc = NearUserViewController()
                vc.viewModel.userLocation = UserLocationModel(lat: latitude, long: longtitude)
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCollectionView() {
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<SearchCollecionSectionModel>(configureCell: { (datasource, collectionView, indexPath, item) in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifider, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
            cell.setConstraints()
            cell.configure(indexPath: indexPath, item: item)
            return cell
        }, configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchHeader.identifier, for: indexPath) as? SearchHeader else {
                    return UICollectionReusableView()
                }
                header.configure(indexPath: indexPath, item: dataSource[indexPath.section])
                header.headerLabel.textColor = .black
                return header
                
            default:
                fatalError()
            }
        })
        sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension SearchStudyViewController: UICollectionViewDelegate { }

extension SearchStudyViewController: UISearchBarDelegate {
    private func dissmissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dissmissKeyboard()
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return }
    }
}
