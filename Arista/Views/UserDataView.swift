//
//  UserDataView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI
import Charts

struct UserDataView: View {
    @ObservedObject var userDataViewModel: UserDataViewModel
    @ObservedObject var sharedViewModel: SharedViewModel
        
    var body: some View {
        NavigationStack {
            ScrollView {
                
                // MARK: search Bar
                VStack(spacing: 10) {
                    HStack(spacing: 12) {
                        HStack {
                            Image(systemName: "magnifyingglass.circle.fill")
                                .font(.title)
                            TextField("Search candidates", text: $userDataViewModel.searchText)
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
                                        SleepHistoryRowView(session: session)
                                    }
                                }
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
                                        ExerciseRowView(exercise: exercise)
                                            .padding()
                                    }
                                }
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
            .onAppear(perform: {
                sharedViewModel.fetchRecentExercices()
                sharedViewModel.fetRecentSleepSession()
            })
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
                            
                            Text("\(userDataViewModel.firstName) \(userDataViewModel.lastName)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        
                    }
                    .padding(.bottom, 10)
                })
            }
        }
    }
}

#Preview {
    UserDataView(userDataViewModel: UserDataViewModel(context: PersistenceController.preview.container.viewContext), sharedViewModel: SharedViewModel(viewContext: PersistenceController.preview.container.viewContext))
}
