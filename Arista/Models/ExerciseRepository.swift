//
//  ExerciseRepository.swift
//  Arista
//
//  Created by KEITA on 01/08/2024.
//

import Foundation
import CoreData

struct ExerciseRepository : DataExerciseProtocol{
    
    // MARK: - Properties
    
    let viewContext : NSManagedObjectContext
    
    // MARK: - Init
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    ) {
        self.viewContext = viewContext
    }

    
    // MARK: - Public
    @discardableResult
    
    func getExercise() throws -> [Exercise] {
        var result : [Exercise] = []
        try viewContext.performAndWait {
            let request = Exercise.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(SortDescriptor<Exercise>(\.startDate,order: .reverse))]
            
            result = try viewContext.fetch(request)
            
        }
        return result
        
    }
    
    func addExercise(category:String,duration:Int,intensity:Int,startDate:Date) throws {
        
         viewContext.performAndWait {
            let newExercise = Exercise(context: viewContext)
            newExercise.category = category
            newExercise.duration = Int64(duration)
            newExercise.intensity = Int64(intensity)
            newExercise.startDate = startDate
            do{
                newExercise.user = try UserRepository(viewContext: viewContext).getUser()
                
            }catch{
                 fatalError("Erreur : Impossible de récupérer l'utilisateur. Veuillez réessayer plus tard : \(error.localizedDescription)")
            }
            do{
                try viewContext.save()
            }catch{
                 fatalError("Erreur : Impossible de sauvegarder l'utilisateur. Veuillez réessayer plus tard : \(error.localizedDescription)")
            }
        }
        
    }
    
}

