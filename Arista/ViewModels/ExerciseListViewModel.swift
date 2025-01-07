//
//  ExerciseListViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

final class ExerciseListViewModel: ObservableObject {
    @Published var exercises = [Exercise]()
    @Published var message: String = ""

    var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchExercises()
    }

    private func fetchExercises() {
        do {
            let data = ExerciceRepository(viewContext: viewContext)
            exercises = try data.getExercise()
            if exercises.isEmpty {
                self.message = "Vous n'avez pas encore renseigné d'exercices physiques."
            }
        }
        catch {
            self.message = "Nous ne parvenons pas à récupérer vos sessions de sommeils. Veuillez réessayer plutard!"
        }
    }
    
    func reload() {
        fetchExercises()
    }
    
}
