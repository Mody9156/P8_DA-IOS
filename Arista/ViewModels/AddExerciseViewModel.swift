//
//  AddExerciseViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class AddExerciseViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var category: String = ""
    @Published var startTime: Date = Date()
    @Published var duration: Int = 0
    @Published var intensity: Int = 0
    
    private var viewContext: NSManagedObjectContext
    
    // MARK: - Init
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
    
    // MARK: - Public
    
    func addExercise() -> Bool {
        guard !category.isEmpty else{return false}
        do{
            let  exerciseRepository = ExerciseRepository()
            let existingExercises = try exerciseRepository.getExercise().filter{ exercise in
                exercise.category == category && exercise.startDate == startTime
            }
            if existingExercises.isEmpty {
              try  exerciseRepository.addExercise(category: category, duration: duration, intensity: intensity, startDate: startTime)
                return true
            }else{
                return false
            }
         
        }catch{
            return false
        }
    }
}
