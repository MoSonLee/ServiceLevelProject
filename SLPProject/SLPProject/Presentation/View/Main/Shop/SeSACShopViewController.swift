//
//  SeSACShopViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/15.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

final class SeSACShopViewController: UIViewController {
    
    private let profileImage = UIImageView()
    private let saveButton = UIButton()
    private let sesacButton = UIButton()
    private let backgroundButton = UIButton()
    private let lineView = UIView()
    private let selecetedLineView = UIView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let tableView = UITableView()
    private var currentStatus: ShopTabModel = .sesac
    
    private let viewModel = ShopViewModel()
    private lazy var input = ShopViewModel.Input(
        sesacButtonTapped: sesacButton.rx.tap.asSignal(),
        backgroundButtonTapped: backgroundButton.rx.tap.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setComponentsValue()
        setConstraints()
        registerCollectionandTableView()
        bind()
        bindCollectionView()
    }
    
    private func setComponents() {
        [profileImage, saveButton, sesacButton, backgroundButton, lineView, collectionView, tableView].forEach {
            view.addSubview($0)
        }
        lineView.addSubview(selecetedLineView)
    }
    
    private func setConstraints() {
        profileImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
        }
        saveButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-28)
            make.top.equalTo(profileImage.snp.top).offset(13)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
        sesacButton.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom)
            make.left.equalTo(view.safeAreaLayoutGuide)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(44)
        }
        backgroundButton.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom)
            make.right.equalTo(view.safeAreaLayoutGuide)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(44)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(sesacButton.snp.bottom)
            make.right.left.equalToSuperview()
            make.height.equalTo(2)
        }
        selecetedLineView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    private func setcollectionView() {
        tableView.removeFromSuperview()
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    private func registerCollectionandTableView() {
        collectionView.register(ShopCollectionViewCell.self, forCellWithReuseIdentifier: ShopCollectionViewCell.identifider)
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        collectionView.collectionViewLayout = collectionView.setCollectionViewLayout()
        tableView.register(ProfileImageButtonCell.self, forCellReuseIdentifier: ProfileImageButtonCell.identifider)
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setSesacTabValues() {
        currentStatus = .sesac
        sesacButton.isSelected = true
        backgroundButton.isSelected = false
        selectedBarAnimation(moveX: 0)
        setcollectionView()
    }
    
    private func setBackgroundTabValues() {
        currentStatus = .background
        backgroundButton.isSelected = true
        sesacButton.isSelected = false
        selectedBarAnimation(moveX: UIScreen.main.bounds.width / 2)
//        setAcceptTableView()
    }
    
    private func setComponentsValue() {
        view.backgroundColor = SLPAssets.CustomColor.white.color
        navigationItem.title = "새싹샵"
        profileImage.image = SLPAssets.CustomImage.myInfoProfile.image
        saveButton.backgroundColor = SLPAssets.CustomColor.green.color
        saveButton.layer.cornerRadius = 8
        saveButton.setTitle("저장하기", for: .normal)
        sesacButton.setTitle("새싹", for: .normal)
        backgroundButton.setTitle("배경", for: .normal)
        sesacButton.setTitleColor(SLPAssets.CustomColor.gray6.color, for: .normal)
        backgroundButton.setTitleColor(SLPAssets.CustomColor.gray6.color, for: .normal)
        sesacButton.setTitleColor(SLPAssets.CustomColor.green.color, for: .selected)
        backgroundButton.setTitleColor(SLPAssets.CustomColor.green.color, for: .selected)
        selecetedLineView.backgroundColor = SLPAssets.CustomColor.green.color
    }
    
    private func selectedBarAnimation(moveX: CGFloat) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .allowUserInteraction, animations: { [weak self] in
            self?.selecetedLineView.transform = CGAffineTransform(translationX: moveX, y: 0)
        }, completion: nil)
    }
    
    private func bind() {
        output.selectedTab
            .drive(onNext: { [weak self] selectedtab in
                switch selectedtab {
                case .sesac:
                    self?.setSesacTabValues()
                case .background:
                    self?.setBackgroundTabValues()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCollectionView() {
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<SeSACIconCollectionSectionModel>(configureCell: { (datasource, collectionView, indexPath, item) in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopCollectionViewCell.identifider, for: indexPath) as? ShopCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(indexPath: indexPath, item: item)
            return cell
        })
        viewModel.collectionSection
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension SeSACShopViewController: UICollectionViewDelegate { }
