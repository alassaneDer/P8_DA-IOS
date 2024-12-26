//
//  PlusButtonView.swift
//  Arista
//
//  Created by Alassane Der on 24/12/2024.
//

import SwiftUI

struct PlusButtonView: View {
    
    var action: () -> Void
    var bacgroundColor: Color = Color.blue
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack {
                Image(systemName: "plus")
                    .font(.system(size: 15).weight(.bold))
                    .foregroundStyle(Color.white)
                    .padding(10)
                    .background(Circle().fill(bacgroundColor))
                
                Text("Ajouter")
                    .font(.subheadline)
            }
        }
        .padding()
    }
}

#Preview {
    PlusButtonView(action: {})
}
