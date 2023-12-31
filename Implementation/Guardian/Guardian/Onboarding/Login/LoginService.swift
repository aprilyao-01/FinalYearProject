//
//  LoginService.swift
//  Guardian
//
//  Created by Siyu Yao on 04/02/2023.
//

import Foundation
import Combine
import FirebaseAuth


final class LoginServiceImpl: LoginService {
    func login(with credentials: LoginCredentials) -> AnyPublisher<Void, Error> {
        Deferred {
            Future{ promise in
                Auth.auth().signIn(withEmail: credentials.email,
                                   password: credentials.password) {res, error in
                    if let err = error {
                        promise(.failure(err))
                    } else {
                        promise(.success(()))
                    }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
