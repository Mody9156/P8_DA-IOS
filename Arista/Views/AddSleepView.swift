//
//  AddSommeilView.swift
//  Arista
//
//  Created by KEITA on 12/08/2024.
//

import SwiftUI

struct AddSleepView: View {
    @State private var slider = 0.0
    @ObservedObject var viewModel: SleepHistoryViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var date : Date = Date.distantFuture
    @State private var value = 0

    var body: some View {
        NavigationStack {
            VStack {
                Form{
                    
                        Section{
                            DatePicker("Heure de démarrage : ", selection: $date,displayedComponents: .hourAndMinute)
        //                        .onChange(of: date) { newDate in
        //                            viewModel.startTime = newDate
        //                        }
                            Text("Durée : \(Int(slider)) heure(s)")
                            Slider(
                                value: $slider,
                                in: 0...24){} minimumValueLabel : {
                                    Text("0")
                                } maximumValueLabel: {
                                    Text("24")
                                }
//                                .onChange(of: slider) { newValue in
//                                    viewModel.sleepSessions.quality = Int64(Int(slider))
//                                }
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
                Button("Ajouter l'exercice") {
//                        if viewModel.reload {
//                            presentationMode.wrappedValue.dismiss()
//                        }
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

