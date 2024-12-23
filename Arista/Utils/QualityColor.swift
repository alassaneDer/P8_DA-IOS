//
//  QualityColor.swift
//  Arista
//
//  Created by Alassane Der on 22/12/2024.
//

import SwiftUI

func qualityColor(_ quality: Int) -> Color {
    switch (10-quality) {
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
