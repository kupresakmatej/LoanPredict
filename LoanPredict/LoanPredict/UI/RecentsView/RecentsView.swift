//
//  RecentsView.swift
//  LoanPredict
//
//  Created by Matej Kuprešak on 19.01.2024..
//

import SwiftUI

struct RecentsView: View {
    @ObservedObject var viewModel = RecentsViewModel()
    
    var body: some View {
        VStack {
            ZStack {
                Color.blue
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity)
                    .frame(height: 70)
                
                
                HStack {
                    Text("Recents")
                        .font(.largeTitle)
                        .padding(.leading)
                    
                    Spacer()
                }
            }
            
            VStack {
                if viewModel.predictions.isEmpty {
                    Text("No predictions found")
                } else {
                    ScrollView {
                        VStack(spacing: 5) {
                            ForEach(viewModel.predictions, id: \.self) { prediction in
                                PredictionCard(prediction: prediction)
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchPredictions()
                }
            }
        }
    }
}

struct RecentsView_Previews: PreviewProvider {
    static var previews: some View {
        RecentsView()
    }
}
