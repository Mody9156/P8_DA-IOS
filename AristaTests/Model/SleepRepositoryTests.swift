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

    

    private  func emptyEntities(context:NSManagedObjectContext)  {
        let fetch = Sleep.fetchRequest()
        let objects = try! context.fetch(fetch)
       
        for sleep in objects {
            context.delete(sleep)
        }
    }
    
    

}
