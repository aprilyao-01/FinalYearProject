//
//  RegisterService.swift
//  Guardian
//
//  Created by Siyu Yao on 02/02/2023.
//

import Combine
import Foundation
import Firebase
import FirebaseDatabase

enum RegisterKeys: String {
    case phoneNo
    case fullName
//    case PIN
}

protocol RegisterService {
    func register(with details: RegisterDetails) -> AnyPublisher<Void, Error>
}

final class RegisterServiceImp1: RegisterService {
    
    func register(with details: RegisterDetails) -> AnyPublisher<Void, Error> {
        Deferred {
            
            Future { promise in
                Auth.auth().createUser(withEmail: details.email, password: details.password) { res, error in
                    
                    if let err = error {
                        promise(.failure(err))
                    } else {
                        if let uid = res?.user.uid {
                            
                            let values = [RegisterKeys.fullName.rawValue: details.fullName,
                                         RegisterKeys.phoneNo.rawValue: details.phoneNo
//                                         RegistrationKeys.PIN.rawValue: details.PIN
                            ] as [String : Any]
                            Database.database()
                                .reference()
                                .child("users")
                                .child(uid)
                                .updateChildValues(values) { error, ref in
                                    
                                    if let err = error {
                                        promise(.failure(err))
                                    } else {
                                        promise(.success(()))
                                    }
                                }
                            
                        } else {
                            promise(.failure(NSError(domain: "Invalid User Id", code: 0, userInfo: nil)))
                        }
                    }
                }
            }
            
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
