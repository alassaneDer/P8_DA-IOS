//
//  SleepRepositorytests.swift
//  AristaTests
//
//  Created by Alassane Der on 14/12/2024.
//

import XCTest
import CoreData
@testable import Arista

final class SleepRepositorytests: XCTestCase {

    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest = Sleep.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        for sleep in objects {
            context.delete(sleep)
        }
        
        try! context.save()
    }
    
    private func addSleepSessions(context: NSManagedObjectContext, startDate: Date, duration: Int, quality: Int, userFirstName: String, userLastName: String) {
        let newUser = User(context: context)
        newUser.firstName = userFirstName
        newUser.lastName = userLastName
        
        try! context.save()
        
        let newSleepSession = Sleep(context: context)
        newSleepSession.quality = Int64(quality)
        newSleepSession.duration = Int64(duration)
        newSleepSession.startDate = startDate
        
        try! context.save()
    }
    
    func test_WhenNoSleepSessionIsInDatabase_getSleepSessions_DoesNotReturnUser() {
        let persistenceContainer = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceContainer.container.viewContext)
        
        let data = SleepRepository(viewContext: persistenceContainer.container.viewContext)
        
        let sleeps = try! data.getSleepSessions()
        
        XCTAssertTrue(sleeps.isEmpty)
    }
    
    func test_WhenAddingOneSleepSessionInDatabase_getSleepSessions_ReturnListContainingTheSleepSession() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let date = Date()
        
        addSleepSessions(context: persistenceController.container.viewContext,
                         startDate: date,
                         duration: 800,
                         quality: 8,
                         userFirstName: "Marcel",
                         userLastName: "Diouf")
        
        let data = SleepRepository(viewContext: persistenceController.container.viewContext)
        
        let sleep = try! data.getSleepSessions()
        
        XCTAssertFalse(sleep.isEmpty)
        XCTAssertEqual(sleep.first?.duration, 800)
        XCTAssertEqual(sleep.first?.quality, 8)
        XCTAssertEqual(sleep.first?.startDate, date)
        
    }
    
    
    func test_WhenAddingMultipleSleepSessionsInDatabase_GetSleepSessions_ReturnAListContainingTheSleepSessionsInTheRightOrder() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))
        
        addSleepSessions(
            context: persistenceController.container.viewContext,
            startDate: date1,
            duration: 780,
            quality: 9,
            userFirstName: "Gabriel",
            userLastName: "Macron"
        )
        addSleepSessions(
            context: persistenceController.container.viewContext,
            startDate: date2,
            duration: 680,
            quality: 3,
            userFirstName: "Fatoumata",
            userLastName: "Diop"
        )
        addSleepSessions(
            context: persistenceController.container.viewContext,
            startDate: date3,
            duration: 580,
            quality: 10,
            userFirstName: "Gaspar",
            userLastName: "Melon"
        )
        
        let data = SleepRepository(viewContext: persistenceController.container.viewContext)
        
        let sleeps = try! data.getSleepSessions()
        
        XCTAssertFalse(sleeps.isEmpty)
        XCTAssertEqual(sleeps[0].quality, 9)
        XCTAssertEqual(sleeps[1].quality, 3)
        XCTAssertEqual(sleeps[2].quality, 10)
    }
}
