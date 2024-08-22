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
    
    
    func test_WhenSleep_is_Empty() throws {
        //Give
        let persistenceController = PersistenceController(inMemory: false)
        emptyEntities(context: persistenceController.container.viewContext)
        let mocksSleepRepository = MocksSleepRepository(viewContext: persistenceController.container.viewContext)
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
        mocksSleepRepository.sleep.append(newSleep)
        try! persistenceController.container.viewContext.save()

        
        // Then
        XCTAssertEqual(mocksSleepRepository.sleep.count, initialCount + 1)
        XCTAssertEqual(mocksSleepRepository.sleep.last?.duration, 480)
        XCTAssertEqual(mocksSleepRepository.sleep.last?.quality, 8)
    }
    
    func test_When_reload_throwError()  {
        //Given
        let persistenceController = PersistenceController(inMemory: false)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let mocksSleepRepository_ThrowsError = MocksSleepRepository_ThrowsError()
        
        let viewModel = SleepHistoryViewModel(context: persistenceController.container.viewContext,repository: mocksSleepRepository_ThrowsError)

        let data = SleepRepository(viewContext: persistenceController.container.viewContext)
        
        viewModel.sleepSessions = try! data.getSleepSessions()
        
        var repository = SleepRepository(viewContext: persistenceController.container.viewContext)
        
        try! persistenceController.container.viewContext.save()
        mocksSleepRepository_ThrowsError.shouldThrowError = true
        
        //When & Then
        let result =  try? viewModel.fetchSleepSessions()
       
        XCTAssertThrowsError(result)
 
    }
    
    func test_When_reload_isNoEmpty(){
        //Given
        let persistenceController = PersistenceController(inMemory: false)
        let mocksSleepRepository = MocksSleepRepository(viewContext: PersistenceController.shared.container.viewContext)
        let viewModel = SleepHistoryViewModel(context: persistenceController.container.viewContext,repository: mocksSleepRepository)
        mocksSleepRepository.throwError = true
        //When && Then
        let reload: ()? = try? viewModel.reload()
     
        XCTAssertNotNil(reload)
        XCTAssertThrowsError(try viewModel.fetchSleepSessions()){error in
            XCTAssertEqual(error as? SleepHistoryViewModel.FetchSleepSessionsError, .fetchFailed)
        }

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
        throw NSError(domain: "TestErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Ceci est une erreur de test."])

    }
    
    func addSleepSessions(duration: Int, quality: Int, startDate: Date) throws {
        
    }
}

