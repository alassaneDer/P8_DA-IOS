//
//  ExerciceRepositoryTests.swift
//  AristaTests
//
//  Created by Alassane Der on 14/12/2024.
//

import XCTest
import CoreData
@testable import Arista

final class ExerciceRepositoryTests: XCTestCase {

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
        
        let newExercise = Exercise(context: context)
        newExercise.category = category
        newExercise.duration = Int64(duration)
        newExercise.intensity = Int64(intensity)
        newExercise.startDate = startDate
        newExercise.user = newUser
        
        try! context.save()
    }
    
    func test_WhenNoExerciseIsInDatabase_GetExercise_ReturnEmptyList() {
        // clean manually all data
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let data = ExerciceRepository(viewContext: persistenceController.container.viewContext)
        
        let exercises = try! data.getExercise()
        
        XCTAssertTrue(exercises.isEmpty)
    }
    
    func test_WhenAddingOneExerciseInDatabase_GetExercise_ReturnAListContainingTheExercise() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let date = Date()
        
        addExercises(context: persistenceController.container.viewContext, category: "Natation", duration: 10, intensity: 5, startDate: date, userFirstName: "Nicolas", userLastName: "Laporte")
        
        let data = ExerciceRepository(viewContext: persistenceController.container.viewContext)
        
        let exercises = try! data.getExercise()
        
        XCTAssertFalse(exercises.isEmpty)
        XCTAssertEqual(exercises.first?.category, "Natation")
        XCTAssertEqual(exercises.first?.duration, 10)
        XCTAssertEqual(exercises.first?.intensity, 5)
        XCTAssertEqual(exercises.first?.startDate, date)
    }
    
    func test_WhenAddingMultipleExerciseInDatabase_GetExercise_ReturnAListContainingTheExerciseInTheRightOrder() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))
        
        addExercises(context: persistenceController.container.viewContext,
                     category: "Football",
                     duration: 90,
                     intensity: 9,
                     startDate: date1,
                     userFirstName: "David",
                     userLastName: "Renault")
        addExercises(context: persistenceController.container.viewContext,
                     category: "Natation",
                     duration: 20,
                     intensity: 9,
                     startDate: date2,
                     userFirstName: "David",
                     userLastName: "Renault")
        addExercises(context: persistenceController.container.viewContext,
                     category: "Running",
                     duration: 30,
                     intensity: 4,
                     startDate: date3,
                     userFirstName: "David",
                     userLastName: "Renault")
        
        let data = ExerciceRepository(viewContext: persistenceController.container.viewContext)
        
        let exercises = try! data.getExercise()
        
        XCTAssertFalse(exercises.isEmpty)
        XCTAssertEqual(exercises[0].category, "Football")
        XCTAssertEqual(exercises[1].category, "Natation")
        XCTAssertEqual(exercises[2].category, "Running")
    }
    
    func test_WhenAddingExerciseInDatabase_ReturnAListContainingTheExercise() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let date = Date()
        
        let data = ExerciceRepository(viewContext: persistenceController.container.viewContext)
        
        try! data.addExercise(
            category: "Natation",
            duration: 30,
            intensity: 7,
            startDate: date
        )
        let request = Exercise.fetchRequest()
        let exercise = try! persistenceController.container.viewContext.fetch(request)
        
        XCTAssertFalse(exercise.isEmpty)
        XCTAssertEqual(exercise.first?.category, "Natation")
    }
    
    
    // MARK: getRecentExercise tests
    func test_WhenNoExerciseIsInDatabase_getRecentExercises_DoesNotReturnExercise() {
        let persistenceContainer = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceContainer.container.viewContext)
        
        let data = ExerciceRepository(viewContext: persistenceContainer.container.viewContext)
        
        let exercise = try! data.getRecentExercices()
        
        XCTAssertTrue(exercise.isEmpty)
    }
    
    func test_WhenAddingOneExerciseInDatabase_GetRecentExercise_ReturnAListContainingTheExercise() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let date = Date()
        
        addExercises(context: persistenceController.container.viewContext, category: "Natation", duration: 10, intensity: 5, startDate: date, userFirstName: "Nicolas", userLastName: "Laporte")
        
        let data = ExerciceRepository(viewContext: persistenceController.container.viewContext)
        
        let exercises = try! data.getRecentExercices()
        
        XCTAssertFalse(exercises.isEmpty)
        XCTAssertEqual(exercises.first?.category, "Natation")
        XCTAssertEqual(exercises.first?.duration, 10)
        XCTAssertEqual(exercises.first?.intensity, 5)
        XCTAssertEqual(exercises.first?.startDate, date)
    }
    
    func test_WhenAddingMultipleExerciseInDatabase_GetRecentExercise_ReturnOnlyThe7firstsExercisesInTheRightOrder() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))
        let date4 = Date(timeIntervalSinceNow: -(60*60*24*3))
        let date5 = Date(timeIntervalSinceNow: -(60*60*24*4))
        let date6 = Date(timeIntervalSinceNow: -(60*60*24*5))
        let date7 = Date(timeIntervalSinceNow: -(60*60*24*6))
        let date8 = Date(timeIntervalSinceNow: -(60*60*24*7))
        let date9 = Date(timeIntervalSinceNow: -(60*60*24*8))
        let date10 = Date(timeIntervalSinceNow: -(60*60*24*9))
        
        addExercises(context: persistenceController.container.viewContext, category: "Football", duration: 80, intensity: 7, startDate: date1, userFirstName: "John", userLastName: "McGil")
        addExercises(context: persistenceController.container.viewContext, category: "Football", duration: 74, intensity: 8, startDate: date2, userFirstName: "John", userLastName: "McGil")
        addExercises(context: persistenceController.container.viewContext, category: "Football", duration: 60, intensity: 9, startDate: date3, userFirstName: "John", userLastName: "McGil")
        addExercises(context: persistenceController.container.viewContext, category: "Football", duration: 45, intensity: 6, startDate: date4, userFirstName: "John", userLastName: "McGil")
        addExercises(context: persistenceController.container.viewContext, category: "Football", duration: 62, intensity: 4, startDate: date5, userFirstName: "John", userLastName: "McGil")
        addExercises(context: persistenceController.container.viewContext, category: "Football", duration: 40, intensity: 5, startDate: date6, userFirstName: "John", userLastName: "McGil")
        addExercises(context: persistenceController.container.viewContext, category: "Football", duration: 90, intensity: 3, startDate: date7, userFirstName: "John", userLastName: "McGil")
        addExercises(context: persistenceController.container.viewContext, category: "Football", duration: 77, intensity: 9, startDate: date8, userFirstName: "John", userLastName: "McGil")
        addExercises(context: persistenceController.container.viewContext, category: "Football", duration: 60, intensity: 7, startDate: date9, userFirstName: "John", userLastName: "McGil")
        addExercises(context: persistenceController.container.viewContext, category: "Football", duration: 40, intensity: 7, startDate: date10, userFirstName: "John", userLastName: "McGil")
        
        let data = ExerciceRepository(viewContext: persistenceController.container.viewContext)
        let exercise = try! data.getRecentExercices()
        
        XCTAssertFalse(exercise.isEmpty)
        XCTAssertEqual(exercise.count, 7)
        XCTAssertEqual(exercise[0].intensity, 7)
        XCTAssertEqual(exercise.last!.intensity, 3)
    }
}
