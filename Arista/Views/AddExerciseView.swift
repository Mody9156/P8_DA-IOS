//
//  AddExerciseView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct AddExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddExerciseViewModel
    @State private var integerText = ""
    @State private var intensityText = ""
    @State private var startTimeText = ""

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Catégorie", text: $viewModel.category)
                    TextField("Heure de démarrage", text: $startTimeText).onChange(of: startTimeText) { newValue in
                        viewModel.startTime = DateFormatter.date(newValue)
                    }
                    TextField("Durée (en minutes)", text: $integerText).onChange(of: integerText) { newValue in
                        viewModel.duration = Int(newValue)
                    }
                    TextField("Intensité (0 à 10)", text: $intensityText).onChange(of: integerText) { newValue in
                        viewModel.intensity = Int(newValue)
                    }
                }.formStyle(.grouped)
                Spacer()
                Button("Ajouter l'exercice") {
                    if viewModel.addExercise() {
                        presentationMode.wrappedValue.dismiss()
                    }
                }.buttonStyle(.borderedProminent)
                    
            }
            .navigationTitle("Nouvel Exercice ...")
            
        }
    }
}

