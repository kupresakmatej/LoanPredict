//
//  LoginViewModel.swift
//  LoanPredict
//
//  Created by Matej Kuprešak on 18.01.2024..
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabaseInternal

enum InputError: Error {
    case emailRegister, passwordRegister, login
}

final class AuthentificationViewModel: ObservableObject {
    @Published var nameText = ""
    @Published var emailText = ""
    @Published var passwordText = ""
    
    @Published var isRegisteredSuccessfully = false
    
    var dbRef = Database.database().reference()
}

extension AuthentificationViewModel {
    func registerUser() throws {
        guard emailText.contains("@") else {
            throw InputError.emailRegister
        }
        
        guard passwordText.count >= 8 else {
            throw InputError.passwordRegister
        }
        
        var user = User(id: UUID(), name: nameText, email: emailText)
        
        Auth.auth().createUser(withEmail: emailText, password: passwordText)
        
        isRegisteredSuccessfully = true
        
        self.dbRef.child("users").child(user.id.uuidString).setValue(["name": nameText, "email": emailText])
    }
    
    func loginUser(completion: @escaping (Result<Void, Error>) -> Void) throws {
        Auth.auth().signIn(withEmail: emailText, password: passwordText) { [weak self] authResult, error in
            guard let strongSelf = self else { return }

            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
