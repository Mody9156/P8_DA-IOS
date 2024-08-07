//
//  UserDataViewModelTests.swift
//  AristaTests
//
//  Created by KEITA on 07/08/2024.
//

import XCTest
@testable import Arista
import Combine
import CoreData


final class UserDataViewModelTests: XCTestCase {
    var cancellable = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_WhenUser_Is_Empty(){
        //Given
        let persistenceController = PersistenceController(inMemory: false)
        let viewModel = UserDataViewModel(context: persistenceController.container.viewContext)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let data = UserDataViewModel(context: persistenceController.container.viewContext)
        
        let expectation = XCTestExpectation(description: "fetch empty list of users")
    
        //Then
        viewModel.$firstName
            .sink { name in
                
            XCTAssert(name.isEmpty == true)
                
            expectation.fulfill()
            
        }.store(in: &cancellable)
        wait(for: [expectation], timeout: 10)
       
    }

    func test_WhenAddNew_User()  {
        //Given
        let persistenceController = PersistenceController(inMemory: false)
        let viewModel = UserDataViewModel(context: persistenceController.container.viewContext)
        emptyEntities(context: persistenceController.container.viewContext)
        addExercice(context: persistenceController.container.viewContext, userFirstName: "User_2", userLastName: "Magic")
        let data = UserDataViewModel(context: persistenceController.container.viewContext)
        
        let expectation = XCTestExpectation(description: "fetch empty list of users")
        
        //Then
        
        viewModel.$firstName
            .sink { name in
                
            XCTAssert(name.isEmpty == false)
            XCTAssert(name == "User_2")
                
                
            expectation.fulfill()
            
        }.store(in: &cancellable)
      
        
        wait(for: [expectation], timeout: 10)
        
        viewModel.$lastName
            .sink { name in
                
            XCTAssert(name.isEmpty == false)
            XCTAssert(name == "Magic")
                
                
            expectation.fulfill()
            
        }.store(in: &cancellable)
    }

    func testPerformanceExample() throws {
        
    }
    
    private func emptyEntities(context: NSManagedObjectContext) {

    let fetchRequest = User.fetchRequest()

    let objects = try! context.fetch(fetchRequest)

     

    for user in objects {

    context.delete(user)

    }

    try! context.save()

    }

    private func addExercice(context: NSManagedObjectContext, userFirstName: String, userLastName: String) {

    let newUser = User(context: context)

    newUser.firstName = userFirstName

    newUser.lastName = userLastName

    try! context.save()

     

    }
}
