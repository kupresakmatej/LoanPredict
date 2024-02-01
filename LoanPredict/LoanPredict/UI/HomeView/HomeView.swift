//
//  HomeView.swift
//  LoanPredict
//
//  Created by Matej Kuprešak on 19.01.2024..
//

import SwiftUI
import Charts

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var predictViewModel = PredictViewModel()
    
    var user: User
    
    var body: some View {
        TabView {
            ZStack {
                VStack {
                    ZStack {
                        Color.blue
                            .ignoresSafeArea()
                            .frame(maxWidth: .infinity, maxHeight: 75)
                        
                        HStack {
                            Text("Hello, \(user.name)")
                                .font(.title2)
                                .padding()
                            
                            Spacer()
                            
                            Button {
                                viewModel.isPredictShown = true
                            } label: {
                                RoundedButton(width: 75, height: 25, buttonText: "Predict", buttonColor: Color.white)
                                    .padding(25)
                            }
                        }
                    }
                    
                    HStack {
                        Text("Average age of loan recipients:")
                        
                        Text((String(format: "%.2f", viewModel.calculateAverageAgeOfLoanRecipients() ?? 0)))
                            .bold()
                    }
                    .padding()
                    
                    HStack {
                        Text("Average income of loan recipients:")
                        
                        Text((String(format: "%.2f", viewModel.calculateAverageIncomeOfLoanRecipients() ?? 0)))
                            .bold()
                        
                        Text("k $")
                            .bold()
                    }
                    
                    HStack {
                        Text("Average mortgage of loan recipients:")
                        
                        Text((String(format: "%.2f", viewModel.calculateAverageMortgageOfLoanRecipients() ?? 0)))
                            .bold()
                        
                        Text("k $")
                            .bold()
                    }
                    .padding()
                    
                    HStack {
                        Text("Average family size of loan recipients:")
                        
                        Text((String(format: "%.1f", viewModel.calculateAverageFamilySize() ?? 0)))
                            .bold()
                    }
                    
                    Divider()
                        .padding(.vertical)
                    
                    VStack {
                        Text("Approval Rates by Education:")
                            .font(.headline)
                            .padding(.top)
                        
                        ForEach(viewModel.calculateApprovalRatesByEducation().sorted(by: { $0.key < $1.key }), id: \.key) { (educationLevel, approvalRate) in
                            Text("\(educationLevel): \(String(format: "%.2f", approvalRate))%")
                        }
                    }
                    .padding([.bottom, .leading, .trailing])
                    .overlay {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 1)
                    }
                    
                    Divider()
                        .padding(.vertical)
                    
                    VStack {
                        Text("Latest prediction")
                            .font(.title)
                            .bold()
                        
                        PredictionCard(prediction: viewModel.predictions.last ?? LoanPrediction(id: UUID(), age: 0, experience: 0, income: 0, zip: 0, family: 0, CCAvg: 0, education: 0, mortgage: 0, securitiesAccount: 0, cdAccount: 0, online: 0, creditCard: 0))
                    }
                    
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $viewModel.isPredictShown) {
            PredictView(viewModel: predictViewModel)
        }
        .onAppear {
            Task {
                await viewModel.fetchPredictions()
            }
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(), user: User(id: UUID(), name: "Matej Kupresak", email: "matej@gmail.com"))
}
