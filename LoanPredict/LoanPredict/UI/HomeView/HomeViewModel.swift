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
    @Published var isPredictShown = false
    
    var dbRef = Database.database().reference()
    
    var user = User(id: UUID(), name: "", email: "")    
    
    @Published var predictions: [LoanPrediction] = []
}

extension HomeViewModel {
    func calculateApprovalRatesByEducation() -> [String: Double] {
        var approvalRates: [String: Double] = [:]
        let totalPredictions = Double(predictions.count)
        
        for prediction in predictions {
            let educationLevel: String
            switch prediction.education {
            case 1:
                educationLevel = "Middle School"
            case 2:
                educationLevel = "High School"
            case 3:
                educationLevel = "College"
            default:
                educationLevel = "Unknown"
            }
            
            if approvalRates[educationLevel] == nil {
                approvalRates[educationLevel] = 0
            }
            
            if prediction.prediction == 1 {
                approvalRates[educationLevel]! += 1
            }
        }
        
        for (educationLevel, approvalCount) in approvalRates {
            approvalRates[educationLevel] = (approvalCount / totalPredictions) * 100
        }
        
        return approvalRates
    }
    
    func calculateAverageFamilySize() -> Double? {
            let loanRecipients = predictions.filter { $0.prediction == 1 }
            
            guard !loanRecipients.isEmpty else {
                return nil
            }
            
            let sumOfFamilySizes = loanRecipients.reduce(0) { $0 + $1.family }
            
            let averageFamilySize = Double(sumOfFamilySizes) / Double(loanRecipients.count)
            
            return averageFamilySize
        }
    
    func calculateAverageIncomeOfLoanRecipients() -> Double? {
        let loanRecipients = predictions.filter { $0.prediction == 1 }
        
        guard !loanRecipients.isEmpty else {
            return nil
        }
        
        let sumOfIncomes = loanRecipients.reduce(0) { $0 + $1.income }
        
        let averageIncome = Double(sumOfIncomes) / Double(loanRecipients.count)
        
        return averageIncome
    }
    
    func calculateAverageMortgageOfLoanRecipients() -> Double? {
        let loanRecipients = predictions.filter { $0.prediction == 1 }
        
        guard !loanRecipients.isEmpty else {
            return nil
        }
        
        let sumOfMortgages = loanRecipients.reduce(0) { $0 + $1.mortgage }
        
        let averageMortgage = Double(sumOfMortgages) / Double(loanRecipients.count)
        
        return averageMortgage
    }
    
    func calculateAverageAgeOfLoanRecipients() -> Double? {
        let loanRecipients = predictions.filter { $0.prediction == 1 }
        
        guard !loanRecipients.isEmpty else {
            return nil
        }
        
        let sumOfAges = loanRecipients.reduce(0) { $0 + $1.age }
        
        let averageAge = Double(sumOfAges) / Double(loanRecipients.count)
        
        return averageAge
    }
    
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
