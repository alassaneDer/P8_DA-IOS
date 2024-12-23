//
//  IconForCategory.swift
//  Arista
//
//  Created by Alassane Der on 22/12/2024.
//

import Foundation

func iconForCategory(_ category: String) -> String {
    switch category {
    case "Football":
        return "sportscourt"
    case "Natation":
        return "waveform.path.ecg"
    case "Running":
        return "figure.run"
    case "Marche":
        return "figure.walk"
    case "Cyclisme":
        return "bicycle"
    default:
        return "questionmark"
    }
}
