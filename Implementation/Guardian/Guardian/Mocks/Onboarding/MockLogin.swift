//
//  MockLogin.swift
//  Guardian
//
//  Created by Siyu Yao on 02/04/2023.
//

import Foundation
import Combine

/// protocol for testing LoginEmailVM()
protocol LoginService {
    func login(with credentials: LoginCredentials) -> AnyPublisher<Void, Error>
}

/// mock class for testing LoginEmailVM()
class MockLoginService: LoginService {
    var loginResult: Result<Void, Error> = .failure(MockLoginError.notAvailableError)

    func login(with credentials: LoginCredentials) -> AnyPublisher<Void, Error> {
        return Result.Publisher(loginResult).eraseToAnyPublisher()
    }
}

/// mock error  for testing LoginEmailVM()
enum MockLoginError: Error, LocalizedError {
    case sampleError
    case notAvailableError

    var errorDescription: String? {
        switch self {
        case .sampleError:
            return "Sample Error Description"
        case .notAvailableError:
            return "Not Available Error Description"
        }
    }
}
