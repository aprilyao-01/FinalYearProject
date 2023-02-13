//
//  RegisterViewModel.swift
//  Guardian
//
//  Created by Siyu Yao on 18/12/2023.
//

import Foundation
import Combine

enum RegisterState {
    case successful
    case failed(error: Error)
    case notAvailable
}

protocol RegisterViewModel {
    var service: RegisterService { get }
    var state: RegisterState { get }
    var userDetails: RegisterDetails { get }
    var hasError: Bool { get }
    
    func register()
    init(service: RegisterService)
}

final class RegisterVM: ObservableObject, RegisterViewModel {
    
    // MARK: VM Properties
    let service: RegisterService
    @Published var state: RegisterState = .notAvailable
    @Published var userDetails: RegisterDetails = RegisterDetails.new
    @Published var hasError: Bool = false
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: init
    init(service: RegisterService) {
        self.service = service
        setupErrorSubscriptions()
    }
    
    // MARK: create new user in firebase
    func register() {
        service
            .register(with: userDetails)
            .sink { [weak self] res in
                
                switch res {
                case .failure(let error):
                    self?.state = .failed(error: error)
                default: break
                }
                
            } receiveValue: { [weak self] in
                self?.state = .successful
            }
            .store(in: &subscriptions)
    }
}

private extension RegisterVM {
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
