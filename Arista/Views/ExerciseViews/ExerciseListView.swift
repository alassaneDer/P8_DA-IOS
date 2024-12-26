//
//  ExerciseListView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct ExerciseListView: View {
    @ObservedObject var viewModel: ExerciseListViewModel
    @State private var showingAddExerciseView = false
    
    var body: some View {
        NavigationStack {
            if !viewModel.message.isEmpty {
                VStack {
                    ErrorMessageView(message: viewModel.message)
                    PlusButtonView {
                        showingAddExerciseView = true
                    }
                }
                .padding(.top)
            }
            List(viewModel.exercises) { exercise in
                ExerciseRowView(exercise: exercise)
            }
            .navigationTitle("Exercices")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                showingAddExerciseView = true
            }) {
                Image(systemName: "plus")
            })
        }
        .sheet(isPresented: $showingAddExerciseView, onDismiss: {
            viewModel.reload()
        }) {
            AddExerciseView(viewModel: AddExerciseViewModel(context: viewModel.viewContext))
        }
        
    }
}

#Preview {
    ExerciseListView(viewModel: ExerciseListViewModel(context: PersistenceController.preview.container.viewContext))
}
