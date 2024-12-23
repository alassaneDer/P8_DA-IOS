//
//  ExerciseListViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class ExerciseListViewModel: ObservableObject {
    @Published var exercises = [Exercise]()
    @Published var message: String = ""

    var viewContext: NSManagedObjectContext
    private let toastUtility: ToastUtility

    init(context: NSManagedObjectContext, toastUtility: ToastUtility = ToastUtility()) {
        self.viewContext = context
        self.toastUtility = toastUtility
        fetchExercises()
    }

    private func fetchExercises() {
        do {
            let data = ExerciceRepository(viewContext: viewContext)
            exercises = try data.getExercise()
        }
        catch {
            message = "Sorry can't load exercises, please try later!"
        }
    }
    
    func reload() {
        fetchExercises()
    }
    
    func showTemporaryToast() {
        toastUtility.showTemporaryToast(after: 5) {
            self.message = ""
        }
    }
    
}
