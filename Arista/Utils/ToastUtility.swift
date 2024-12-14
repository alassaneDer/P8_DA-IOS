//
//  ToastUtility.swift
//  Arista
//
//  Created by Alassane Der on 14/12/2024.
//

import Foundation

class ToastUtility {
    func showTemporaryToast(after delay: TimeInterval, _ completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion()
        }
    }
}
