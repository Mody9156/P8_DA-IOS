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

    // MARK: - Init
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchExercises()
    }
    
    // MARK: - Enum
    
    enum ExerciseListError : Error {
        case InvalidExercises
    }

    // MARK: - Private
    
    private func fetchExercises() {
        // TODO: fetch data in CoreData and replace dumb value below with appropriate information
        do{
            let data = ExerciseRepository(viewContext: viewContext)
            exercises = try data.getExercise()
        }catch{
            ExerciseListError.InvalidExercises
        }
        
    }
    
    // MARK: - Public
    
    func reload(){
        fetchExercises()
    }
}
