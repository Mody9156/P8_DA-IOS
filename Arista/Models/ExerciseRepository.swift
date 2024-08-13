//
//  ExerciseRepository.swift
//  Arista
//
//  Created by KEITA on 01/08/2024.
//

import Foundation
import CoreData

struct ExerciseRepository {
    
    // MARK: - Properties
    
    let viewContext : NSManagedObjectContext
    
    // MARK: - Init
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    // MARK: - Public
    
    func getExercise() throws -> [Exercise]{
        let request = Exercise.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(SortDescriptor<Exercise>(\.startDate,order: .reverse))]
        
        return try viewContext.fetch(request)
    }
    
    func addExercise(category:String,duration:Int,intensity:Int,startDate:Date) throws {
        let newExercise = Exercise(context: viewContext)
        newExercise.category = category
        newExercise.duration = Int64(duration)
        newExercise.intensity = Int64(intensity)
        newExercise.startDate = startDate
        newExercise.user = try UserRepository(viewContext: viewContext).getUser()
        
        try viewContext.save()
        
    }
    
    func deleteExercise(_ exercise : Exercise) throws{
        viewContext.delete(exercise)
        try viewContext.save()
    }
}
