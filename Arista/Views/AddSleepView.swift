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

    var body: some View {
        NavigationStack {
            VStack {
                Form{
                    
                        Section{
                            Text("Durée : \(Int(slider)) heure(s)")
                            Slider(
                                value: $slider,
                                in: 0...120){} minimumValueLabel : {
                                    Text("0")
                                } maximumValueLabel: {
                                    Text("20")
                                }
//                                .onChange(of: slider) { newValue in
//                                    viewModel.sleepSessions.quality = Int64(Int(slider))
//                                }
                        }
                    Spacer()
                    Button("Ajouter l'exercice") {
//                        if viewModel.reload {
//                            presentationMode.wrappedValue.dismiss()
//                        }
                    }.buttonStyle(.borderedProminent)

                   
               }
            } .navigationTitle("Nouvel element ...")
        }
    }
}

