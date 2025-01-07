//
//  ExerciseListViewModelTests.swift
//  AristaTests
//
//  Created by Alassane Der on 15/12/2024.
//

import XCTest
import CoreData
import Combine
@testable import Arista

final class ExerciseListViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest = Exercise.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        for exercise in objects {
            context.delete(exercise)
        }
        
        try! context.save()
    }
    
    private func addExercises(context: NSManagedObjectContext, category: String, duration: Int, intensity: Int, startDate: Date, userFirstName: String, userLastName: String) {
        
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
    
    func test_WhenNoExerciseIsInDatabase_FetchExercise_ReturnEmptyList() throws {
        
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let viewModel = ExerciseListViewModel(context: persistenceController.container.viewContext)
        
        let expectation = XCTestExpectation(description: "fetch empty list of exercises")
        
        viewModel.$exercises
            .sink { exercises in
                XCTAssert(exercises.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_WhenAddingOneExerciseInDatabase_FEtchExercise_ReturnAListContainingTheExercise() {
        
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let date = Date()
        
        addExercises(
            context: persistenceController.container.viewContext,
            category: "Marche",
            duration: 30,
            intensity: 5,
            startDate: date,
            userFirstName: "Bertrand",
            userLastName: "Rachford"
        )
        
        let viewModel = ExerciseListViewModel(context: persistenceController.container.viewContext)
        
        let expectation = expectation(description: "fetch empty list of exercises")
        
        viewModel.$exercises
            .sink { exercise in
                XCTAssertFalse(exercise.isEmpty)
                XCTAssertEqual(exercise.first?.category, "Marche")
                XCTAssertEqual(exercise.first?.duration, 30)
                XCTAssertEqual(exercise.first?.intensity, 5)
                XCTAssertEqual(exercise.first?.startDate, date)
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
        
        addExercises(
            context: persistenceController.container.viewContext,
            category: "Football",
            duration: 90,
            intensity: 9,
            startDate: date1,
            userFirstName: "Bertrand",
            userLastName: "Rachford"
        )
        addExercises(
            context: persistenceController.container.viewContext,
            category: "Marche",
            duration: 30,
            intensity: 5,
            startDate: date2,
            userFirstName: "Bertrand",
            userLastName: "Rachford"
        )
        addExercises(
            context: persistenceController.container.viewContext,
            category: "Running",
            duration: 15,
            intensity: 8,
            startDate: date3,
            userFirstName: "Bertrand",
            userLastName: "Rachford"
        )
        
        let viewModel = ExerciseListViewModel(context: persistenceController.container.viewContext)
        
        let expectation = expectation(description: "fetch empty list of exercices")
        
        viewModel.$exercises
            .sink { exercise in
                XCTAssertFalse(exercise.isEmpty)
                XCTAssertEqual(exercise[0].category, "Football")
                XCTAssertEqual(exercise[1].category, "Marche")
                XCTAssertEqual(exercise[2].category, "Running")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
        
    }
}
