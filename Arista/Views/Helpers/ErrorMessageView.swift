//
//  ErrorMessageView.swift
//  Arista
//
//  Created by Alassane Der on 24/12/2024.
//

import SwiftUI

struct ErrorMessageView: View {
    
    var message: String
    
    var body: some View {
        Text(message)
            .font(.headline)
            .foregroundStyle(Color.white)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.red))
            .shadow(radius: 5)
    }
}

#Preview {
    ErrorMessageView(message: "Erreur message")
}
