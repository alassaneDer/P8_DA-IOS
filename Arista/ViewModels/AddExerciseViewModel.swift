//
//  AddExerciseViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class AddExerciseViewModel: ObservableObject {
    @Published var category: String = ""
    @Published var startTime: Date = Date()
    @Published var duration: Int = 0
    @Published var intensity: Int = 0
    @Published var message: String = ""
    
    @Published var imageForCategory: [String] = ["Running", "Football", "Cyclisme", "Marche", "Natation"]
    @Published var selectedCategory: String = "Running"
    @Published var selectedHours: Int = 0
    @Published var selectedMinutes: Int = 0
    @Published var maxHours = 12
    @Published var minutesRange = Array(1...60)
    

    private var viewContext: NSManagedObjectContext
    private let toastUtility: ToastUtility
    private struct ExerciseDuration {
        var hours: Int
        var minutes: Int
    }
    
   
    private func totalDurationInMinutes() -> Int {
        return selectedHours * 60 + selectedMinutes
    }

    init(context: NSManagedObjectContext, toastUtility: ToastUtility = ToastUtility()) {
        self.viewContext = context
        self.toastUtility = toastUtility
    }

    func addExercise() -> Bool {
        do {
            self.category = selectedCategory
            self.duration = totalDurationInMinutes()
            try ExerciceRepository(viewContext: viewContext).addExercise(category: category, duration: duration, intensity: intensity, startDate: startTime)
            return true
        }
        catch {
            message = "Sorry can't add exercise, please try later!"
            return false
        }
    }
    
    func showTemporaryToast() {
        toastUtility.showTemporaryToast(after: 5) {
            self.message = ""
        }
    }
}


//
//    var startTimeSTring: String {
//        get {
//            let formatter = DateFormatter()
//            formatter.dateStyle = .medium
//            formatter.timeStyle = .none
//            return formatter.string(from: startTime)
//        }
//        set {
//            let formatter = DateFormatter()
//            formatter.dateStyle = .medium
//            formatter.timeStyle = .none
//            if let value = formatter.date(from: newValue) {
//                startTime = value
//            }
//        }
//    }
//
//    var durationString: String {
//        get {
//            String(duration)
//        }
//        set {
//            if let value = Int(newValue) {
//                duration = value
//            }
//        }
//    }
//
//    var intensityString: String {
//        get {
//            String(intensity)
//        }
//        set {
//            if let value = Int(newValue) {
//                intensity = value
//            }
//        }
//    }
