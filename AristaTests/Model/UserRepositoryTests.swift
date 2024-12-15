//
//  UserRepositoryTests.swift
//  AristaTests
//
//  Created by Alassane Der on 15/12/2024.
//

import XCTest
import CoreData
@testable import Arista

final class UserRepositoryTests: XCTestCase {

    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest = User.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        for user in objects {
            context.delete(user)
        }
        
        try! context.save()
    }
    
    private func addUser(context: NSManagedObjectContext, firstName: String, lastName: String) {
        
        let newUser = User(context: context)
        newUser.firstName = firstName
        newUser.lastName = lastName
        
        try! context.save()
    }
    
    func test_WhenNoUserInDatabase_GetUser_ReturnNil() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let data = UserRepository(viewContext: persistenceController.container.viewContext)
        
        let user = try! data.getUser()
        
        XCTAssertEqual(user, nil)
    }
    
    func test_WhenAddingUserInDatabase_GetUser_ReturnTheUser() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        addUser(context: persistenceController.container.viewContext, firstName: "Adrien", lastName: "Malo")
        
        let data = UserRepository(viewContext: persistenceController.container.viewContext)
        
        let user = try! data.getUser()
        
        XCTAssertFalse(user == nil)
        XCTAssertEqual(user?.firstName, "Adrien")
        XCTAssertEqual(user?.lastName, "Malo")
    }
    
    func test_WhenAddingMultipleUsersInDatabase_GetUser_ReturnOnlyTheFirstUser() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        addUser(context: persistenceController.container.viewContext, firstName: "Adrien", lastName: "Malo")
        addUser(context: persistenceController.container.viewContext, firstName: "Assane", lastName: "Fall")
        addUser(context: persistenceController.container.viewContext, firstName: "Kandi", lastName: "Niak")
        
        let data = UserRepository(viewContext: persistenceController.container.viewContext)
        
        let user = try! data.getUser()
        
        XCTAssertFalse(user == nil)
        XCTAssertEqual(user?.firstName, "Adrien")
        XCTAssertEqual(user?.lastName, "Malo")

    }
}
