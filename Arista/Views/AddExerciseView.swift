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
    var array : [String] = ["Football","Natation","Running","Marche","Cyclisme"]

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section{
                        Picker("Catégorie", selection: $viewModel.category) {
                            ForEach(array,id:\.self) { category in
                                Text(category).tag(category)
                            }
                        }.pickerStyle(MenuPickerStyle())
                        
//                        TextField("Catégorie", text: $viewModel.category)
                        
                        let dateFormatter : DateFormatter = {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                            return formatter
                        }()
                        TextField("Heure de démarrage", text: $startTimeText).onChange(of: startTimeText) { newValue in
                            
                            if let hours = dateFormatter.date(from: newValue){
                                viewModel.startTime = hours
                            }else {
                                viewModel.startTime =  Date()
                            }
                          
                           
                        }
                        TextField("Durée (en minutes)", text: $integerText).onChange(of: integerText) { newValue in
                           
                            if let timer = Int(newValue) {
                                viewModel.duration = timer
                            }else {
                                viewModel.duration  = 0
                            }
                           
                            
                        }
                        TextField("Intensité (0 à 10)", text: $intensityText).onChange(of: integerText) { newValue in
                           
                            if let intensity = Int(newValue) {
                                viewModel.intensity = intensity
                            }else {
                                viewModel.intensity = 0
                            }
                          
                            
                        }
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

