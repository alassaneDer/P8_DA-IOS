//
//  SleepRepository.swift
//  Arista
//
//  Created by Alassane Der on 09/12/2024.
//

import Foundation
import CoreData

struct SleepRepository {
    
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    func getSleepSessions() throws -> [Sleep] {
        let request = Sleep.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(SortDescriptor<Sleep>(\.startDate, order: .reverse))]
        
        return try viewContext.fetch(request)
    }
}
