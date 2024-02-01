//
//  PredictView.swift
//  LoanPredict
//
//  Created by Matej Kuprešak on 29.01.2024..
//

import SwiftUI

struct PredictView: View {
    @ObservedObject var viewModel: PredictViewModel
    
    @ObservedObject var azureNetworking = AzureNetworking()
    
    var body: some View {
        VStack {
            HStack {
                Text("Enter details")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
            }
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Enter your age")
                        .font(.subheadline)
                    InputBar(placeholder: "Age...", inputType: .regular, input: $viewModel.ageInput)
                    
                    Text("Enter experience")
                        .font(.subheadline)
                    InputBar(placeholder: "Years of experience...", inputType: .regular, input: $viewModel.experienceInput)
                    
                    Text("Enter your income")
                        .font(.subheadline)
                    InputBar(placeholder: "Income in thousands...", inputType: .regular, input: $viewModel.incomeInput)
                    
                    Text("Enter your ZIP code")
                        .font(.subheadline)
                    InputBar(placeholder: "Zip...", inputType: .regular, input: $viewModel.zipCodeInput)
                    
                    Text("Enter family size")
                        .font(.subheadline)
                    InputBar(placeholder: "Family members...", inputType: .regular, input: $viewModel.famSizeInput)
                    
                    Text("Enter your CC average")
                        .font(.subheadline)
                    InputBar(placeholder: "CC average...", inputType: .regular, input: $viewModel.ccAvgInput)
                    
                    Text("Pick your education")
                        .font(.subheadline)
                    Picker("Pick level of education", selection: $viewModel.educationSelection) {
                        ForEach(viewModel.educationLevel, id: \.self) {
                            Text($0)
                        }
                    }
                    .padding(.bottom, 5)
                    .pickerStyle(.palette)
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    
                    Text("Enter your mortgage")
                        .font(.subheadline)
                    InputBar(placeholder: "Mortgage in thousands...", inputType: .regular, input: $viewModel.mortgageInput)
                    
                    Text("Do you have a securities account?")
                        .font(.subheadline)
                    Picker("Pick level of education", selection: $viewModel.secAccSelection) {
                        ForEach(viewModel.secAccount, id: \.self) {
                            Text($0)
                        }
                    }
                    .padding(.bottom, 5)
                    .pickerStyle(.palette)
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    
                    Text("Do you have a CD account?")
                        .font(.subheadline)
                    Picker("Pick level of education", selection: $viewModel.cdAccountSelection) {
                        ForEach(viewModel.cdAccount, id: \.self) {
                            Text($0)
                        }
                    }
                    .padding(.bottom, 5)
                    .pickerStyle(.palette)
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    
                    Text("Do you use online banking?")
                        .font(.subheadline)
                    Picker("Pick level of education", selection: $viewModel.onlineBankingSelection) {
                        ForEach(viewModel.onlineBanking, id: \.self) {
                            Text($0)
                        }
                    }
                    .padding(.bottom, 5)
                    .pickerStyle(.palette)
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    
                    Text("Do you have a credit card?")
                        .font(.subheadline)
                    Picker("Pick level of education", selection: $viewModel.creditCardSelection) {
                        ForEach(viewModel.creditCard, id: \.self) {
                            Text($0)
                        }
                    }
                    .padding(.bottom, 5)
                    .pickerStyle(.palette)
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                }
            }
            
            if(viewModel.ageInput != "" && viewModel.experienceInput != "" && viewModel.incomeInput != "" && viewModel.zipCodeInput != "" && viewModel.famSizeInput != "" && viewModel.ccAvgInput != "" &&  viewModel.mortgageInput != "") {
                Button {
                    viewModel.predictLoan()
                } label: {
                    RoundedButton(width: 200, height: 50, buttonText: "Predict", buttonColor: Color.blue)
                }
                .padding()
            }
            else {
                Button {
                    
                } label: {
                    RoundedButton(width: 200, height: 50, buttonText: "Predict", buttonColor: Color.gray)
                }
                .disabled(true)
            }
            
            Spacer()
        }
        .alert(item: $viewModel.predictedResult) { predictionResult in
            let loanPredictionText = predictionResult.loanPrediction == 1 ? "Yes" : "No"
            let probabilityPercentage = String(format: "%.2f", predictionResult.probability * 100)
            return Alert(
                title: Text("Loan Prediction"),
                message: Text("Loan Prediction: \(loanPredictionText)\nProbability: \(probabilityPercentage)%"),
                dismissButton: .default(Text("Ok"))
            )
        }
    }
}

#Preview {
    PredictView(viewModel: PredictViewModel())
}
