//
//  SleepHistoryViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

final class SleepHistoryViewModel: ObservableObject {
    @Published var sleepSessions = [Sleep]()
    @Published var message: String = ""
    
    private var viewContext: NSManagedObjectContext
    private let toastUtility: ToastUtility
    
    init(context: NSManagedObjectContext, toastUtility: ToastUtility = ToastUtility()) {
        self.viewContext = context
        self.toastUtility = toastUtility
        fetchSleepSessions()
    }
    
    private func fetchSleepSessions() {
        do {
            let data = SleepRepository(viewContext: viewContext)
            sleepSessions = try data.getSleepSessions()
            if sleepSessions.isEmpty {
                self.message = "Vous n'avez pas encore de sessions de sommeil."
            }
        }
        catch {
            message = "Nous ne parvenons pas à récupérer vos sessions de sommeils. Veuillez réessayer plutard!"
        }
    }
}
