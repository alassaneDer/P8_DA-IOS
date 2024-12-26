//
//  SleepHistoryView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct SleepHistoryView: View {
    @ObservedObject var viewModel: SleepHistoryViewModel

        var body: some View {
            NavigationStack {
                if !viewModel.message.isEmpty {
                    VStack {
                        ErrorMessageView(message: viewModel.message)
                        PlusButtonView {
                            // lien vers la vue ajout de sessions de sommeil
                            
                        }
                    }
                    .padding(.top)
                }
                List(viewModel.sleepSessions) { session in
                    SleepHistoryRowView(session: session)
                }
                .navigationTitle("Historique de Sommeil")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
}

#Preview {
    SleepHistoryView(viewModel: SleepHistoryViewModel(context: PersistenceController.preview.container.viewContext))
}
/*
NB: La fonctionalité ajout de sessions de sommeil n'étant pas requise dans le projet, nous n'avons pas jugé utile de le faire
 */
