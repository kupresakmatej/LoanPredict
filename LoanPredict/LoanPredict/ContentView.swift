//
//  ContentView.swift
//  LoanPredict
//
//  Created by Matej Kuprešak on 18.01.2024..
//

import SwiftUI

struct ContentView: View {
    @StateObject var homeViewModel = HomeViewModel()
    @State var isLoggedIn = false
    
    var body: some View {
        if isLoggedIn {
            HomeView(viewModel: homeViewModel)
        } else {
            LoginView(isLoggedIn: $isLoggedIn)
        }
    }
}
#Preview {
    ContentView()
}
