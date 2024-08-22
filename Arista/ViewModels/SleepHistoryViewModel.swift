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
    
    // MARK: - ENUM
    enum FetchSleepSessionsError: Error {
        case fetchFailed
    }
    
    // MARK: - Public
    
    func fetchSleepSessions()    {
        
        do {
            sleepSessions = try sleepRepository.getSleepSessions()
            
          
        }catch{
            FetchSleepSessionsError.fetchFailed
            
        }
        
    }
    
    func reload() throws  {
      fetchSleepSessions()
        
    }
}
