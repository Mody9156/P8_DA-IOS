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
    
    // MARK: - ENUM
    enum FetchExercisesError: Error {
        case fetchFailed
    }

    // MARK: - Public
   
    func fetchExercises() throws {
        
        do{
            exercises = try exerciseRepository.getExercise()
          
        }catch{
          throw  FetchExercisesError.fetchFailed
        }
        
    }
    
    func reload(){
        fetchExercises()
    }
}
