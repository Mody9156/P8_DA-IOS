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
    private var userRepository: DataExerciseProtocol

    
    // MARK: - Init
    
    init(context: NSManagedObjectContext,repository : DataExerciseProtocol = ExerciseRepository()) {
        self.viewContext = context
        self.userRepository = repository
        fetchExercises()
    }
    
    // MARK: - Private
    
    private func fetchExercises() {
        
        let data = ExerciseRepository(viewContext: viewContext)
        exercises = try! data.getExercise()
    }
    
    // MARK: - Public
    
    func reload(){
        fetchExercises()
    }
}
