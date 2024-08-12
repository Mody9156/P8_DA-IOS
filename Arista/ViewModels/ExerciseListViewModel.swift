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
   
    // MARK: - Private
    
    private func fetchExercises() {
        // TODO: fetch data in CoreData and replace dumb value below with appropriate information
        
            let data = ExerciseRepository(viewContext: viewContext)
            exercises = try! data.getExercise()
    }
    
    // MARK: - Public
    
    func reload(){
        fetchExercises()
    }
}
