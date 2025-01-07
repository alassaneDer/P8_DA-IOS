//
//  SharedViewModelTests.swift
//  AristaTests
//
//  Created by Alassane Der on 27/12/2024.
//

import XCTest
import CoreData
import Combine
@testable import Arista

final class SharedViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    // MARK: fetch recent exercises

    func emptySleepEntities(context: NSManagedObjectContext) {
        let fetchRequest = Sleep.fetchRequest()
        let sleeps = try! context.fetch(fetchRequest)
        
        for sleep in sleeps {
            context.delete(sleep)
        }
        
        try! context.save()
    }
    
    func addSleepSession(context: NSManagedObjectContext, startDate: Date, duration: Int, quality: Int, userFirstname: String, userLastname: String) {
        
        let newUser = User(context: context)
        newUser.firstName = userFirstname
        newUser.lastName = userLastname
        try! context.save()
        
        let sleep = Sleep(context: context)
        sleep.startDate = startDate
        sleep.duration = Int64(duration)
        sleep.quality = Int64( quality)
        try! context.save()
    }
    
    func test_WhenNoSleepSessionIsInDatabase_FetchRecentSleepSessions_DoesNotReturnSleepSession() {
        let persistenceController = PersistenceController(inMemory: true)
        emptySleepEntities(context: persistenceController.container.viewContext)
        
        let viewModel = SharedViewModel(viewContext: persistenceController.container.viewContext)
        
        let expectation = XCTestExpectation(description: "Fetch empty list of sleep sessions")
        
        viewModel.$recentSleepSessions
            .sink { sleeps in
                XCTAssert(sleeps.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    
    func test_WhenAddingOneSleepSessionInDatabase_FetchRecentSleepSessions_ReturnAListContainingTheSleepSession() {
        
        let persistenceController = PersistenceController(inMemory: true)
        emptySleepEntities(context: persistenceController.container.viewContext)

        let date = Date()
        
        addSleepSession(
            context: persistenceController.container.viewContext,
            startDate: date,
            duration: 750,
            quality: 7,
            userFirstname: "Marcel",
            userLastname: "faye"
        )
        
        let viewModel = SharedViewModel(viewContext: persistenceController.container.viewContext)
        
        let expectation = expectation(description: "fetch list with one sleep session")
        
        viewModel.$recentSleepSessions
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
    
    func test_WhenAddingMultipleSleepSessionsInDatabase_FetchRecentSleepSessions_ReturnAListContainingTheSleepSessionsInTheRightOrder() {
        
        let persistenceController = PersistenceController(inMemory: true)
        emptySleepEntities(context: persistenceController.container.viewContext)

        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))
        
        addSleepSession(
            context: persistenceController.container.viewContext,
            startDate: date1,
            duration: 750,
            quality: 7,
            userFirstname: "Macel",
            userLastname: "faye"
        )
        addSleepSession(
            context: persistenceController.container.viewContext,
            startDate: date2,
            duration: 600,
            quality: 5,
            userFirstname: "Macel",
            userLastname: "faye"
        )
        addSleepSession(
            context: persistenceController.container.viewContext,
            startDate: date3,
            duration: 800,
            quality: 9,
            userFirstname: "Macel",
            userLastname: "faye"
        )
        
        
        let viewModel = SharedViewModel(viewContext: persistenceController.container.viewContext)
        
        let expectation = expectation(description: "fetch list of sleep sessions")
        
        viewModel.$recentSleepSessions
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
    
    // MARK: fetch recent exercises
    func emptyExerciseEntities(context: NSManagedObjectContext) {
        let fetchRequest = Exercise.fetchRequest()
        let exercises = try! context.fetch(fetchRequest)
        
        for exercise in exercises {
            context.delete(exercise)
        }
        
        try! context.save()
    }
    
    func addExercise(context: NSManagedObjectContext, category: String, duration: Int, intensity: Int, startDate: Date, userFirstName: String, userLastName: String) {
        let newUser = User(context: context)
        newUser.firstName = userFirstName
        newUser.lastName = userLastName
        try! context.save()
        
        let exercise = Exercise(context: context)
        exercise.category = category
        exercise.duration = Int64(duration)
        exercise.intensity = Int64(intensity)
        exercise.startDate = startDate
        try! context.save()
    }
    
    func test_WhenNoExerciseIsInDatabase_FetchRecentExercise_DoesNotReturnExercise() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyExerciseEntities(context: persistenceController.container.viewContext)
        
        let viewModel = SharedViewModel(viewContext: persistenceController.container.viewContext)
        
        let expectation = XCTestExpectation(description: "Fetch empty list of exercise")
        
        viewModel.$recentExercises
            .sink { exercise in
                XCTAssert(exercise.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    
    func test_WhenAddingOneExerciseInDatabase_FetchRecentExercise_ReturnAListContainingTheExercise() {
        
        let persistenceController = PersistenceController(inMemory: true)
        emptyExerciseEntities(context: persistenceController.container.viewContext)

        let date = Date()
        
        addExercise(context: persistenceController.container.viewContext, category: "Running", duration: 45, intensity: 8, startDate: date, userFirstName: "Marcel", userLastName: "Faye")
        
        let viewModel = SharedViewModel(viewContext: persistenceController.container.viewContext)
        
        let expectation = expectation(description: "fetch list with one sleep session")
        
        viewModel.$recentExercises
            .sink { exercise in
                XCTAssertFalse(exercise.isEmpty)
                XCTAssertEqual(exercise[0].startDate, date)
                XCTAssertEqual(exercise[0].duration, 45)
                XCTAssertEqual(exercise[0].category, "Running")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_WhenAddingMultipleExerciseInDatabase_FetchRecentExercise_ReturnAListContainingTheExercisesInTheRightOrder() {
        
        let persistenceController = PersistenceController(inMemory: true)
        emptyExerciseEntities(context: persistenceController.container.viewContext)

        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))
        
        addExercise(context: persistenceController.container.viewContext, category: "Running", duration: 45, intensity: 8, startDate: date1, userFirstName: "Marcel", userLastName: "Faye")
        addExercise(context: persistenceController.container.viewContext, category: "Football", duration: 90, intensity: 7, startDate: date2, userFirstName: "Marcel", userLastName: "Faye")
        addExercise(context: persistenceController.container.viewContext, category: "Natation", duration: 30, intensity: 5, startDate: date3, userFirstName: "Marcel", userLastName: "Faye")
        
        let viewModel = SharedViewModel(viewContext: persistenceController.container.viewContext)
        
        let expectation = expectation(description: "fetch list of sleep sessions")
        
        viewModel.$recentExercises
            .sink { exercise in
                XCTAssertFalse(exercise.isEmpty)
                XCTAssertEqual(exercise[0].category, "Running")
                XCTAssertEqual(exercise[1].category, "Football")
                XCTAssertEqual(exercise[2].category, "Natation")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
        
    }

}
