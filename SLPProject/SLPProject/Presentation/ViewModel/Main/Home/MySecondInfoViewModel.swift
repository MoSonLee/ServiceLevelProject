//
//  MySecondInfoViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/11.
//

import Foundation

import RxCocoa

final class MySecondInfoViewModel {
    
    var userInfo = UserLoginInfo(id: "", v: 0, uid: "", phoneNumber: "", email: "", fcMtoken: "", nick: "", birth: "", gender: 0, study: "", comment: [""], reputation: [], sesac: 0, sesacCollection: [], background: 0, backgroundCollection: [], purchaseToken: [""], transactionID: [""], reviewedBefore: [""], reportedNum: 0, reportedUser: [""], dodgepenalty: 0, dodgeNum: 0, ageMin: 0, ageMax: 0, searchable: 0, createdAt: "")
    
    lazy var sections = BehaviorRelay(value: [
        MySecondInfoTableSectionModel(header: "", items: [
            MySecondInfoTableModel(title: userInfo.nick, gender: nil, study: nil, switchType: nil, age: nil, slider: nil)
        ]),
        MySecondInfoTableSectionModel(header: "", items: [
            MySecondInfoTableModel(title: "내 성별", gender: userInfo.gender, study: nil, switchType: nil, age: nil, slider: nil),
            MySecondInfoTableModel(title: "자주 하는 스터디", gender: nil, study: "", switchType: nil, age: nil, slider: nil),
            MySecondInfoTableModel(title: "내 번호 검색 허용", gender: nil, study: nil, switchType: false, age: nil, slider: nil),
            MySecondInfoTableModel(title: "상대방 연령대", gender: nil, study: nil, switchType: nil, age: "\(userInfo.ageMin) ~ \(userInfo.ageMax)", slider: nil),
            MySecondInfoTableModel(title: nil, gender: nil, study: nil, switchType: nil, age: nil, slider: ""),
            MySecondInfoTableModel(title: "회원탈퇴", gender: nil, study: nil, switchType: nil, age: nil, slider: nil)
        ])
    ])
}
