//
//  MainView.swift
//  LoanPredict
//
//  Created by Matej Kuprešak on 19.01.2024..
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var userID: String
    @State var user = User(id: UUID(), name: "", email: "")
    
    @State var isLoading = true
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Fetching data...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                TabView {
                    HomeView(viewModel: viewModel, user: user)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    
                    RecentsView()
                        .tabItem {
                            Label("Recents", systemImage: "clock")
                        }
                }
            }
        }
        .onAppear {
            Task {
                do {
                    user = await viewModel.getUserInfo(_uid: userID)
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    MainView(viewModel: HomeViewModel(), userID: "")
}
