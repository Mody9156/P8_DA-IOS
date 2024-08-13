//
//  AddSommeilView.swift
//  Arista
//
//  Created by KEITA on 12/08/2024.
//

import SwiftUI

struct AddSleepView: View {
    @State private var slider = 0.0
    @ObservedObject var viewModel: AddExerciseViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var date : Date = Date.distantFuture
    @State private var value = 0

    var body: some View {
        NavigationStack {
            VStack {
                Form{
                    
                        Section{
                            DatePicker("Heure de démarrage : ", selection: $date,displayedComponents: .hourAndMinute)
                                .onChange(of: date) { newDate in
                                    viewModel.startTime = newDate
                                }
                            Text("Durée : \(Int(slider)) heure(s)")
                            Slider(
                                value: $slider,
                                in: 0...24){} minimumValueLabel : {
                                    Text("0")
                                } maximumValueLabel: {
                                    Text("24")
                                }
                                .onChange(of: slider) { newValue in
                                    viewModel.duration = Int(Int64(slider))
                                }
                            Stepper {
                                Text("Intensité : \(value)")
                            }onIncrement: {
                                incrementStep()
                            }onDecrement: {
                                decrementStep()
                            }.onChange(of: value) { newValue in
                                viewModel.intensity = newValue
                            }
                         
                        }
                    
                  
                   
               }.formStyle(.grouped)
                Spacer()
                Button("Ajouter l'exercice") {
                    if viewModel.addExercise() {
                            presentationMode.wrappedValue.dismiss()
                        }
                }.buttonStyle(.borderedProminent)

            } .navigationTitle("Nouvel element ...")
        }
    }
    func incrementStep(){
        value += 1
        
        if value >= 10{
            value = 10
            
        }
//        viewModel.intensity = value
    }
    
    func decrementStep(){
        value -= 1
        
        if value < 0{
            value = 0
        }
//        viewModel.intensity = value
    }
}

