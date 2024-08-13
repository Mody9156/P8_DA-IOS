//
//  SleepHistoryViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class SleepHistoryViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var sleepSessions = [Sleep]()
    
     var viewContext: NSManagedObjectContext
    
    // MARK: - Init
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchSleepSessions()
    }
  
    
    // MARK: - Private
    
    private func fetchSleepSessions() {
      
            let data = SleepRepository(viewContext: viewContext)
            sleepSessions = try! data.getSleepSessions()
     
    }
    
    // MARK: - Public
    
    func reload(){
        fetchSleepSessions()
    }

}
