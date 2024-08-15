//
//  AddSleepViewModel.swift
//  Arista
//
//  Created by KEITA on 13/08/2024.
//

import Foundation
import CoreData

class AddSleepViewModel : ObservableObject{
    
    // MARK: - Properties
    
    @Published var quality: Int = 0
    @Published var startTime: Date = Date()
    @Published var duration: Int = 0
    
    
    private var viewContext: NSManagedObjectContext

    // MARK: - Init
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
  
    // MARK: - Public
  
    func addSleepSessions() -> Bool {
        do{
         let result =  try SleepRepository(viewContext: viewContext).addSleepSessions(duration: duration, quality: quality, startDate: startTime)
            print("\(result)")
            return true
        }catch{
            return false
        }
    }
    
}
