//
//  AddSleepViewModelTests.swift
//  AristaTests
//
//  Created by KEITA on 19/08/2024.
//

import XCTest
@testable import Arista
import Combine
import CoreData

final class AddSleepViewModelTests: XCTestCase {


    func testAddNewSleep()  {
        
        //Given
        let persistence = PersistenceController(inMemory: false)
        let date = Date()
        emptyEntities(context: persistence.container.viewContext)
        let mockExerciseViewModel = MocksDataSleepProtocol()
        
        let viewModel = AddSleepViewModel(context: persistence.container.viewContext,repository: mockExerciseViewModel)
        
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

    private func emptyEntities(context: NSManagedObjectContext) {

    let fetchRequest = Sleep.fetchRequest()

    let objects = try! context.fetch(fetchRequest)

     

    for sleep in objects {

    context.delete(sleep)

    }

    try! context.save()

    }
}


class MocksDataSleepProtocol : DataSleepProtocol {
    var sleep : [Sleep] = []
    var shouldFail : Bool = false
        

    func getSleepSessions() throws -> [Sleep] {
        return sleep
    }
    
    func addSleepSessions(duration: Int, quality: Int, startDate: Date) throws {
        if shouldFail{
            throw NSError(domain: "TestErrorDomain", code: 1, userInfo: nil)
        }
        
        
        let newSleep = Sleep()
        newSleep.duration = Int64(duration)
        newSleep.quality = Int64(quality)
        newSleep.startDate = startDate
        sleep.append(newSleep)
    }
    
}
