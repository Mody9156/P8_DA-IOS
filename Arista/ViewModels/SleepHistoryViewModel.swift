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
    private var sleepRepository: DataSleepProtocol

    // MARK: - Init
    
    init(context: NSManagedObjectContext,repository : DataSleepProtocol = SleepRepository()) {
        self.viewContext = context
        self.sleepRepository = repository

        fetchSleepSessions()
    }
  
    
    // MARK: - Private
    
    private func fetchSleepSessions() {
        
        do {
            let data = SleepRepository(viewContext: viewContext)
            sleepSessions = try!- data.getSleepSessions()
        }catch{
            fatalError()
        }
         
    }
    
    // MARK: - Public
    
    func reload(){
        fetchSleepSessions()
    }

}
