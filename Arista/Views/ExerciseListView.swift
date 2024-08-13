//
//  ExerciseListView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct ExerciseListView: View {
    @ObservedObject var viewModel: ExerciseListViewModel
    @State private var showingAddExerciseView = false
    let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            List(viewModel.exercises) { exercise in
                HStack {
                    
                    if let category = exercise.category {
                        Image(systemName: iconForCategory(category))
                    }
                    
                    VStack(alignment: .leading) {
                        
                        if let category = exercise.category {
                            Text(category)
                                .font(.headline)
                        }
                        
                        if let duration = exercise.duration {
                            Text("Durée: \(duration) min")
                                .font(.subheadline)
                           
                        }
                        
                        if let date = exercise.startDate {
                            Text(dateFormatter.string(from: date))
                                .font(.subheadline)
                        }
                        
                        
                    }
                    Spacer()
                    IntensityIndicator(intensity: Int(exercise.intensity))
                }
            } .toolbar {
                EditButton()
            }
            .navigationTitle("Exercices")
            .navigationBarItems(trailing: Button(action: {
                showingAddExerciseView = true
            }) {
                Image(systemName: "plus")
            })
        }
        .sheet(isPresented: $showingAddExerciseView,onDismiss:didDismiss ) {
            AddExerciseView(viewModel: AddExerciseViewModel(context: viewModel.viewContext)).onAppear{
                viewModel.reload()
            }
        }
        
    }
    
    func didDismiss(){
        viewModel.reload()
    }
    
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
        case "Yoga" :
            return "figure.yoga"
        default:
            return "questionmark"
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
    
    

  
}
