//
//  ExerciseListViewModelTests.swift
//  AristaTests
//
//  Created by KEITA on 07/08/2024.
//

import XCTest
import CoreData
@testable import Arista
import Combine

final class ExerciseListViewModelTests: XCTestCase {
    
    var cancellable = Set<AnyCancellable>()
    
    
    func test_WhenNoExerciseIsInDatabase_FetchExercise_ReturnEmptyList()  {
        //Give
        let mocksExerciseViewModel  = MocksExerciseViewModel()
        
        let persistenceController = PersistenceController(inMemory: false)
        // Clean manually all data
        emptyEntities(context: persistenceController.container.viewContext)
        try? persistenceController.container.viewContext.save()
        let viewModel = ExerciseListViewModel(context: persistenceController.container.viewContext,repository: mocksExerciseViewModel)
        
        let expectation = XCTestExpectation(description: "fetch empty list of exercise")
        //When
        viewModel.$exercises.sink { exercises in
            //Then
            XCTAssert(exercises.isEmpty)
            expectation.fulfill()
            
        }.store(in: &cancellable)
        wait(for: [expectation], timeout: 10)
        
    }
    
    func test_WhenAddingOneExerciseInDatabase_FEtchExercise_ReturnAListContainingTheExercise()  {
        
        //Given
        let persistenceController  = PersistenceController(inMemory: false)
        // Clean manually all data
        emptyEntities(context: persistenceController.container.viewContext)
        let date = Date()
        
        let mocksExerciseViewModel  = MocksExerciseViewModel()
        
        let exercise = Exercise(context: persistenceController.container.viewContext)
        exercise.startDate =  date
        exercise.category = "Football"
        exercise.duration = 10
        exercise.intensity = 5
        try! persistenceController.container.viewContext.save()
        
        mocksExerciseViewModel.exercises.append(exercise)
        
        let viewModel = ExerciseListViewModel(context: persistenceController.container.viewContext,repository: mocksExerciseViewModel)
        
        let expectation = XCTestExpectation(description: "fetch empty list of exercise")
        
        //Then
        viewModel.$exercises
        
            .sink { exercises in
                
                XCTAssert(exercises.isEmpty == false)
                
                XCTAssert(exercises.first?.category == "Football")
                
                XCTAssert(exercises.first?.duration == 10)
                
                XCTAssert(exercises.first?.intensity == 5)
                
                XCTAssert(exercises.first?.startDate == date)
                
                expectation.fulfill()
                
            }.store(in: &cancellable)
        
        wait(for: [expectation], timeout: 10)
        
    }
    
    func test_WhenAddingMultipleExerciseInDatabase_FetchExercise_ReturnAListContainingTheExerciseInTheRightOrder() {
        // Given
        let persistenceController = PersistenceController(inMemory: false)
        let mocksExerciseViewModel = MocksExerciseViewModel()
        
        emptyEntities(context: persistenceController.container.viewContext)
        
        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))
        
        let exercise1 = Exercise(context: persistenceController.container.viewContext)
        exercise1.category = "Football"
        exercise1.intensity = 5
        exercise1.duration = 10
        exercise1.startDate = date1
        
        let exercise2 = Exercise(context: persistenceController.container.viewContext)
        exercise2.category = "Running"
        exercise2.intensity = 1
        exercise2.duration = 120
        exercise2.startDate = date3
        
        let exercise3 = Exercise(context: persistenceController.container.viewContext)
        exercise3.category = "Fitness"
        exercise3.intensity = 5
        exercise3.duration = 30
        exercise3.startDate = date2
        
        mocksExerciseViewModel.exercises.append(exercise1)
        mocksExerciseViewModel.exercises.append(exercise2)
        mocksExerciseViewModel.exercises.append(exercise3)
        
        try? persistenceController.container.viewContext.save()
        
        let viewModel = ExerciseListViewModel(context: persistenceController.container.viewContext, repository: mocksExerciseViewModel)
        
        let expectation = XCTestExpectation(description: "fetch list of exercises in the correct order")
        
        // When
        viewModel.$exercises
            .sink { exercises in
                // Then
                XCTAssertEqual(exercises.count, 3)
                XCTAssertEqual(exercises[0].category, "Football")
                XCTAssertEqual(exercises[2].category, "Fitness")
                XCTAssertEqual(exercises[1].category, "Running")
                
                expectation.fulfill()
            }
            .store(in: &cancellable)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_When_reload_if_not_empty(){
        // Given
        let persistenceController = PersistenceController(inMemory: false)
        let mocksExerciseViewModel = MocksExerciseViewModel()
        
        emptyEntities(context: persistenceController.container.viewContext)
        
        let viewModel = ExerciseListViewModel(context: persistenceController.container.viewContext,repository: mocksExerciseViewModel)
        
        //When
        let reload = viewModel.reload()
        
        //Then
        XCTAssertNotNil(reload)
        
    }
    
    func test_When_fetchExercises_throws_Error() {
        // Given
        let persistenceController = PersistenceController(inMemory: false)
        let mocksExerciseViewModel = MocksExerciseViewModel()
        
        // Configurez le mock pour lancer une erreur
        mocksExerciseViewModel.throwsError = true
        
        let viewModel = ExerciseListViewModel(context: persistenceController.container.viewContext, repository: mocksExerciseViewModel)
        
        // When
        let result = try? viewModel.fetchExercises()
        
        // Then
        XCTAssertThrowsError(result, "fetchExercises() devrait retourner false lorsque getExercise() lance une erreur.")
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

class MocksExerciseViewModel : DataExerciseProtocol {
    var exercises : [Exercise] = []
    var throwsError : Bool = false
    
    
    func getExercise() throws -> [Exercise] {
        if throwsError{
            throw NSError(domain: "TestErrorDomain", code: 1, userInfo: nil)
        }else{
            return exercises
        }
        
    }
    
    func addExercise(category: String, duration: Int, intensity: Int, startDate: Date) throws {
        if throwsError{
            throw NSError(domain: "TestErrorDomain", code: 1, userInfo: nil)
        }else{
            let newExercise = Exercise()
            newExercise.category = category
            newExercise.duration = Int64(duration)
            newExercise.intensity = Int64(intensity)
            newExercise.startDate = startDate
            exercises.append(newExercise)
        }
    }
    
}
