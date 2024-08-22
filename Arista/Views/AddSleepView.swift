//
//  AddSommeilView.swift
//  Arista
//
//  Created by KEITA on 12/08/2024.
//

import SwiftUI

struct AddSleepView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var slider = 0.0
    @ObservedObject var viewModel: AddSleepViewModel
    @State var date : Date = Date.distantPast
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
                                viewModel.duration = Int(newValue)
                            }
                        Stepper {
                            Text("Quality : \(value)")
                        }onIncrement: {
                            incrementStep()
                        }onDecrement: {
                            decrementStep()
                        }.onChange(of: value) { newValue in
                            viewModel.quality = Int(Int64(newValue))
                        }
                        
                    }
                    
                }.formStyle(.grouped)
                
                Spacer()
                
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .opacity(viewModel.errorMessage.isEmpty ? 0 : 1)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.errorMessage)
                
                Button("Ajouter l'exercice") {
                    if !viewModel.whenElementIsEmpty(){
                        try? viewModel.addSleepSessions()
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
        
    }
    
    func decrementStep(){
        value -= 1
        
        if value < 0{
            value = 0
        }
        
    }
}

