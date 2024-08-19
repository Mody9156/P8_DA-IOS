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
        let mocksDataSleepProtocol = MocksDataSleepProtocol()
        
        let viewModel = AddSleepViewModel(context: persistence.container.viewContext,repository: mocksDataSleepProtocol)
        
        viewModel.quality = 5
        viewModel.duration = 22
        viewModel.startTime = date
        
        let newSleep = Sleep(context: persistence.container.viewContext)

        newSleep.startDate = viewModel.startTime
        newSleep.duration =  Int64(viewModel.duration)
        newSleep.quality =  Int64(viewModel.quality)
        mocksDataSleepProtocol.sleep.append(newSleep)

        try? persistence.container.viewContext.save()
        
      //When
        let succes = viewModel.addSleepSessions()
        //Then
        XCTAssertTrue(succes)
        XCTAssertEqual(mocksDataSleepProtocol.sleep.count, 1)
        
        let addNewExercise = mocksDataSleepProtocol.sleep.first
        XCTAssertEqual(addNewExercise?.quality, 5)
        XCTAssertEqual(addNewExercise?.duration, 22)
        XCTAssertEqual(addNewExercise?.startDate, date)
        
      
    }

    func testAddNewSleep_ThrowError()  {
        //Given
        let date = Date()

        let persistence = PersistenceController(inMemory: false)
        emptyEntities(context: persistence.container.viewContext)
        let mocksDataSleepProtocol = MocksDataSleepProtocol()
        
        let viewModel = AddSleepViewModel(context: persistence.container.viewContext,repository: mocksDataSleepProtocol)

        let newSleep = Sleep(context: persistence.container.viewContext)

        mocksDataSleepProtocol.sleep.append(newSleep)

        try? persistence.container.viewContext.save()
        
        mocksDataSleepProtocol.shouldFail = true
        
      //When
        let succes = viewModel.addSleepSessions()
        //Then
        XCTAssertFalse(succes)
    }
    
   
}

private func emptyEntities(context: NSManagedObjectContext) {

let fetchRequest = Sleep.fetchRequest()

let objects = try! context.fetch(fetchRequest)

 

for sleep in objects {

context.delete(sleep)

}

try! context.save()

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
