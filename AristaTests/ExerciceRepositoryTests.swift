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
}
