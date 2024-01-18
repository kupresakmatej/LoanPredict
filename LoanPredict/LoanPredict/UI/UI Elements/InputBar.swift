//
//  InputBar.swift
//  LoanPredict
//
//  Created by Matej Kuprešak on 19.01.2024..
//

import SwiftUI

enum InputType {
    case regular, password
}

struct InputBar: View {
    var placeholder: String
    @State var inputType: InputType
    @Binding var input: String
    
    var body: some View {
        if(inputType == InputType.regular) {
            TextField(placeholder, text: $input)
                .textFieldStyle(.roundedBorder)
                .frame(width: 300)
        }
        else if(inputType == InputType.password) {
            SecureField(placeholder, text: $input)
                .textFieldStyle(.roundedBorder)
                .frame(width: 300)
        }
    }
}
