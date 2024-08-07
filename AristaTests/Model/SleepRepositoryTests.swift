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

    var persistenceController : PersistenceController!
    var sleepRepository : SleepRepository!
    var context : NSManagedObjectContext!
    
    override func setUp()  {
        super.setUp()
        persistenceController = PersistenceController()
        context = persistenceController.container.viewContext
        sleepRepository = SleepRepository(viewContext: context)
    }
    
    override func tearDown() {
        super.tearDown()
        persistenceController = nil
        context = nil
        sleepRepository = nil
    }
    

    private func EmptyEntities(context:NSManagedObjectContext)  {
        let fetch = Sleep.fetchRequest()
        let objects = try! context.fetch(fetch)
       
        for sleep in objects {
            context.delete(sleep)
        }
    }
    
    private func addNew_ElementsForSleep(context:NSManagedObjectContext,duration:Int,quality:Int,startDate : Date){
        
        let newSleep = Sleep(context: context)
        newSleep.duration = Int64(duration)
        newSleep.startDate = startDate
        newSleep.quality = Int64(quality)
        try! context.save()
        
    }
    
    
    func testSleepSessionsIsEmpty(){
        //Give
        EmptyEntities(context: persistenceController.container.viewContext)
        let data = SleepRepository(viewContext: context)
        
        //When
        let request = try! data.getSleepSessions()

        //Then
        XCTAssert(request.isEmpty == true)
    }
    
    func testgetSleepSessions(){
        //Give
        let persistence = PersistenceController(inMemory: false)
        let context : NSManagedObjectContext!
        context = persistence.container.viewContext
        EmptyEntities(context: context)
        let date = Date()
        addNew_ElementsForSleep(context: context, duration: 22, quality: 33, startDate: date)
        let data = SleepRepository(viewContext: context)
        
        //When
        let request_Sleep = try! data.getSleepSessions()
                
        //Then
        
        XCTAssert(request_Sleep.isEmpty == false)
        XCTAssert(request_Sleep.first?.duration == 22)
        XCTAssert(request_Sleep.first?.quality == 33)
        XCTAssert(request_Sleep.first?.startDate == date)
        
    }

}
