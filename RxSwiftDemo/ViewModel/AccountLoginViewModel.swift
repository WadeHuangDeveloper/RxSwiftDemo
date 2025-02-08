//
//  AccountLoginViewModel.swift
//  RxSwiftDemo
//
//  Created by Huei-Der Huang on 2025/2/8.
//

import Foundation
import RxCocoa
import RxSwift

class AccountLoginViewModel {
    var username = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    var confirmPassword = BehaviorRelay<String>(value: "")
    
    var isUsernameLessThan4Characters: Observable<Bool> {
        username.map { $0.count < 4 }
    }
    
    var isPasswordLessThan8Characters: Observable<Bool> {
        password.map { $0.count < 8 }
    }
    
    var isPasswordMatched: Observable<Bool> {
        Observable.combineLatest(password, confirmPassword)
            .map { (password, confirmPassword) in
                password.count >= 8 && password == confirmPassword
            }
    }
    
    var messagePublisher: Observable<String?> {
        Observable.combineLatest(isUsernameLessThan4Characters, isPasswordLessThan8Characters, isPasswordMatched)
            .map { (isUsernameLessThan4Characters, isPasswordLessThan8Characters, isPasswordMatched) in
                var message = ""
                if isUsernameLessThan4Characters {
                    message += UIStringModel.UsernameLessThan4Characters
                    message += "\n"
                }
                if isPasswordLessThan8Characters {
                    message += UIStringModel.PasswordLessThan8Characters
                    message += "\n"
                }
                if !isPasswordMatched {
                    message += UIStringModel.PasswordNoMatched
                }
                return message
            }
    }
    
    var isLoginEnable: Observable<Bool> {
        Observable.combineLatest(isUsernameLessThan4Characters, isPasswordLessThan8Characters, isPasswordMatched)
            .map { (isUsernameLessThan4Characters, isPasswordLessThan8Characters, isPasswordMatched) in
                !isUsernameLessThan4Characters && !isPasswordLessThan8Characters && isPasswordMatched
            }
    }
}
