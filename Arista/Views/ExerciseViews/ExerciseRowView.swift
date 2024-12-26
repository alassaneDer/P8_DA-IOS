//
//  ListRowView.swift
//  Arista
//
//  Created by Alassane Der on 25/12/2024.
//

import SwiftUI

struct ExerciseRowView: View {
    var exercise: Exercise
    
    var body: some View {
        HStack {
            Image(systemName: iconForCategory(exercise.category!))
                .frame(width: 30, height: 30)
            VStack(alignment: .leading) {
                Text(exercise.category!)
                    .font(.headline)
                Text("Durée: \(exercise.duration) min")
                    .font(.subheadline)
                Text(exercise.startDate!.formatted())
                    .font(.subheadline)
                
            }
            Spacer()
            IntensityIndicator(intensity: Int(exercise.intensity))
        }
    }
}

struct IntensityIndicator: View {
    var intensity: Int
    
    var body: some View {
        Circle()
            .fill(colorForIntensity(intensity))
            .frame(width: 10, height: 10)
    }
}
