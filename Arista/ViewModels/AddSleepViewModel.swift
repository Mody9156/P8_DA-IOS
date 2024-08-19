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
    private var userRepository: DataSleepProtocol

    // MARK: - Init
    
    init(context: NSManagedObjectContext,repository : DataSleepProtocol = SleepRepository()) {
        self.viewContext = context
        self.userRepository = repository
    }
  
    // MARK: - Public
  
    func addSleepSessions() -> Bool {
        do{
          try SleepRepository(viewContext: viewContext).addSleepSessions(duration: duration, quality: quality, startDate: startTime)
            return true
        }catch{
            return false
        }
    }
    
}
