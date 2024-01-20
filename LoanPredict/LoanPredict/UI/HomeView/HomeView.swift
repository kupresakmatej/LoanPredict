//
//  HomeView.swift
//  LoanPredict
//
//  Created by Matej Kuprešak on 19.01.2024..
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var user: User
    
    var body: some View {
        TabView {
            ZStack {
                VStack {
                    ZStack {
                        Color.blue
                            .ignoresSafeArea()
                            .frame(width: .infinity, height: 75)
                        
                        HStack {
                            Text("Hello, \(user.name)")
                                .font(.title2)
                                .padding()
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                RoundedButton(width: 75, height: 25, buttonText: "Predict", buttonColor: Color.white)
                                    .padding(25)
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(), user: User(id: UUID(), name: "Matej Kupresak", email: "matej@gmail.com"))
}
