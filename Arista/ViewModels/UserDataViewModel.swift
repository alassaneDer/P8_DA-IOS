//
//  UserDataViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class UserDataViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var message: String = ""

    private var viewContext: NSManagedObjectContext
    private let toastUtility: ToastUtility

    init(context: NSManagedObjectContext, toastUtility: ToastUtility = ToastUtility()) {
        self.viewContext = context
        self.toastUtility = toastUtility
        fetchUserData()
    }

    private func fetchUserData() {
        do {
            guard let user = try UserRepository().getUser() else {
                fatalError()
            }
            firstName = user.firstName ?? ""
            lastName = user.lastName ?? ""
        }
        catch {
            message = "Sorry user not founded!, please try later!"
        }
    }
    
    func showTemporaryToast() {
        toastUtility.showTemporaryToast(after: 5) {
            self.message = ""
        }
    }
}
