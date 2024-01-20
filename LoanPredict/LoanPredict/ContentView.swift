//
//  ContentView.swift
//  LoanPredict
//
//  Created by Matej Kuprešak on 18.01.2024..
//

import SwiftUI

struct ContentView: View {
    @StateObject var homeViewModel = HomeViewModel()
    @StateObject var authViewModel = AuthentificationViewModel()
    
    @State var isLoggedIn = false
    
    var body: some View {
        if isLoggedIn {
            MainView(viewModel: homeViewModel, userID: authViewModel.authenticatedUUID)
        } else {
            LoginView(authViewModel: authViewModel, isLoggedIn: $isLoggedIn)
        }
    }
}
#Preview {
    ContentView()
}
