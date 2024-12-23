//
//  DefaultData.swift
//  Arista
//
//  Created by Alassane Der on 11/12/2024.
//

import Foundation
import CoreData

struct DefaultData {
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    func apply() throws {
        let userRepository = UserRepository(viewContext: viewContext)
        let sleepRepository = SleepRepository(viewContext: viewContext)
        
        if (try? userRepository.getUser()) == nil {
            let initialUser = User(context: viewContext)
            initialUser.firstName = "Charlotte"
            initialUser.lastName = "Razoul"
            
            if try sleepRepository.getSleepSessions().isEmpty {
                let timeIntervalForDay: TimeInterval = 60 * 60 * 24

                for day in 1...30 {
                    let sleep = Sleep(context: viewContext)
                    sleep.duration = (15...500).randomElement()!
                    sleep.quality = (0...10).randomElement()!
                    sleep.startDate = Date(timeIntervalSinceNow: timeIntervalForDay * TimeInterval(day))
                    sleep.user = initialUser
                }
               
            }
            
            try? viewContext.save()
        }
    }
}
