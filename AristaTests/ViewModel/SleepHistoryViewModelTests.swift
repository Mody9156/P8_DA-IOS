//
//  SleepHistoryViewModelTests.swift
//  AristaTests
//
//  Created by KEITA on 07/08/2024.
//

import XCTest
@testable import Arista
import Combine
import CoreData

final class SleepHistoryViewModelTests: XCTestCase {
    var cancellable = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        
    }

    func test_WhenSleep_Is_Empty() throws {
        //Give
        let persistenceController = PersistenceController(inMemory: false)
        emptyEntities(context: persistenceController.container.viewContext)
        let mocksSleepRepository = MocksSleepRepository()
        mocksSleepRepository.sleep = []
        
        let viewModel = SleepHistoryViewModel(context: persistenceController.container.viewContext,repository: mocksSleepRepository)
        
        
        let expectation = XCTestExpectation(description: "fetch empty list of users")
        
        //When
        // Then
        viewModel.$sleepSessions.sink { sleep in
            XCTAssertEqual(sleep.isEmpty, true)
            expectation.fulfill()
        }.store(in: &cancellable)
        
        wait(for: [expectation], timeout: 10)
    }
        
        //Then
        
   
    func test_AddingSleepSession_IncreasesCount() {
        // Given
        let persistenceController = PersistenceController(inMemory: false)
        emptyEntities(context: persistenceController.container.viewContext)
        let date = Date()
        let mocksSleepRepository = MocksSleepRepository()
        let initialCount = mocksSleepRepository.sleep.count
        
        let viewModel = SleepHistoryViewModel(context: persistenceController.container.viewContext,repository: mocksSleepRepository)
        
        let newSleep =  Sleep(context: persistenceController.container.viewContext)
        newSleep.duration = 480
        newSleep.startDate = date
        newSleep.quality = 8
        try! persistenceController.container.viewContext.save()
        mocksSleepRepository.sleep.append(newSleep)
        
        let expectation = XCTestExpectation(description: "fetch first sleep")
       
        // Then
        XCTAssertEqual(mocksSleepRepository.sleep.count, initialCount + 1)
        XCTAssertEqual(mocksSleepRepository.sleep.last?.duration, 480)
        XCTAssertEqual(mocksSleepRepository.sleep.last?.quality, 8)
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


class MocksSleepRepository: DataSleepProtocol {
    var sleep: [Sleep] = []

    func getSleepSessions() throws -> [Sleep] {
            return sleep
       
      
    }
    
    func addSleepSessions(duration: Int, quality: Int, startDate: Date) throws {

        let newSleepSession = Sleep()
        newSleepSession.duration = Int64(duration)
        newSleepSession.quality = Int64(quality)
        newSleepSession.startDate = startDate
        
        sleep.append(newSleepSession)
    }
}
