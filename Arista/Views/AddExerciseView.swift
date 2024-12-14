//
//  AddExerciseView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct AddExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddExerciseViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("Catégorie", text: $viewModel.category)
                    TextField("Heure de démarrage", text: $viewModel.startTimeSTring)
                    TextField("Durée (en minutes)", text: $viewModel.durationString)
                    TextField("Intensité (0 à 10)", text: $viewModel.intensityString)
                }.formStyle(.grouped)
                Spacer()
                Button("Ajouter l'exercice") {
                    if viewModel.addExercise() {
                        presentationMode.wrappedValue.dismiss()
                    }
                }.buttonStyle(.borderedProminent)
                    
            }
            .navigationTitle("Nouvel Exercice ...")
            .overlay(content: {
                if !viewModel.message.isEmpty {
                    ToastView(message: viewModel.message)
                }
            })
        }
    }
}

#Preview {
    AddExerciseView(viewModel: AddExerciseViewModel(context: PersistenceController.preview.container.viewContext))
}
