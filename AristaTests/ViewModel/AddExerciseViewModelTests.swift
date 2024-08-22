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
    
    
    func testAdd_whenAdding_NewExercise()  {
        
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
        
      
        //Then
        let result = viewModel.addExercise()
        XCTAssertNoThrow(result)
        XCTAssertEqual(mockExerciseViewModel.exercises.count, 1)
        
        let addNewExercise = mockExerciseViewModel.exercises.first
        XCTAssertEqual(addNewExercise?.category, "Running")
        XCTAssertEqual(addNewExercise?.intensity, 5)
        XCTAssertEqual(addNewExercise?.duration, 22)
        XCTAssertEqual(addNewExercise?.startDate, date)
        
        
    }
    
    func testAdd_whenAdding_throwsError_NewExercise()  {
        
        //Given
        let persistence = PersistenceController(inMemory: false)
        let date = Date()
        emptyEntities(context: persistence.container.viewContext)
        let mockExerciseViewModel = MockExerciseViewModel()
        
        let viewModel = AddExerciseViewModel(context: persistence.container.viewContext,repository: mockExerciseViewModel)
        
//        viewModel.category = "Yoga"
//        viewModel.intensity = 5
//        viewModel.duration = 22
//        viewModel.startTime = date
//        
//        let newExercise = Exercise(context: persistence.container.viewContext)
//        
//        newExercise.startDate = viewModel.startTime
//        newExercise.category =  viewModel.category
//        newExercise.duration =  Int64(viewModel.duration)
//        newExercise.intensity =  Int64(viewModel.intensity)
//        mockExerciseViewModel.exercises.append(newExercise)
//        
//        try? persistence.container.viewContext.save()
        viewModel.intensity = 5
        viewModel.duration = 0
        viewModel.category = ""
        viewModel.startTime = date
        
        
        try? mockExerciseViewModel.addExercise(category: "Yoga"
, duration: 0, intensity: 5, startDate: date)
        //Then
            
        XCTAssertThrowsError(viewModel.addExercise()){ error in
            XCTAssertEqual(error as? AddExerciseViewModel.AddExerciseError, .addExerciseFailure)
            
        }
        
    }
    func test_When_whenElementIsNoEmpty(){
        //Given
        let persistence = PersistenceController(inMemory: false)
        emptyEntities(context: persistence.container.viewContext)
        let mockExerciseRepository = MockExerciseViewModel()
        
        let viewModel = AddExerciseViewModel(context: persistence.container.viewContext,repository: mockExerciseRepository)
        let date = Date()
        let newExercise = Exercise(context: persistence.container.viewContext)
        newExercise.intensity = 0
        newExercise.startDate = date
        newExercise.category = "Yoga"
        mockExerciseRepository.exercises.append(newExercise)
      
        mockExerciseRepository.shouldFail = false
        
        try? persistence.container.viewContext.save()
        
        //When
        
        let result = viewModel.whenElementIsEmpty()
        XCTAssert(viewModel.errorMessage.isEmpty == false)
      
    }
    func testWhenElementIsEmptyWithEmptyCategory() {
        //Given
        let persistence = PersistenceController(inMemory: false)
        emptyEntities(context: persistence.container.viewContext)
        let date = Date()
        let mockExerciseRepository = MockExerciseViewModel()
        
        let newExercise = Exercise(context: persistence.container.viewContext)
        newExercise.intensity = 5
        newExercise.startDate = date
        mockExerciseRepository.exercises.append(newExercise)
       
        
        let viewModel = AddExerciseViewModel(context: persistence.container.viewContext,repository: mockExerciseRepository)
        viewModel.intensity = 5
        viewModel.duration = 0
        viewModel.category = ""
        viewModel.startTime = date
        
           // Attendez-vous à ce que whenElementIsEmpty retourne true
           XCTAssertTrue(viewModel.whenElementIsEmpty())
        XCTAssertEqual(viewModel.category, "")
           
           // Vérifiez que le message d'erreur est correct
        XCTAssertEqual(viewModel.errorMessage, "Erreur : Tous les champs doivent être remplis correctement.")

       }
    
    func testWhenElementIsEmptyWithZeroDuration() {
        //Given
        let persistence = PersistenceController(inMemory: false)
        emptyEntities(context: persistence.container.viewContext)
        let date = Date()
        let mockExerciseRepository = MockExerciseViewModel()
        
        let newExercise = Exercise(context: persistence.container.viewContext)
                newExercise.intensity = 5
                newExercise.category = "Yoga"
                newExercise.startDate = date
                newExercise.duration = 5
                
                // Configuration de l'utilisateur associé
                let user = User(context: persistence.container.viewContext)
                user.firstName = "Mick"
                user.lastName = "Jack"
                newExercise.user = user
        mockExerciseRepository.exercises.append(newExercise)

        try? persistence.container.viewContext.save()
        
        let viewModel = AddExerciseViewModel(context: persistence.container.viewContext,repository: mockExerciseRepository)
        
        viewModel.intensity = 5
        viewModel.duration = 0
        viewModel.category = "Yoga"
        viewModel.startTime = date
        
            // Attendez-vous à ce que whenElementIsEmpty retourne true
            XCTAssertTrue(viewModel.whenElementIsEmpty())
        XCTAssertEqual(viewModel.duration <= 0 , true)
        XCTAssertEqual(viewModel.intensity == 5 , true)
            // Vérifiez que le message d'erreur est correct
            XCTAssertEqual(viewModel.errorMessage, "Erreur : Tous les champs doivent être remplis correctement.")
        }
    
    func testWhenElementIsEmptyWithValidInputs() {
        //Given
        let persistence = PersistenceController(inMemory: false)
        let date = Date()
        let mockExerciseRepository = MockExerciseViewModel()
        
        let newExercise = Exercise(context: persistence.container.viewContext)
                newExercise.intensity = 5
                newExercise.category = "Yoga"
                newExercise.startDate = date
                newExercise.duration = 5
                
                // Configuration de l'utilisateur associé
                let user = User(context: persistence.container.viewContext)
                user.firstName = "Mick"
                user.lastName = "Jack"
                newExercise.user = user
        mockExerciseRepository.exercises.append(newExercise)

        try? persistence.container.viewContext.save()
        
        let viewModel = AddExerciseViewModel(context: persistence.container.viewContext,repository: mockExerciseRepository)
        
        viewModel.intensity = 5
        viewModel.duration = 5
        viewModel.category = "Yoga"
        viewModel.startTime = date
        
        try? persistence.container.viewContext.save()

            XCTAssertFalse(viewModel.whenElementIsEmpty())
            
            XCTAssertEqual(viewModel.errorMessage, "")
        }
    
    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest = Exercise.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        for exercise in objects {
            context.delete(exercise)
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
        }else {
            let newExercise = Exercise()
            newExercise.category = category
            newExercise.duration = Int64(duration)
            newExercise.intensity = Int64(intensity)
            newExercise.startDate = startDate
            exercises.append(newExercise)
        }
        
    }
    
}


