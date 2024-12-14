//
//  UserRepository.swift
//  Arista
//
//  Created by Alassane Der on 09/12/2024.
//

import Foundation
import CoreData

struct UserRepository {
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    func getUser() throws -> User? {
        let request = User.fetchRequest()
        request.fetchLimit = 1
        return try viewContext.fetch(request).first
    }
}
