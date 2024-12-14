//
//  AristaTests.swift
//  AristaTests
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import XCTest
import CoreData
@testable import Arista

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
