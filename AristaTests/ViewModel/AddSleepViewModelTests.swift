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


    func testAddNewESleep() {
        
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
            throw  throw NSError(domain: "TestErrorDomain", code: 1, userInfo: nil)
        }
    }
    
}
