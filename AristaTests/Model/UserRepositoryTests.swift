//
//  UserRepositoryTests.swift
//  AristaTests
//
//  Created by KEITA on 07/08/2024.
//

import XCTest
@testable import Arista
import CoreData

final class UserRepositoryTests: XCTestCase {
    
    
    
    private func emptyEntities(context:NSManagedObjectContext){
        let fetchRequest = User.fetchRequest()
        let object  = try!  context.fetch(fetchRequest)
        
        for user in object {
            context.delete(user)
        }
    }
    
    
    
    func test_WhenAddNewUser() throws {
        //Give
        let persistenceController = PersistenceController(inMemory: false)
        let context : NSManagedObjectContext!
        context = persistenceController.container.viewContext
        emptyEntities(context: context)
        let newUser = User(context: context)
        let mockViewContext = MockViewContext(user: newUser)
        newUser.firstName = "User_2"
        newUser.lastName = "Nelson"
        let user = UserRepository(viewContext: context)
        
        //When
        let request =  try! user.getUser()
        
        //Then
        
        XCTAssert(request?.firstName == "User_2")
        XCTAssert(request?.lastName == "Nelson")
        XCTAssert((request != nil))
    }
    
    func test_WhenUserIsEmpty() throws {
        //Give
        let persistenceController = PersistenceController(inMemory: false)
        let context : NSManagedObjectContext!
        context = persistenceController.container.viewContext
        emptyEntities(context: context)
        let users = UserRepository(viewContext: context)
        
        //When
        let User_request = try! users.getUser()
        
        //Then
        XCTAssert(User_request?.firstName?.isEmpty == nil)
        XCTAssert(User_request?.lastName?.isEmpty == nil)
        
    }
    
}


// Mocking du contexte de vue
class MockViewContext: DataRepositoryProtocol {
    let user: User?
    
    init(user: User?) {
        self.user = user
    }
    
    func getUser() throws -> User? {
        return user
    }
}

