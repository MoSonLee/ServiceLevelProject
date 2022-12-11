//
//  MyInfoViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/15.
//

import Foundation

import RxCocoa
import RxSwift

final class MyInfoViewModel {
    
    struct Input {
        let cellTapped: Signal<IndexPath>
    }
    
    struct Output {
        let showMySecondInfoVC: Signal<IndexPath>
    }
    
    var userInfo = UserLoginInfo(id: "", v: 0, uid: "", phoneNumber: "", email: "", fcMtoken: "", nick: "", birth: "", gender: 0, study: "", comment: [""], reputation: [0], sesac: 0, sesacCollection: [0], background: 0, backgroundCollection: [0], purchaseToken: [""], transactionID: [""], reviewedBefore: [""], reportedNum: 0, reportedUser: [""], dodgepenalty: 0, dodgeNum: 0, ageMin: 0, ageMax: 0, searchable: 0, createdAt: "")
    
    lazy var sections = BehaviorRelay(value: [
        MyInfoTableSectionModel(header: "", items: [
            MyInfoTableModel(buttonImageString: SLPAssets.RawString.profileImageString.text, title: userInfo.nick)
        ]),
        MyInfoTableSectionModel(header: "", items: [
            MyInfoTableModel(buttonImageString: SLPAssets.RawString.noticeImageString.text,
                    title: SLPAssets.RawString.notice.text),
            MyInfoTableModel(buttonImageString: SLPAssets.RawString.faqImageString.text,
                    title: SLPAssets.RawString.noticeImageString.text),
            MyInfoTableModel(buttonImageString: SLPAssets.RawString.qnaImageString.text,
                    title: SLPAssets.RawString.faq.text),
            MyInfoTableModel(buttonImageString: SLPAssets.RawString.alarmImageString.text,
                    title: SLPAssets.RawString.qna.text),
            MyInfoTableModel(buttonImageString: SLPAssets.RawString.permitImageString.text,
                    title: SLPAssets.RawString.permit.text)
        ])
    ])
    
    private let showMySecondInfoVCRelay = PublishRelay<IndexPath>()
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.cellTapped
            .emit { [weak self] indexPath in
                indexPath == [0,0] ?  self?.showMySecondInfoVCRelay.accept(indexPath) : nil
            }
            .disposed(by: disposeBag)
        return Output(showMySecondInfoVC: showMySecondInfoVCRelay.asSignal())
    }
}
