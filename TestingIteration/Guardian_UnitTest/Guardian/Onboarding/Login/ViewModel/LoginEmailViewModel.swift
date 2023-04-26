//
//  LoginEmailVM.swift
//  Guardian
//
//  Created by Siyu Yao on 04/02/2023.
//

import Foundation
import Combine

// subclass Equatable for unit testing
enum LoginState: Equatable {
    static func == (lhs: LoginState, rhs: LoginState) -> Bool {
        switch (lhs, rhs) {
        case (.successful, .successful):
            return true
        case let (.failed(lhsError), .failed(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.notAvailable, .notAvailable):
            return true
        default:
            return false
        }
    }

    case successful
    case failed(error: Error)
    case notAvailable
}


protocol LoginEmailViewModel {
    func login()
    var service: LoginService { get }
    var state: LoginState { get }
    var credentials: LoginCredentials { get }
    var hasError: Bool { get }
    init(service: LoginService)
}

final class LoginEmailVM: ObservableObject, LoginEmailViewModel {
    
    let service: LoginService
    
    @Published var state: LoginState = .notAvailable
    @Published var credentials: LoginCredentials = LoginCredentials.new
    @Published var hasError: Bool = false
    
    private var subscriptions = Set<AnyCancellable>()
    
    
    
    init(service: LoginService) {
        self.service = service
        setupErrorSubscriptions()
    }
    
    func login() {
        service.login(with: credentials)
            .sink { res in
                switch res {
                case .failure(let err):
                    self.state = .failed(error: err)
                default: break
                }
            } receiveValue: { [weak self] in
                self?.state = .successful
            }
            .store(in: &subscriptions)
    }
}

private extension LoginEmailVM {
    func setupErrorSubscriptions() {
        $state
            .map { state -> Bool in
                switch state {
                case .successful, .notAvailable:
                    return false
                case.failed:
                    return true
                }
                
            }
            .assign(to: &$hasError)
    }
}
