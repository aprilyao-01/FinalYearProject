//
//  MockRegister.swift
//  Guardian
//
//  Created by Siyu Yao on 02/04/2023.
//

import Foundation
import Combine

/// protocol for testing RegisterVM()
protocol RegisterService {
    func register(with details: RegisterDetails) -> AnyPublisher<Void, Error>
}

/// mock class for testing RegisterVM()
class MockRegisterService: RegisterService {
    var registerResult: Result<Void, Error> = .failure(MockRegisterError.notAvailableError)
    
    func register(with details: RegisterDetails) -> AnyPublisher<Void, Error> {
        return Result.Publisher(registerResult).eraseToAnyPublisher()
    }
}

/// mock error  for testing RegisterVM()
enum MockRegisterError: Error, LocalizedError {
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
