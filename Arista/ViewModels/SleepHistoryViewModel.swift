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
        
        _ = fetchSleepSessions()
    }
    
    
    // MARK: - Public
    
    func fetchSleepSessions()  -> Bool  {
        
        do {
            sleepSessions = try sleepRepository.getSleepSessions()
            
            return true
        }catch{
            
            return false
        }
        
    }
    
    func reload() throws  {
        _ = fetchSleepSessions()
        
    }
}
