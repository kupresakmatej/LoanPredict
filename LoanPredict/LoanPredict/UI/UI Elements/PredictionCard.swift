//
//  PredictionCard.swift
//  LoanPredict
//
//  Created by Matej Kuprešak on 30.01.2024..
//

import SwiftUI

struct PredictionCard: View {
    var prediction: LoanPrediction
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.2)
                .foregroundStyle(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.black, lineWidth: 1)
                )
            
            
            VStack {
                Text("Prediction")
                    .padding()
                    .font(.title2)
                    .bold()
                
                HStack {
                    Text("Loan possible: ")
                        .padding(.bottom)
                        .bold()
                    
                    Text(prediction.prediction == 1 ? "Yes" : "No")
                        .padding(.bottom)
                        .bold()
                }
                
                HStack {
                    VStack {
                        HStack {
                            Text("Age: ")
                            Text("\(prediction.age)")
                        }
                        HStack {
                            Text("Experience: ")
                            Text("\(prediction.experience)")
                        }
                        HStack {
                            Text("Income: ")
                            Text("\(prediction.income)")
                        }
                        HStack {
                            Text("Zip: ")
                            Text("\(prediction.zip)")
                        }
                    }
                    .padding(.bottom)
                    
                    VStack {
                        HStack {
                            Text("Family: ")
                            Text("\(prediction.family)")
                        }
                        HStack {
                            Text("CC: ")
                            Text(String(format: "%.2f", prediction.CCAvg))
                        }
                        HStack {
                            Text("Education: ")
                            Text("\(prediction.education)")
                        }
                        HStack {
                            Text("Mortgage: ")
                            Text("\(prediction.mortgage)")
                        }
                    }
                    .padding(.bottom)
                    
                    VStack {
                        HStack {
                            Text("SecAcc: ")
                            Text("\(prediction.securitiesAccount)")
                        }
                        HStack {
                            Text("CDAcc: ")
                            Text("\(prediction.cdAccount)")
                        }
                        HStack {
                            Text("Online: ")
                            Text("\(prediction.online)")
                        }
                        HStack {
                            Text("Card: ")
                            Text("\(prediction.creditCard)")
                        }
                    }
                    .padding(.bottom)
                }
                .font(.caption)
            }
        }
    }
}

#Preview {
    PredictionCard(prediction: LoanPrediction(id: UUID(), age: 34, experience: 9, income: 180, zip: 93023, family: 1, CCAvg: 8.9, education: 3, mortgage: 0, securitiesAccount: 0, cdAccount: 0, online: 0, creditCard: 0))
}
