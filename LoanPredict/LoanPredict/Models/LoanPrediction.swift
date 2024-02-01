//
//  LoanPrediction.swift
//  LoanPredict
//
//  Created by Matej Kuprešak on 29.01.2024..
//

import Foundation

class LoanPrediction: Codable, Identifiable, Hashable {
    static func == (lhs: LoanPrediction, rhs: LoanPrediction) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: UUID?
    var age: Int
    var experience: Int
    var income: Int
    var zip: Int
    var family: Int
    var CCAvg: Float
    var education: Int
    var mortgage: Int
    var securitiesAccount: Int
    var cdAccount: Int
    var online: Int
    var creditCard: Int
    var prediction: Int?
    var probability: Float?
    
    init(id: UUID, age: Int, experience: Int, income: Int, zip: Int, family: Int, CCAvg: Float, education: Int, mortgage: Int, securitiesAccount: Int, cdAccount: Int, online: Int, creditCard: Int) {
        self.id = id
        self.age = age
        self.experience = experience
        self.income = income
        self.zip = zip
        self.family = family
        self.CCAvg = CCAvg
        self.education = education
        self.mortgage = mortgage
        self.securitiesAccount = securitiesAccount
        self.cdAccount = cdAccount
        self.online = online
        self.creditCard = creditCard
    }
}

struct PredictionResult: Codable {
    let results: Results

    enum CodingKeys: String, CodingKey {
        case results = "Results"
    }
}

struct Results: Codable {
    let webServiceOutput: [WebServiceOutput]

    enum CodingKeys: String, CodingKey {
        case webServiceOutput = "WebServiceOutput0"
    }
}

struct WebServiceOutput: Codable, Identifiable {
    var id: UUID?
    
    let loanPrediction: Int
    let probability: Double

    enum CodingKeys: String, CodingKey {
        case loanPrediction = "LoanPrediction"
        case probability = "Probability"
    }
}


