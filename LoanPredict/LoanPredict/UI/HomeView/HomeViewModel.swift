//
//  HomeViewModel.swift
//  LoanPredict
//
//  Created by Matej Kuprešak on 19.01.2024..
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabaseInternal

final class HomeViewModel: ObservableObject {
    var dbRef = Database.database().reference()
    
    var user = User(id: UUID(), name: "", email: "")
}

extension HomeViewModel {
    func getUserInfo(_uid: String) async -> User {
            let userDB = Auth.auth().currentUser

            if let userDB = userDB {
                do {
                    try await userDB.reload()
                    let uid = userDB.uid
                    let name = userDB.displayName

                    user.id = UUID(uuidString: uid) ?? UUID()
                    user.name = name ?? "Unknown"
                } catch {
                    print("Error reloading user:", error.localizedDescription)
                }
            }

            return user
        }
}
