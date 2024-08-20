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
    
    
    
    func test_WhenSleep_Is_Empty() throws {
        //Give
        let persistenceController = PersistenceController(inMemory: false)
        emptyEntities(context: persistenceController.container.viewContext)
        let mocksSleepRepository = MocksSleepRepository(viewContext: PersistenceController.shared.container.viewContext)
        mocksSleepRepository.sleep = []
        
        let viewModel = SleepHistoryViewModel(context: persistenceController.container.viewContext,repository: mocksSleepRepository)
        
        
        let expectation = XCTestExpectation(description: "fetch empty list of users")
        
        
        //When & Then
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
        let mocksSleepRepository = MocksSleepRepository(viewContext: PersistenceController.shared.container.viewContext)
        let initialCount = mocksSleepRepository.sleep.count
        
        
        let newSleep =  Sleep(context: persistenceController.container.viewContext)
        newSleep.duration = 480
        newSleep.startDate = date
        newSleep.quality = 8
        try! persistenceController.container.viewContext.save()
        mocksSleepRepository.sleep.append(newSleep)
        
        
        // Then
        XCTAssertEqual(mocksSleepRepository.sleep.count, initialCount + 1)
        XCTAssertEqual(mocksSleepRepository.sleep.last?.duration, 480)
        XCTAssertEqual(mocksSleepRepository.sleep.last?.quality, 8)
    }
    
    func test_When_reload_throwError()  {
        //Given
        let persistenceController = PersistenceController(inMemory: false)
        let mocksSleepRepository_ThrowsError = MocksSleepRepository(viewContext: PersistenceController.shared.container.viewContext)
        emptyEntities(context: persistenceController.container.viewContext)
      
        mocksSleepRepository_ThrowsError.throwError = false
       
        let viewModel = SleepHistoryViewModel(context: persistenceController.container.viewContext,repository: mocksSleepRepository_ThrowsError)
        
        //When
        let result = viewModel.fetchSleepSessions()
        
        //Then
        XCTAssertFalse(result)
       
        
    }
    
    func test_When_reload_isNoEmpty(){
        //Given
        let persistenceController = PersistenceController(inMemory: false)
        let mocksSleepRepository = MocksSleepRepository(viewContext: PersistenceController.shared.container.viewContext)
        let viewModel = SleepHistoryViewModel(context: persistenceController.container.viewContext,repository: mocksSleepRepository)
        
        //When
        let reload = try? viewModel.reload()
        let error = viewModel.fetchSleepSessions()
        //Then
        XCTAssertNotNil(reload)
        XCTAssertTrue(error)

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
    var throwError : Bool = false
    let viewContext: NSManagedObjectContext
      
      init(viewContext: NSManagedObjectContext) {
          self.viewContext = viewContext
      }
    
    func getSleepSessions() throws -> [Sleep] {
        if throwError{
            throw NSError(domain: "TestErrorDomain", code: 1, userInfo: nil)
        }
        return sleep
    }
    
    func addSleepSessions(duration: Int, quality: Int, startDate: Date) throws {
        if throwError{
            throw NSError(domain: "TestErrorDomain", code: 1, userInfo: nil)
        }
        let newSleepSession = Sleep(context: viewContext)
        newSleepSession.duration = Int64(duration)
        newSleepSession.quality = Int64(quality)
        newSleepSession.startDate = startDate
        
        sleep.append(newSleepSession)
        
    }
}

class MocksSleepRepository_ThrowsError: DataSleepProtocol {
    var shouldThrowError : Bool = false
    
    func getSleepSessions() throws -> [Sleep] {
        if shouldThrowError {
            throw NSError(domain: "TestErrorDomain", code: 1, userInfo: nil)
        }
        return []
    }
    
    func addSleepSessions(duration: Int, quality: Int, startDate: Date) throws {
        
        
    }
}

