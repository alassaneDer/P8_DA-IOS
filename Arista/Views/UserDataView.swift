//
//  UserDataView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI
import Charts

struct UserDataView: View {
    @ObservedObject var viewModel: UserDataViewModel
    @ObservedObject var sharedViewModel: SharedViewModel
    
    @State private var showingAddExerciseView: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                // MARK: search Bar
                VStack(spacing: 10) {
                    HStack(spacing: 12) {
                        HStack {
                            Image(systemName: "magnifyingglass.circle.fill")
                                .font(.title)
                            TextField("Search candidates", text: $viewModel.searchText)
                        }
                        .padding(10)
                        .frame(height: 45)
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.2))
                        }
                    }
                }
                .padding()
                
                // MARK: last sleep sessions
                VStack(alignment: .leading) {
                    Text("Sessions de sommeil récentes")
                        .font(.headline)
                    HStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.yellow)
                            .frame(width: 7, height: 60, alignment: .trailing)
                        
                        ScrollView(.horizontal) {
                            HStack {
                                if !sharedViewModel.sleepMessage.isEmpty {
                                    Text(sharedViewModel.sleepMessage)
                                } else {
                                    ForEach (sharedViewModel.recentSleepSessions, id: \.self) { session in
                                        HStack {
                                            QualityIndicator(quality: Int(session.quality))
                                                .padding()
                                            VStack(alignment: .leading) {
                                                Text("Début : \(session.startDate!.formatted())")
                                                Text("Durée : \(session.duration/60) heures")
                                            }
                                        }
                                    }
                                }
                                
                                Button {
                                    // add a new sleep session
                                } label: {
                                    VStack {
                                        Image(systemName: "plus")
                                            .foregroundStyle(Color.white)
                                            .fontWeight(.bold)
                                            .padding()
                                            .background(Color.blue)
                                            .frame(width: 20,height: 20)
                                            .clipShape(Circle())
                                        
                                        Text("Ajouter")
                                            .font(.caption)
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
                .padding()
                
                // MARK: Sleep chart

                
                // MARK: last exercises
                VStack(alignment: .leading) {
                    Text("Exercices physiques récentes")
                        .font(.headline)
                    HStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.yellow)
                            .frame(width: 7, height: 60, alignment: .trailing)
                        
                        ScrollView(.horizontal) {
                            HStack {
                                if !sharedViewModel.exerciseMessage.isEmpty {
                                    Text(sharedViewModel.exerciseMessage)
                                } else {
                                    ForEach (sharedViewModel.recentExercises, id: \.self) { exercise in
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
                                        .padding()
                                    }
                                }
                                
                                Button {
                                    showingAddExerciseView = true
                                } label: {
                                    VStack {
                                        Image(systemName: "plus")
                                            .foregroundStyle(Color.white)
                                            .fontWeight(.bold)
                                            .padding()
                                            .background(Color.blue)
                                            .frame(width: 20,height: 20)
                                            .clipShape(Circle())
                                        
                                        Text("Ajouter")
                                            .font(.caption)
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
                .padding()
                
                //MARK: charts
                VStack {
                    Chart {
                        ForEach(sharedViewModel.recentExercises) { exercise in
                            LineMark(
                                x: .value("Date", exercise.startDate!),
                                y: .value("Intensité", exercise.intensity),
                                series: .value("Metric", "Intensity")
                            )
                            .foregroundStyle(Color.blue)
                            .symbol(Circle())
                            
                            LineMark(
                                x: .value("Date", exercise.startDate!),
                                y: .value("duration", exercise.duration),
                                series: .value("Metric", "Duration")
                            )
                            .foregroundStyle(Color.yellow)
                            .symbol(Circle())
                        }
                    }
                    .chartLegend(position: .bottom)
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    .chartXAxis {
                        AxisMarks(position: .bottom)
                    }
                    .padding()
                    .frame(height: 300)
                    
                    Text("Évolution de la durée et de l'intensité des exercices physiques")
                        .font(.subheadline)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading, content: {
                    HStack {
                        ZStack(alignment: .bottomTrailing) {
                            Image("Profile")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Bonjour")
                                .font(.subheadline)
                            
                            Text("\(viewModel.firstName) \(viewModel.lastName)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        
                    }
                    .padding(.bottom, 10)
                })
                
                ToolbarItem(placement: .topBarTrailing, content: {
                    
                    Button(action: {
                        // parametres
                    }, label: {
                        Image(systemName: "gear")
                            .foregroundStyle(Color.black)
                    })
                    .padding(.bottom, 10)
                })
            }
            .overlay {
                if !viewModel.message.isEmpty {
                    ToastView(message: viewModel.message)
                }
            }
        }
    }
}

#Preview {
    UserDataView(viewModel: UserDataViewModel(context: PersistenceController.preview.container.viewContext), sharedViewModel: SharedViewModel(viewContext: PersistenceController.preview.container.viewContext))
}


/*
 .sheet(isPresented: $showingAddExerciseView) {
     AddExerciseView(viewModel: AddExerciseViewModel(context: viewModel.viewContext)
     )
 }
 */
