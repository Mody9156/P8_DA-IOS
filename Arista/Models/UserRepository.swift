//
//  UserRepository.swift
//  Arista
//
//  Created by KEITA on 01/08/2024.
//

import Foundation
import CoreData

struct UserRepository {
    
    // MARK: - Properties
    
    let viewContext : NSManagedObjectContext
    
    // MARK: - Init
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
         
    ) {
        self.viewContext = viewContext
        
    }
    
    // MARK: - Public
    
    func getUser() throws -> User? {
        let request = User.fetchRequest()
        request.fetchLimit = 1
        return try viewContext.fetch(request).first
                 
    }
    
}
