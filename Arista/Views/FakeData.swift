//
//  FakeData.swift
//  Arista
//
//  Created by Alassane Der on 25/12/2024.
//

import Foundation
import CoreData

struct FakeData {
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    
    func apply() throws {
        let sleepRepository = SleepRepository(viewContext: viewContext)
        let exerciseRepository = ExerciceRepository(viewContext: viewContext)
        
        if try exerciseRepository.getExercise().isEmpty {
            let timeIntervalForDay: TimeInterval = 60 * 60 * 24
            let category = ["Football", "Natation", "Running", "Marche", "Cyclisme"]
            
            for i in 1...15 {
                let exercise = Exercise(context: viewContext)
                exercise.category = category [i % category.count]
                exercise.duration = (1...180).randomElement()!
                exercise.intensity = (1...10).randomElement()!
                exercise.startDate = Date(timeIntervalSinceNow: timeIntervalForDay * TimeInterval(-i))
            }
        }
        
        if try sleepRepository.getSleepSessions().isEmpty {
            let timeIntervalForDay: TimeInterval = 60 * 60 * 24

            for day in 1...7 {
                let sleep = Sleep(context: viewContext)
                sleep.duration = (15...500).randomElement()!
                sleep.quality = (0...10).randomElement()!
                sleep.startDate = Date(timeIntervalSinceNow: timeIntervalForDay * TimeInterval(-day))
            }
        }
        
        try? viewContext.save()
    }
}
