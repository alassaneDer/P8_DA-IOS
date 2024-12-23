//
//  UserDataViewModelTests.swift
//  AristaTests
//
//  Created by Alassane Der on 15/12/2024.
//

import XCTest
import CoreData
import Combine
@testable import Arista

#warning("ces tests doivent etre refaites : on fetch le user par defaut et non le user créé")

final class UserDataViewModelTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()
    
    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest = User.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        for object in objects {
            context.delete(object)
        }
        
        try! context.save()
    }
    
    private func addUser(context: NSManagedObjectContext, firstName: String, lastName: String) {
        let newUser = User(context: context)
        newUser.firstName = firstName
        newUser.lastName = lastName
    }
    
    func test_WhenNoUserInDatabase_FetchUserData_ReturnDefautDataUser() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let viewModel = UserDataViewModel(context: persistenceController.container.viewContext)
        
        let expectation = expectation(description: "fetch default user")
        
        viewModel.$lastName
            .sink { lastName in
                XCTAssertEqual(lastName, "Razoul")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_WhenAddingUserInDatabase_FetchUserData_ReturnTheUser() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        addUser(context: persistenceController.container.viewContext, firstName: "Gabriel", lastName: "Faye")
        
        let viewModel = UserDataViewModel(context: persistenceController.container.viewContext)
        
        let expectation = expectation(description: "fetch added user")
        
        viewModel.$firstName
            .sink { firstName in
                XCTAssertFalse(firstName.isEmpty)
                XCTAssertEqual(firstName, "Charlotte")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
        
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
