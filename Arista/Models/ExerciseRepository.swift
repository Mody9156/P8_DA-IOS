//
//  ExerciseRepository.swift
//  Arista
//
//  Created by KEITA on 01/08/2024.
//

import Foundation

struct ExerciseRepository {
    // MARK: - Properties
    
    let viewContext : NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    // MARK: - Public
}
