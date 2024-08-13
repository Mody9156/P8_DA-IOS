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
        var result : [Sleep] = []
        
       try viewContext.performAndWait {
           let request : NSFetchRequest<Sleep> = Sleep.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(SortDescriptor<Sleep>(\.startDate,order: .reverse))]
            do{
                result =  try viewContext.fetch(request)

            }catch{
                throw error
            }
           
        }
        return  result
    }
    
    func addSleepSessions(duration:Int,quality:Int,startDate:Date) throws {
        try viewContext.performAndWait {
            let newSleepSessions = Sleep(context: viewContext)
            newSleepSessions.duration = Int64(duration)
            newSleepSessions.quality = Int64(quality)
            newSleepSessions.startDate = startDate
            
            do{
                newSleepSessions.user = try UserRepository(viewContext: viewContext).getUser()
                
            }catch{
               
            }
            
            do{
                try viewContext.save()
            }catch{
                throw error
            }
        }
      
    }
}
