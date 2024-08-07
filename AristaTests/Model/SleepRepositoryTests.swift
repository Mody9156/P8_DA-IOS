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
    

    private func emptyEntities(context:NSManagedObjectContext)  {
        let fetch = Sleep.fetchRequest()
        let objects = try! context.fetch(fetch)
       
        for sleep in objects {
            context.delete(sleep)
        }
    }
    
    func testSleepSessionsIsEmpty(){
        //Give
        
        //When
        emptyEntities(context: persistenceController.container.viewContext)
        let data = SleepRepository(viewContext: context)
        
        let request = try! sleepRepository.getSleepSessions()

        //Then
        
        XCTAssert(request.isEmpty == true)
    }
    
    func testgetSleepSessions(){
        //Give
        
        //When
        let request = try! sleepRepository.getSleepSessions()
                
        //Then
        
        XCTAssert(request.isEmpty == false)
        
    }

}
