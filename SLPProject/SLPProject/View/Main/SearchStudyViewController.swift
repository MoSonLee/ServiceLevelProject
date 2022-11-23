//
//  SearchStudyViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/15.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import Toast

final class SearchStudyViewController: UIViewController {
    
    private var backButton = UIBarButtonItem()
    private let searchBar = UISearchBar()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let searchButton = UIButton()
    
    private let viewModel = SearchStudyViewModel()
    private let disposeBag = DisposeBag()
    
//sendMessageButtonTapped: sendMessageButton.rx.tap
//    .withLatestFrom(
//        phoneNumberTextField.rx.text.orEmpty
//    )
//    .asSignal(onErrorJustReturn: ""),
    
    private lazy var input = SearchStudyViewModel.Input(
        backButtonTapped: backButton.rx.tap.asSignal(),
        searchButtonTapped: searchBar.rx.searchButtonClicked
            .withLatestFrom(
                searchBar.rx.text.orEmpty
            )
            .asSignal(onErrorJustReturn: "")
    )
    private lazy var output = viewModel.transform(input: input)
    
    private lazy var sections = BehaviorRelay(value: [
        SearchCollecionSectionModel(header: "지금 주변에는", items: [
            SearchCollecionModel(title: "aaaaaaaadsaasdaaa"),
            SearchCollecionModel(title: "aaaa"),
            SearchCollecionModel(title: "aaaa")
        ]),
        SearchCollecionSectionModel(header: "내가 하고 싶은", items: [
            SearchCollecionModel(title: "bbbb"),
            SearchCollecionModel(title: "cccc")
            ,SearchCollecionModel(title: "addd")
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
            make.height.greaterThanOrEqualTo(400)
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
                header.configure(indexPath: indexPath, item: dataSource[indexPath.item])
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

extension SearchStudyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header: SearchHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchHeader.identifier, for: indexPath) as! SearchHeader
        return header
    }
}

extension SearchStudyViewController: UISearchBarDelegate {
    private func dissmissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dissmissKeyboard()
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return }
    }
}
