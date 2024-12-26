//
//  SleepHistoryRowView.swift
//  Arista
//
//  Created by Alassane Der on 26/12/2024.
//

import SwiftUI

struct SleepHistoryRowView: View {
    var session: Sleep
    
    var body: some View {
        HStack {
            QualityIndicator(quality: Int(session.quality))
                .padding()
            VStack(alignment: .leading) {
                Text("Début : \(session.startDate!.formatted())")
                Text("Durée : \(session.duration/60) heures")
            }
        }
    }
}

struct QualityIndicator: View {
    let quality: Int

    var body: some View {
        ZStack {
            Circle()
                .stroke(qualityColor(quality), lineWidth: 5)
                .foregroundColor(qualityColor(quality))
                .frame(width: 30, height: 30)
            Text("\(quality)")
                .foregroundColor(qualityColor(quality))
        }
    }
}
