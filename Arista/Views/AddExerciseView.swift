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
    @State private var date = Date()

    var array : [String] = ["Football","Natation","Running","Marche","Cyclisme","Yoga"]

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
                       
                        
                        DatePicker("Heure de démarrage : ", selection: $date,displayedComponents: [.date]).onAppear{
                            viewModel.startTime = date
                        }
                        
                        
                        TextField("Durée (en minutes)", text: $integerText).onChange(of: integerText) { newValue in
                           
                            if let timer = Int(newValue) {
                                viewModel.duration = timer
                            }else {
                                viewModel.duration  = 0
                            }
                           
                            
                        }
//                        TextField("Intensité (0 à 10)", text: $intensityText).onChange(of: integerText) { newValue in
//
//                            if let intensity = Int(newValue),intensity >= 0 && intensity <= 10 {
//                                viewModel.intensity = intensity
//                            }
//
//
//                        }.keyboardType(.numberPad)
//                        //steppe
                        
                        Stepper {
                            Text("Intensité : \(value)")
                        }onIncrement: {
                            incrementStep()
                        }onDecrement: {
                            decrementStep()
                        }
                        
                    }
                }.formStyle(.grouped)
                Text(error).foregroundColor(.red).onAppear{
                   error =  viewModel.error_InForm()
                }
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

