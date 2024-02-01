//
//  RecentsViewModel.swift
//  LoanPredict
//
//  Created by Matej Kuprešak on 30.01.2024..
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabaseInternal

final class RecentsViewModel: ObservableObject {
    @Published var predictions: [LoanPrediction] = []
    
    var dbRef = Database.database().reference()
    
    func fetchPredictions() async {
        predictions.removeAll()
        
        let predictionsRef = dbRef.child("predictions")

        do {
            let dataSnapshot = try await predictionsRef.getData()
            guard dataSnapshot.exists() else {
                print("Predictions data does not exist")
                return
            }

            if let predictionsDict = dataSnapshot.value as? [String: Any] {
                for (predictionID, predictionData) in predictionsDict {
                    if let predictionJSONData = try? JSONSerialization.data(withJSONObject: predictionData),
                       let prediction = try? JSONDecoder().decode(LoanPrediction.self, from: predictionJSONData) {
                        prediction.id = UUID(uuidString: predictionID)
                        DispatchQueue.main.async {
                            self.predictions.append(prediction)
                        }
                    }
                }
            }
        } catch {
            print("Error fetching predictions:", error.localizedDescription)
        }
    }
}
