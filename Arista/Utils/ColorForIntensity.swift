//
//  ColorForIntensity.swift
//  Arista
//
//  Created by Alassane Der on 22/12/2024.
//

import SwiftUI

func colorForIntensity(_ intensity: Int) -> Color {
    switch intensity {
    case 0...3:
        return .green
    case 4...6:
        return .yellow
    case 7...10:
        return .red
    default:
        return .gray
    }
}
