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
    
    private var viewContext: NSManagedObjectContext
    
    // MARK: - Init
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchSleepSessions()
    }
    
    // MARK: - Enum
    
    enum SleepHistoryError : Error {
        case InvalidSleep
    }

    
    // MARK: - Private
    
    private func fetchSleepSessions() {
        
        do{
            let data = SleepRepository(viewContext: viewContext)
            sleepSessions = try data.getSleepSessions()
        }catch{
            SleepHistoryError.InvalidSleep
        }
    }
    
    // MARK: - Public
    
    func reload(){
        fetchSleepSessions()
    }

}
