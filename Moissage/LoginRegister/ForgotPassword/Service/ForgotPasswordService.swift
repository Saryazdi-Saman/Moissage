//
//  ForgotPasswordService.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//

import Foundation
import Combine
import FirebaseAuth

protocol ForgotPasswordService{
    func sendPasswordReset(to email: String) -> AnyPublisher<Void, Error>
}

final class ForgotPasswordServiceImp: ForgotPasswordService {
    
    func sendPasswordReset(to email: String) -> AnyPublisher<Void, Error> {
        Deferred{
            Future { promise in
                Auth.auth()
                    .sendPasswordReset(withEmail: email){error in
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            promise(.success(()))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
}
