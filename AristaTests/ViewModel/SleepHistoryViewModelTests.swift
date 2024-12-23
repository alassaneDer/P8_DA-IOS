//
//  SleepHistoryViewModelTests.swift
//  AristaTests
//
//  Created by Alassane Der on 15/12/2024.
//

import XCTest
import CoreData
import Combine
@testable import Arista

final class SleepHistoryViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()

    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest = Sleep.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        for sleep in objects {
            context.delete(sleep)
        }
        
        try! context.save()
    }
    
    private func addSleepSession(context: NSManagedObjectContext,startDate: Date, duration: Int, quality: Int, userFirstName: String, userLastName: String) {
        
        let newUser = User(context: context)
        newUser.firstName = userFirstName
        newUser.lastName = userLastName
        try! context.save()
        
        let sleep = Sleep(context: context)
        sleep.startDate = startDate
        sleep.duration = Int64(duration)
        sleep.quality = Int64(quality)
        try! context.save()
    }
    
    func test_WhenNoSleepSessionIsInDatabase_FetchSleepSessions_DoesNotReturnSleepSession() throws {
        
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let viewModel = SleepHistoryViewModel(context: persistenceController.container.viewContext)
        
        let expectation = XCTestExpectation(description: "fetch empty list of sleep sessions")
        
        viewModel.$sleepSessions
            .sink { exercises in
                XCTAssert(exercises.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_WhenAddingSleepSessionInDatabase_FetchSleepSessions_ReturnAListContainingTheSleepSession() {
        
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let date = Date()
        
        addSleepSession(
            context: persistenceController.container.viewContext,
            startDate: date,
            duration: 750,
            quality: 7,
            userFirstName: "Macel",
            userLastName: "faye"
        )
        
        let viewModel = SleepHistoryViewModel(context: persistenceController.container.viewContext)
        
        let expectation = expectation(description: "fetch empty list of sleep session")
        
        viewModel.$sleepSessions
            .sink { sleepSession in
                XCTAssertFalse(sleepSession.isEmpty)
                XCTAssertEqual(sleepSession.first?.startDate, date)
                XCTAssertEqual(sleepSession.first?.duration, 750)
                XCTAssertEqual(sleepSession.first?.quality, 7)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_WhenAddingMultipleExerciseInDatabase_FetchExercise_ReturnAListContainingTheExerciseInTheRightOrder() {
        
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))
        
        addSleepSession(
            context: persistenceController.container.viewContext,
            startDate: date1,
            duration: 750,
            quality: 7,
            userFirstName: "Macel",
            userLastName: "faye"
        )
        addSleepSession(
            context: persistenceController.container.viewContext,
            startDate: date2,
            duration: 600,
            quality: 5,
            userFirstName: "Macel",
            userLastName: "faye"
        )
        addSleepSession(
            context: persistenceController.container.viewContext,
            startDate: date3,
            duration: 800,
            quality: 9,
            userFirstName: "Macel",
            userLastName: "faye"
        )
        
        
        let viewModel = SleepHistoryViewModel(context: persistenceController.container.viewContext)
        
        let expectation = expectation(description: "fetch empty list of sleep session")
        
        viewModel.$sleepSessions
            .sink { sleepSessions in
                XCTAssertFalse(sleepSessions.isEmpty)
                XCTAssertEqual(sleepSessions[0].duration, 750)
                XCTAssertEqual(sleepSessions[1].duration, 600)
                XCTAssertEqual(sleepSessions[2].duration, 800)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
        
    }
    
    
    // MARK: showtemporary toast func tests
    
    func testShowTemporaryToast_mustDisplayMessage_untilTheDelayCompleted() {

        
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let viewModel: SleepHistoryViewModel = SleepHistoryViewModel(context: persistenceController.container.viewContext)
        
        let expectation = self.expectation(description: "Toast message should be cleared after delay")
        
        viewModel.message = "Hello, World!"

        viewModel.showTemporaryToast()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
                   XCTAssertEqual(viewModel.message, "Hello, World!", "The message should be cleared only after the delay")
            expectation.fulfill()
            }
        
        waitForExpectations(timeout: 6, handler: nil)

    }
    
    func testShowTemporaryToast_mustClearMessage_ifTheDelayCompleted() {

        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let viewModel: SleepHistoryViewModel = SleepHistoryViewModel(context: persistenceController.container.viewContext)
        
        let expectation = self.expectation(description: "Toast message should be cleared after delay")
        
        viewModel.message = "Hello, World!"

        viewModel.showTemporaryToast()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.1) {
                   XCTAssertEqual(viewModel.message, "", "The message should be cleared only after the delay")
            expectation.fulfill()
            }
        
        waitForExpectations(timeout: 6, handler: nil)

    }

    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
