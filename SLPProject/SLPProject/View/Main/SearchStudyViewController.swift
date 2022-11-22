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

final class SearchStudyViewController: UIViewController {
    
    private var backButton = UIBarButtonItem()
    private let searchBar = UISearchBar()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let searchButton = UIButton()
    
    private let viewModel = SearchStudyViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var input = SearchStudyViewModel.Input(
        backButtonTapped: backButton.rx.tap.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
        bind()
    }
    
    private func setComponents() {
        [collectionView, searchButton].forEach {
            view.addSubview($0)
        }
        setComponentsValue()
        setNavigation()
    }
    
    private func setNavigation() {
        backButton = UIBarButtonItem(image: SLPAssets.CustomImage.backButton.image, style: .plain, target: navigationController, action: nil)
        backButton.tintColor = SLPAssets.CustomColor.black.color
        navigationItem.leftBarButtonItem = backButton
        navigationItem.titleView = searchBar
    }
    
    private func setConstraints() {
        searchButton.snp.makeConstraints { make in
            make.bottom.right.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.height.equalTo(48)
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
