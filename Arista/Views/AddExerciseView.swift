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
    @State private var error = ""
    @State private var value = 0
    @State var date : Date = Date()
    @State private var slider = 0.0
    
    let categories : [String] = ["Football","Natation","Running","Marche","Cyclisme","Yoga","Badminton","Handball","Corde à sauter"]
    
    var body: some View {
        
        NavigationStack{
            VStack {
                Form {
                    Section{
                        Picker("Catégorie : ", selection: $viewModel.category) {
                            
                            Text("Sélectionnez une catégorie").tag(nil as String?)
                                            .foregroundColor(.gray)
                            ForEach(categories,id:\.self) { category in
                                
                                
                                Text(category).tag(category).foregroundColor(category == "Sélectionnez une catégorie" ? .gray : .black)
                            }
                        }.pickerStyle(.navigationLink)
                        
                        DatePicker("Heure de démarrage : ", selection: $date,displayedComponents: .hourAndMinute)
                            .onChange(of: date) { newDate in
                                viewModel.startTime = newDate
                            }
                        
                        
                        Text("Durée : \(Int(slider)) minute(s)")
                        
                        Slider(
                            value: $slider,
                            in: 0...120){} minimumValueLabel : {
                                Text("0")
                            } maximumValueLabel: {
                                Text("120")
                            }
                            .onChange(of: slider) { newValue in
                                viewModel.duration = Int(slider)
                            }
                        
                        Stepper {
                            Text("Intensité : \(value)")
                        }onIncrement: {
                            incrementStep()
                        }onDecrement: {
                            decrementStep()
                        }
                        
                    }
                }.formStyle(.grouped)
                
                Spacer()
                
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .opacity(viewModel.errorMessage.isEmpty ? 0 : 1)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.errorMessage)
                
                Button("Ajouter l'exercice") {
                    if  !viewModel.whenElementIsEmpty(){
                        try? viewModel.addExercise()
                        presentationMode.wrappedValue.dismiss()
                    }
                }.buttonStyle(.borderedProminent)
                
            }
            .navigationTitle("Nouvel Exercice ...")
        }
        
        
    }
    
    
    func incrementStep(){
        value += 1
        
        if value >= 10{
            value = 10
            
        }
        viewModel.intensity = value
    }
    
    func decrementStep(){
        value -= 1
        
        if value < 0{
            value = 0
        }
        viewModel.intensity = value
    }
}


