//
//  SleepRepository.swift
//  Arista
//
//  Created by KEITA on 01/08/2024.
//

import Foundation
import CoreData

struct SleepRepository {
    
    // MARK: - Properties
    
    let viewContext : NSManagedObjectContext
    
    // MARK: - Init
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    // MARK: - Public
    
    func getSleepSessions() throws -> [Sleep] {
        let request = Sleep.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(SortDescriptor<Sleep>(\.startDate,order: .reverse))]
        return try viewContext.fetch(request)
    }
    
    func addSleepSessions(duration:Int,quality:Int,startDate:Date) throws {
        let newSleepSessions = Sleep(context: viewContext)
        newSleepSessions.duration = Int64(duration)
        newSleepSessions.quality = Int64(quality)
        newSleepSessions.startDate = startDate
        newSleepSessions.user = try UserRepository(viewContext: viewContext).getUser()
        
        try viewContext.save()
        
    }
}
