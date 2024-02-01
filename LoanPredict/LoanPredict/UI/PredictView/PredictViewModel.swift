//
//  PredictViewModel.swift
//  LoanPredict
//
//  Created by Matej Kuprešak on 29.01.2024..
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabaseInternal

final class PredictViewModel: ObservableObject {
    @ObservedObject var azureNetworking = AzureNetworking()
    
    var educationLevel = ["1 - middle school", "2 - high school", "3 - college"]
    @Published var educationSelection = "1 - middle school"
    
    var secAccount = ["yes", "no"]
    @Published var secAccSelection = "yes"
    
    var cdAccount = ["yes", "no"]
    @Published var cdAccountSelection = "yes"
    
    var onlineBanking = ["yes", "no"]
    @Published var onlineBankingSelection = "yes"
    
    var creditCard = ["yes", "no"]
    @Published var creditCardSelection = "yes"
    
    @Published var ageInput = ""
    @Published var experienceInput = ""
    @Published var incomeInput = ""
    @Published var zipCodeInput = ""
    @Published var famSizeInput = ""
    @Published var ccAvgInput = ""
    @Published var mortgageInput = ""
    
    private func mapEducationToInt(_ education: String) -> Int? {
        switch education {
        case "1 - middle school":
            return 1
        case "2 - high school":
            return 2
        case "3 - college":
            return 3
        default:
            return nil
        }
    }
    
    @Published var predictedResult: WebServiceOutput?
    @Published var predictionResponse: String?
    @Published var isLoanPredicted = false
    
    var dbRef = Database.database().reference()
}

extension PredictViewModel {
    func predictLoan() {
        guard let age = Int(ageInput),
              let experience = Int(experienceInput),
              let income = Int(incomeInput),
              let zip = Int(zipCodeInput),
              let family = Int(famSizeInput),
              let ccAvg = Float(ccAvgInput),
              let mortgage = Int(mortgageInput),
              let securitiesAccount = secAccSelection == "yes" ? 1 : 0,
              let cdAccount = cdAccountSelection == "yes" ? 1 : 0,
              let online = onlineBankingSelection == "yes" ? 1 : 0,
              let creditCard = creditCardSelection == "yes" ? 1 : 0,
            let education = mapEducationToInt(educationSelection)
        else {
            return
        }
        
        let loanPrediction = LoanPrediction(id: UUID(), age: age, experience: experience, income: income, zip: zip, family: family, CCAvg: ccAvg, education: education, mortgage: mortgage, securitiesAccount: securitiesAccount, cdAccount: cdAccount, online: online, creditCard: creditCard)
        
        azureNetworking.invokeRequestResponseService(loanPrediction: loanPrediction) { result in
            switch result {
            case .success(let predictions):
                DispatchQueue.main.async {
                    self.predictedResult = predictions.first
                    self.saveToFirestore(loanPrediction: loanPrediction, result: self.predictedResult ?? WebServiceOutput(loanPrediction: 0, probability: 0))
                    self.isLoanPredicted = true
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func saveToFirestore(loanPrediction: LoanPrediction, result: WebServiceOutput) {
        let user = Auth.auth().currentUser
        
        do {
            let data: [String: Any] = [
                "age": loanPrediction.age,
                "experience": loanPrediction.experience,
                "income": loanPrediction.income,
                "zip": loanPrediction.zip,
                "family": loanPrediction.family,
                "CCAvg": loanPrediction.CCAvg,
                "education": loanPrediction.education,
                "mortgage": loanPrediction.mortgage,
                "securitiesAccount": loanPrediction.securitiesAccount,
                "cdAccount": loanPrediction.cdAccount,
                "online": loanPrediction.online,
                "creditCard": loanPrediction.creditCard,
                "prediction": result.loanPrediction,
                "probability": result.probability,
                "userID" : user?.uid
            ]
            
            dbRef.child("predictions").child(loanPrediction.id?.uuidString ?? "").setValue(data)
        } catch {
            print("Error saving to Firestore: \(error.localizedDescription)")
        }
    }
}
