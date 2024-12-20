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
            List(viewModel.exercises) { exercise in
                HStack {
                    Image(systemName: iconForCategory(exercise.category!))
                    VStack(alignment: .leading) {
                        Text(exercise.category!)
                            .font(.headline)
                        Text("Durée: \(exercise.duration) min")
                            .font(.subheadline)
                        Text(exercise.startDate!.formatted())
                            .font(.subheadline)
                        
                    }
                    Spacer()
                    IntensityIndicator(intensity: Int(exercise.intensity))
                }
            }
            .navigationTitle("Exercices")
            .navigationBarItems(trailing: Button(action: {
                showingAddExerciseView = true
            }) {
                Image(systemName: "plus")
            })
        }
        .overlay(content: {
            if !viewModel.message.isEmpty {
                ToastView(message: viewModel.message)
            }
        })
        .sheet(isPresented: $showingAddExerciseView, onDismiss: {
            viewModel.reload()
        }) {
            AddExerciseView(viewModel: AddExerciseViewModel(context: viewModel.viewContext))
        }
        
    }
    
    func iconForCategory(_ category: String) -> String {
        switch category {
        case "Football":
            return "sportscourt"
        case "Natation":
            return "waveform.path.ecg"
        case "Running":
            return "figure.run"
        case "Marche":
            return "figure.walk"
        case "Cyclisme":
            return "bicycle"
        default:
            return "questionmark"
        }
    }
}

struct IntensityIndicator: View {
    var intensity: Int
    
    var body: some View {
        Circle()
            .fill(colorForIntensity(intensity))
            .frame(width: 10, height: 10)
    }
    
    func colorForIntensity(_ intensity: Int) -> Color {
        switch intensity {
        case 0...3:
            return .green
        case 4...6:
            return .yellow
        case 7...10:
            return .red
        default:
            return .gray
        }
    }
}

#Preview {
    ExerciseListView(viewModel: ExerciseListViewModel(context: PersistenceController.preview.container.viewContext))
}
