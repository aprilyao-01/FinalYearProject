//
//  ResetPasswordVM.swift
//  Guardian
//
//  Created by Siyu Yao on 12/02/2023.
//

import Foundation
import Combine

enum ResetState: Equatable{
    case successful
    case failed(error: Error)
    case notAvailable
    
    static func == (lhs: ResetState, rhs: ResetState) -> Bool {
            switch (lhs, rhs) {
            case (.successful, .successful):
                return true
            case (.notAvailable, .notAvailable):
                return true
            case (.failed(let lhsError), .failed(let rhsError)):
                return lhsError.localizedDescription == rhsError.localizedDescription
            default:
                return false
            }
        }
}

protocol ResetPasswordViewModel {
    func sendPasswordReset()
    var email: String { get }
    var hasError: Bool { get }
    var isSent: Bool { get }
    var errorMessage: String { get }
    var state: ResetState { get }
    
    var service: ResetPasswordServiceProtocol { get }
    init(service: ResetPasswordServiceProtocol)
}

final class ResetPasswordVM: ObservableObject, ResetPasswordViewModel {
    
    @Published var email: String = ""
    
    // MARK: error and success sent variables
    @Published var isSent: Bool = false
    @Published var hasError: Bool = false
    @Published var errorMessage: String = ""
    @Published var state: ResetState = .notAvailable
    
    let service: ResetPasswordServiceProtocol
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: ResetPasswordServiceProtocol){
        self.service = service
        setupErrorSubscriptions()
    }
    
    func sendPasswordReset() {
        service.sendPasswordReset(to: email)
            .sink { res in
                switch res {
                case .failure(let err):
                    self.state = .failed(error: err)
                    self.errorMessage = err.localizedDescription
//                    hasError.toggle()
                    print("\n\nFailed: \(err)\n\n")
                default: break
                }
            } receiveValue: {
                self.state = .successful
                print("sent password reset request")
//                isSent.toggle()
            }
            .store(in: &subscriptions)
    }
}

private extension ResetPasswordVM {
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
        
        $state
            .map { state -> Bool in
                switch state {
                case .failed, .notAvailable:
                    return false
                case.successful:
                    return true
                }
                
            }
            .assign(to: &$isSent)
    }
}
