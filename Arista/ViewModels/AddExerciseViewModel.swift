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
    @Published var errorMessage = ""
    
    private var viewContext: NSManagedObjectContext
    private var userRepository: DataExerciseProtocol
    // MARK: - Init
    
    init(context: NSManagedObjectContext,repository : DataExerciseProtocol = ExerciseRepository()) {
        self.viewContext = context
        self.userRepository = repository
    }
    // MARK: - ENUM
    enum AddExerciseError: Error {
        case addExerciseFailure
    }
    
    // MARK: - Public
    
    @discardableResult
    
    func whenElementIsEmpty() -> Bool {
        if category.isEmpty || duration <= 0  {
            errorMessage = "Erreur : Tous les champs doivent être remplis correctement."
            return true
        }
        errorMessage = ""
        return false
    }
    
    func addExercise() throws {
        
        whenElementIsEmpty()
        
        do{
            
            try userRepository.addExercise(category: category, duration: duration, intensity: intensity, startDate: startTime)
            
        }catch{
            
        errorMessage = "Erreur : Tous les champs doivent être remplis correctement."
        throw AddExerciseError.addExerciseFailure
        }
    }
    
    
}

