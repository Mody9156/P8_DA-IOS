//
//  ExerciseListViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation

import CoreData

class ExerciseListViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var exercises = [Exercise]()
    
    var viewContext: NSManagedObjectContext
    private var exerciseRepository: DataExerciseProtocol
    
    
    // MARK: - Init
    @discardableResult

    init(context: NSManagedObjectContext,repository : DataExerciseProtocol = ExerciseRepository()) {
        self.viewContext = context
        self.exerciseRepository = repository
         fetchExercises()
    }
    
    // MARK: - Public
    
    func fetchExercises() {
        
        do{
            exercises = try exerciseRepository.getExercise()
          
        }catch{
            fatalError("Erreur : Les éléments entrés sont incorrects. Veuillez vérifier les informations saisies et réessayer. Assurez-vous que tous les champs obligatoires sont remplis correctement. Description : \(error.localizedDescription)")
        }
        
    }
    
    func reload(){
        fetchExercises()
    }
}
