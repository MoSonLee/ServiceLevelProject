//
//  ShopViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/03.
//

import Foundation

import RxCocoa
import RxSwift

final class ShopViewModel {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let sesacButtonTapped: Signal<Void>
        let backgroundButtonTapped: Signal<Void>
    }
    
    struct Output {
        let selectedTab: Driver<SeSACTabModel>
        let getTableViewData: Signal<NearSeSACTableModel>
        let getrequested: Signal<NearSeSACTableModel>
        let showToast: Signal<String>
    }
}
