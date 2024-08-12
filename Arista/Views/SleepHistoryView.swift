//
//  SleepHistoryView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct SleepHistoryView: View {
    @ObservedObject var viewModel: SleepHistoryViewModel
    @State private var showingAddExerciseView = false
    
    var body: some View {
        NavigationStack{
            List(viewModel.sleepSessions) { session in
                HStack {
                    QualityIndicator(quality: Int(session.quality))
                        .padding()
                    VStack(alignment: .leading) {
                        
                        if let date = session.startDate {
                            Text("Début : \(date.formatted())")
                        }
                        
                        Text("Durée : \(session.duration/60) heures")
                    }
                }
            }
            .navigationTitle("Historique de sommeil")
            .navigationBarItems(trailing: Button(action: {
                showingAddExerciseView = true
            }) {
                Image(systemName: "plus")
            })
        }
        .sheet(isPresented: $showingAddExerciseView,onDismiss:didDismiss ) {
            AddSleepView().onAppear{
                viewModel.reload()
            }
        }
        
    }
    
    
    
    func didDismiss(){
        viewModel.reload()
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
    }

