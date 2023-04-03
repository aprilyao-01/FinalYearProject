//
//  ResetPasswordServiceMock.swift
//  Guardian
//
//  Created by Siyu Yao on 02/04/2023.
//

import Foundation
import Combine

/// protocol to implement unit test for ResetPasswordVM()
protocol ResetPasswordServiceProtocol {
    func sendPasswordReset(to email: String) -> AnyPublisher<Void, Error>
}

/// mock class to isolate from external dependencies, i.e. network requests(Combine) for testing ResetPasswordVM()
class MockResetPasswordService: ResetPasswordServiceProtocol {
    var sendPasswordResetResult: Result<Void, Error>?

    func sendPasswordReset(to email: String) -> AnyPublisher<Void, Error> {
        if let result = sendPasswordResetResult {
            return Future { promise in
                switch result {
                case .success:
                    promise(.success(()))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
            .eraseToAnyPublisher()
        } else {
            let originalService = ResetPasswordService()
            return originalService.sendPasswordReset(to: email)
        }
    }
}
