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
    
    // MARK: - Public
    
    func addExercise() {
        
        do{
            
            try ExerciseRepository(viewContext: viewContext).addExercise(category: category, duration: duration, intensity: intensity, startDate: startTime)
            
            errorMessage = ""
            
        }catch{
            errorMessage = "Erreur : Les éléments entrés sont incorrects. Veuillez vérifier les informations saisies et réessayer. Assurez-vous que tous les champs obligatoires sont remplis correctement."
        }
    }
}
