//
//  ResetPasswordService.swift
//  Guardian
//
//  Created by Siyu Yao on 12/02/2023.
//

import Foundation
import Combine
import FirebaseAuth

final class ResetPasswordService {
    func sendPasswordReset(to email: String) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                Auth.auth().sendPasswordReset(withEmail: email) {error in
                    if let err = error {
                        promise(.failure(err))
                    } else {
                        promise(.success(()))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
