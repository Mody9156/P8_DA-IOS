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
   
    var body: some View {
        NavigationStack {
            VStack {
                Form{
                    
                        Section{
                            Text("Durée : \(Int(slider)) minute(s)")
                            Slider(
                                value: $slider,
                                in: 0...120){} minimumValueLabel : {
                                    Text("0")
                                } maximumValueLabel: {
                                    Text("120")
                                }
//                                .onChange(of: slider) { newValue in
//                                    viewModel.sleepSessions.quality = Int64(Int(slider))
//                                }
                        }

                   
               }
            }
        }
    }
}

