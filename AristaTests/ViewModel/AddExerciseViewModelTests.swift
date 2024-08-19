//
//  AddExerciseViewModelTests.swift
//  AristaTests
//
//  Created by KEITA on 07/08/2024.
//

import XCTest
@testable import Arista
import Combine
import CoreData

final class AddExerciseViewModelTests: XCTestCase {
    var cancellable = Set<AnyCancellable>()


    func testAddNewExercise()  {
        
        //Given
        let persistence = PersistenceController(inMemory: false)
        let date = Date()
        emptyEntities(context: persistence.container.viewContext)
        let mockExerciseViewModel = MockExerciseViewModel()
        
        
        let newExercise = Exercise(context: persistence.container.viewContext)
        
        newExercise.category = "Running"
        newExercise.intensity = 5
        newExercise.startDate = date
        newExercise.duration = 22
        newExercise.user?.firstName = "Mike"
        newExercise.user?.lastName = "Magic"
        
        mockExerciseViewModel.exercises.append(newExercise)
        
        try? persistence.container.viewContext.save()
        //ici
        let viewModel = AddExerciseViewModel(context: persistence.container.viewContext,repository: mockExerciseViewModel)
        
        let expectation = expectation(description: "fetch empty list of exercise")
        
        //Then
        
//        viewModel.$category
//        .sink { category in
//            XCTAssert(category.isEmpty == false)
//            XCTAssert(category == "Yoga")
//            expectation.fulfill()
//        }.store(in: &cancellable)
//
//        wait(for: [expectation], timeout: 11)
//
//
        viewModel.addExercise()
        
        XCTAssertNoThrow(viewModel)
    }

   

    private func emptyEntities(context: NSManagedObjectContext) {

    let fetchRequest = Exercise.fetchRequest()

    let objects = try! context.fetch(fetchRequest)

     

    for exercice in objects {

    context.delete(exercice)

    }

    try! context.save()

    }

}
class MockExerciseViewModel : DataExerciseProtocol {
    var exercises : [Exercise] = []
    var category: String = ""
    var duration: Int64 = 0
    var intensity: Int64 = 0
    var startDate: Date?
        

    func getExercise() throws -> [Exercise] {
        return exercises

    }
    
    func addExercise(category: String, duration: Int, intensity: Int, startDate: Date) throws {
     
                let newExercise = Exercise()
                newExercise.category = category
                newExercise.duration = Int64(duration)
                newExercise.intensity = Int64(intensity)
                newExercise.startDate = startDate
                exercises.append(newExercise)
       
    }
    
    
}
