//
//  LoginView.swift
//  LoanPredict
//
//  Created by Matej Kuprešak on 18.01.2024..
//

import SwiftUI

struct LoginView: View {
    @StateObject var authViewModel = AuthentificationViewModel()
    
    @Binding var isLoggedIn: Bool
    
    @State var showingFailedAuthAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    InputBar(placeholder: "Email...", inputType: InputType.regular, input: $authViewModel.emailText)
                    
                    InputBar(placeholder: "Password...", inputType: InputType.password, input: $authViewModel.passwordText)
                    
                    HStack {
                        Button {
                            do {
                                try authViewModel.loginUser { result in
                                    switch result {
                                        case .success:
                                            isLoggedIn = true
                                            print("User logged in successfully")
                                        case .failure(let error):
                                            showingFailedAuthAlert = true
                                            print("Authentication error: \(error.localizedDescription)")
                                        }
                                    }
                            } catch {
                                print("An error occurred: \(error.localizedDescription)")
                            }
                        } label: {
                            RoundedButton(width: 200, height: 50, buttonText: "Login", buttonColor: Color.blue)
                        }
                        .padding(.top, 10)
                        .alert("Login failed. Check your email and password.", isPresented: $showingFailedAuthAlert) {
                            Button("Try again", role: .cancel) { }
                        }
                    }
                    
                    HStack {
                        Text("Not registered yet?")
                            .padding(.trailing, 0)
                                                
                        NavigationLink(destination: RegisterView(authViewModel: authViewModel)) {
                            Text("Sign up")
                        }
                    }
                    .font(.subheadline)
                }
            }
        }
    }
}
