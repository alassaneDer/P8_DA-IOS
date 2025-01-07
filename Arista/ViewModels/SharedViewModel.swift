//
//  SharedViewModel.swift
//  Arista
//
//  Created by Alassane Der on 20/12/2024.
//

import Foundation
import CoreData

final class SharedViewModel: ObservableObject {
    @Published var recentExercises: [Exercise] = []
    @Published var recentSleepSessions: [Sleep] = []
    @Published var sleepMessage: String = ""
    @Published var exerciseMessage: String = ""
    
    private var viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchRecentExercices()
        fetRecentSleepSession()
    }
    
    func fetchRecentExercices() {
        do {
            let data = ExerciceRepository(viewContext: viewContext)
            recentExercises = try data.getRecentExercices()
            
            if recentExercises.isEmpty {
                exerciseMessage = "Pas d'exercices physiques"
            }
        } catch {
            self.exerciseMessage = "Désolé nous ne pouvons pas charger les données récentes d'exercice physique!"
        }
    }
    
    func fetRecentSleepSession() {
        do {
            let data = SleepRepository(viewContext: viewContext)
            recentSleepSessions = try data.getRecentSleepSessions()
            
            if recentSleepSessions.isEmpty {
                sleepMessage = "Pas de sessions de sommeil."
            }
        } catch {
            self.sleepMessage = "Désolé nous ne pouvons pas charger les données récentes de sommeil pour le moment!"
        }
    }
}
