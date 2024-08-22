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
        
        try? fetchSleepSessions()
    }
    
    // MARK: - ENUM
    enum FetchSleepSessionsError: Error {
        case fetchFailed,reloadFailed
    }
    
    // MARK: - Public
    
    func fetchSleepSessions() throws {
        
        do {
            sleepSessions = try sleepRepository.getSleepSessions()
            
        }catch{
            
            throw FetchSleepSessionsError.fetchFailed
            
        }
    }
    
    func reload()  {
        try?  fetchSleepSessions()
    }
}
