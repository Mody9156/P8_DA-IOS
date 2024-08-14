//
//  Persistence.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//
import CoreData

class PersistenceController {
    
    // MARK: - Singleton
    
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer
    let backgroundContext : NSManagedObjectContext

    // MARK: - Init
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Arista")
        backgroundContext = container.newBackgroundContext()
        
        if inMemory {
            try! DefaultData(viewContext: container.viewContext).apply()
        }
        
        let storeDescription = container.persistentStoreDescriptions.first
        storeDescription?.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        storeDescription?.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)

        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // Utilisation de backgroundContext pour charger des données par défaut
        backgroundContext.perform {
            do {
                try DefaultData(viewContext: self.backgroundContext).apply()
                try self.backgroundContext.save()
            } catch {
                fatalError("Failed to apply default data: \(error.localizedDescription)")
            }
        }
    }
}
