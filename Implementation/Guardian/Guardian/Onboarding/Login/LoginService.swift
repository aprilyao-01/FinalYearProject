//
//  LoginService.swift
//  Guardian
//
//  Created by Siyu Yao on 04/02/2023.
//

import Foundation
import Combine
import FirebaseAuth

protocol LoginService {
    func login(with credentials: LoginCredentials) -> AnyPublisher<Void, Error>
}

//final class LoginServiceImpl: LoginService {
//    func login(with credentials: LoginCredentials) -> AnyPublisher<Void, Error> {
//        Deferred {
//            Future { promise in
//                Auth.auth().signIn(withEmail: credentials.userName, password: credentials.password)
//            }
//        }
//    }
//}
