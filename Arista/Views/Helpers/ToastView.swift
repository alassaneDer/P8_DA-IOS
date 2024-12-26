//
//  ToastView.swift
//  Arista
//
//  Created by Alassane Der on 14/12/2024.
//

import SwiftUI

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .foregroundStyle(Color.white)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.red))
            .shadow(radius: 5)
    }
}

#Preview {
    ToastView(message: "message d'erreur")
}
