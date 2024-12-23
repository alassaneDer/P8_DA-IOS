//
//  AddExerciceTestIdeas.swift
//  Arista
//
//  Created by Alassane Der on 19/12/2024.
//

import SwiftUI

struct AddExerciceTestIdeas: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddExerciseViewModel
    
    @State var color: Color = .red
    @State var imageForCategory: [String] = ["Running", "Football", "Cyclisme", "Marche"]
    @State var selectedCategory: String = "Running"
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Catégorie")
                        .font(.headline)
                    
                    ScrollView(.horizontal){
                        HStack {
                            ForEach(viewModel.imageForCategory, id: \.self) { image in
                                VStack{
                                    Image(image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 90, height: 90)
                                        .clipShape(Circle())
                                        .onTapGesture {
                                            withAnimation {
                                                selectedCategory = image
                                            }
                                        }
                                    Text(image)
                                        .foregroundStyle(selectedCategory == image ? Color.blue : Color.gray)
                                    
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    // MARK: startingtime
                    HStack {
                        Text("Heure de démarrage")
                            .font(.headline)
                        DatePicker("Sélectionner une heure", selection: $viewModel.startTime, displayedComponents: [.hourAndMinute])
                            .labelsHidden()
                    }
                    
                    Divider()
                    
                    // MARK: durée de l'exercice
                    VStack(alignment: .leading) {
                        Text("durée de l'exercice")
                            .font(.headline)
                        HStack {
                            VStack {
                                Picker("Hours", selection: $viewModel.selectedHours) {
                                    ForEach(0...viewModel.maxHours, id: \.self) { hour in
                                        Text("\(hour) h")
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(height: 100)
                            }
                            VStack {
                                Picker("minutes", selection: $viewModel.selectedMinutes) {
                                    ForEach(viewModel.minutesRange, id: \.self) { minute in
                                        Text("\(minute) min")
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(height: 100)
                            }
                        }
                    }
                    
                    Divider()
                    
                    //MARK: intensité de l'exercice
                    VStack(alignment: .leading) {
                        HStack {
                            Text("intensité de l'exercice")
                                .font(.headline)
                            Text("\(viewModel.intensity):")
                            Text(intensityDescription(viewModel.intensity))
                                .foregroundStyle(colorForIntensity(viewModel.intensity))
                        }
                        
                        Slider(
                            value:  Binding(
                                get: { Double(viewModel.intensity) },
                                set: { viewModel.intensity = Int($0) }
                            ),
                            in: 0...10,
                            step: 1
                        ) {
                            Text("Intensity (0 à 10")
                        } minimumValueLabel: {
                            Text("0")
                        } maximumValueLabel: {
                            Text("10")
                        } onEditingChanged: { (_) in
                            color = .red
                        }
                    }
                }
                
                Spacer()
                
                Button("Ajouter l'exercice") {
                    if viewModel.addExercise() {
                        presentationMode.wrappedValue.dismiss()
                    }
                }.buttonStyle(.borderedProminent)
                
            }
            .padding()
            .navigationTitle("Nouvel Exercice ...")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(content: {
                if !viewModel.message.isEmpty {
                    ToastView(message: viewModel.message)
                }
            })
        }
    }
}

#Preview {
    AddExerciceTestIdeas(viewModel: AddExerciseViewModel(context: PersistenceController.preview.container.viewContext))
}
