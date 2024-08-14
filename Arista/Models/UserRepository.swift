//
//  UserRepository.swift
//  Arista
//
//  Created by KEITA on 01/08/2024.
//

import Foundation
import CoreData

struct UserRepository : DataRepositoryProtocol {
    
    // MARK: - Properties
    
    let viewContext : NSManagedObjectContext
    // MARK: - Init
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    // MARK: - Public
    
    func getUser() throws -> User? {
        var result : User?
       try viewContext.performAndWait {
            let request : NSFetchRequest<User> = User.fetchRequest()
            request.fetchLimit = 1
            do{
                result = try viewContext.fetch(request).first
            }catch{
                throw error
            }
        }
        return result
                 
    }
    
}
