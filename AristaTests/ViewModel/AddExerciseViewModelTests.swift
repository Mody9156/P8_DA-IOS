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
        
        let viewModel = AddExerciseViewModel(context: persistence.container.viewContext,repository: mockExerciseViewModel)
        
        viewModel.category = "Running"
        viewModel.intensity = 5
        viewModel.duration = 22
        viewModel.startTime = date
        
        let newExercise = Exercise(context: persistence.container.viewContext)

        newExercise.startDate = viewModel.startTime
        newExercise.category =  viewModel.category
        newExercise.duration =  Int64(viewModel.duration)
        newExercise.intensity =  Int64(viewModel.intensity)
        mockExerciseViewModel.exercises.append(newExercise)

        try? persistence.container.viewContext.save()
        
      //When
        let succes = viewModel.addExercise()
        //Then
        XCTAssertTrue(succes)
        XCTAssertEqual(mockExerciseViewModel.exercises.count, 1)
        
        let addNewExercise = mockExerciseViewModel.exercises.first
        XCTAssertEqual(addNewExercise?.category, "Running")
        XCTAssertEqual(addNewExercise?.intensity, 5)
        XCTAssertEqual(addNewExercise?.duration, 22)
        XCTAssertEqual(addNewExercise?.startDate, date)
        
      
    }
 
    func test_AddNewExerciseFailure(){
        //Given
        let persistence = PersistenceController(inMemory: false)
        let date = Date()
        emptyEntities(context: persistence.container.viewContext)
        let mockExerciseViewModel = MockExerciseViewModel()
        
        let viewModel = AddExerciseViewModel(context: persistence.container.viewContext,repository: mockExerciseViewModel)
        
        let newExercise = Exercise(context: persistence.container.viewContext)
      
        
        mockExerciseViewModel.shouldFail = true
        
        //When
        let success = viewModel.addExercise()
        
        //Then
        XCTAssertFalse(success)
         XCTAssertEqual(mockExerciseViewModel.exercises.count, 0)
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
    var shouldFail : Bool = false
        

    func getExercise() throws -> [Exercise] {
        return exercises

    }
    
    func addExercise(category: String, duration: Int, intensity: Int, startDate: Date) throws {
        
        if shouldFail {
                    throw NSError(domain: "TestErrorDomain", code: 1, userInfo: nil)
                }
        
                let newExercise = Exercise()
                newExercise.category = category
                newExercise.duration = Int64(duration)
                newExercise.intensity = Int64(intensity)
                newExercise.startDate = startDate
                exercises.append(newExercise)
       
    }
    
    
}
