//
//  AddCategoryView.swift
//  Arista
//
//  Created by Alassane Der on 24/12/2024.
//

import SwiftUI

struct AddCategoryView: View {
    
    @ObservedObject var viewModel: AddExerciseViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Entrez une catégorie...", text: $viewModel.category)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .padding()
            }
        }
    }
}

#Preview {
    AddCategoryView(viewModel: AddExerciseViewModel(context: PersistenceController.preview.container.viewContext))
}
