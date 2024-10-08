//
//  SleepRepositoryTests.swift
//  AristaTests
//
//  Created by KEITA on 06/08/2024.
//

import XCTest
@testable import Arista
import CoreData

final class SleepRepositoryTests: XCTestCase {
    
    override func setUp()  {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
        
    }
    
    private func EmptyEntities(context:NSManagedObjectContext)  {
        let fetch = Sleep.fetchRequest()
        let objects = try! context.fetch(fetch)
        
        for sleep in objects {
            context.delete(sleep)
        }
    }
    
    
    func test_WhenSleepSessionsIsEmpty(){
        //Give
        let persistenceController = PersistenceController(inMemory: false)
        let context: NSManagedObjectContext
        context  = persistenceController.container.viewContext
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = Sleep.fetchRequest()
        XCTAssertNoThrow(fetchRequest)
        let deleteFetchRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do{
            try context.execute(deleteFetchRequest)
        }catch{
            XCTFail("Failed to clear context: \(error)")
        }
        let data = SleepRepository(viewContext: persistenceController.container.viewContext)
        
        //When
        let request = try! data.getSleepSessions()
        
        //Then
        XCTAssert(request.isEmpty == true)
    }
    
    func test_When_useSleepSessions(){
        //Give
        let persistence = PersistenceController(inMemory: false)
        let context = persistence.container.viewContext
        EmptyEntities(context: context)
        
        let date = Date()
        let newSleep = Sleep(context: context)
        newSleep.duration = 22
        newSleep.quality = 33
        newSleep.startDate = date
        
        try? context.save()
        
        let data = SleepRepository(viewContext: context)
        
        //When
        let request_Sleep = try! data.getSleepSessions()
        
        //Then
        
        XCTAssert(request_Sleep.isEmpty == false)
        XCTAssert(request_Sleep.first?.duration == 22)
        XCTAssert(request_Sleep.first?.quality == 33)
        XCTAssert(request_Sleep.first?.startDate == date)
        
    }
    
    func test_addSleepSessions_withMock() {
        //Give
        let date = Date()
        let persistence = PersistenceController(inMemory: false)
        let context = persistence.container.viewContext
        EmptyEntities(context: context)
        
        let viewModel = SleepRepository(viewContext: context)
        
        // When
        try? viewModel.addSleepSessions(duration: 34, quality: 3, startDate: date)
        
        let fetchRequest : NSFetchRequest<Sleep> = Sleep.fetchRequest()
        
        do{
            let sleep = try context.fetch(fetchRequest)
            // Then
            XCTAssertEqual(sleep.count == 1, true)
            XCTAssert(sleep.isEmpty == false)
            XCTAssertEqual(sleep.first?.quality, 3)
            XCTAssertEqual(sleep.first?.startDate, date)
            XCTAssertEqual(sleep.first?.duration, 34)
        }catch{
            XCTFail("Failed to clear context: \(error)")
        }
        
    }
    
  
}
