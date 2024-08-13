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
        
        let data = ExerciseRepository(viewContext: viewContext)
        exercises = try! data.getExercise()
    }
    
    private func deleteExercise(at offsets : IndexSet){
        let data = ExerciseRepository(viewContext: viewContext)
        for index in offsets {
            let exercise = exercises[index]
            do {
                try data.deleteExercise(exercise)
            }catch{
                print("Erreur lors de la suppression de l'exercice: \(error)")
            }
        }
    }
    
   
    
    // MARK: - Public
    
    func reload(){
        fetchExercises()
    }
}
