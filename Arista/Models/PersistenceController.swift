//
//  Persistence.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//
import CoreData

class PersistenceController {
    
    // MARK: - Properties
  
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    let backgroundContext : NSManagedObjectContext
    
    // MARK: - Init
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Arista")
        backgroundContext = container.newBackgroundContext()
        
        if inMemory {
            try! DefaultData(viewContext: self.backgroundContext).apply()
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        self.backgroundContext.automaticallyMergesChangesFromParent = true//
        
        // Utilisation de backgroundContext pour charger des données par défaut
        backgroundContext.performAndWait {
            do {
                try DefaultData(viewContext: self.backgroundContext).apply()
                try self.backgroundContext.save()
            } catch {
                fatalError("Failed to apply default data: \(error.localizedDescription)")
            }
        }
    }
}
