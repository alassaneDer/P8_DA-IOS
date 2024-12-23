//
//  IntensityDescription.swift
//  Arista
//
//  Created by Alassane Der on 22/12/2024.
//

import Foundation

func intensityDescription(_ intensity: Int) -> String {
    switch intensity {
    case 0...3:
        return "faible"
    case 4...6:
        return "Moyen"
    case 7...10:
        return "Forte"
    default:
        return "Intensité"
    }
}
