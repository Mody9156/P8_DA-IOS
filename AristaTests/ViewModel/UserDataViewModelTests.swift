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
    
    
    func test_WhenUser_Is_Empty() {
        // Given
        let persistenceController = PersistenceController(inMemory: false)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let mockRepository = MockUserRepository()
        mockRepository.user = nil // Simule l'absence d'utilisateur
        
        let viewModel = UserDataViewModel(context: persistenceController.container.viewContext, repository: mockRepository)
        
        let expectation = XCTestExpectation(description: "fetch empty list of users")
        
        // When & Then
        viewModel.$firstName.sink { name in
            XCTAssertTrue(name.isEmpty, "Expected firstName to be empty, but it was: \(name)")
            expectation.fulfill()
        }.store(in: &cancellable)
        
        viewModel.$lastName.sink { name in
            XCTAssertTrue(name.isEmpty, "Expected firstName to be empty, but it was: \(name)")
            expectation.fulfill()
        }.store(in: &cancellable)
        
        wait(for: [expectation], timeout: 10)
    }
    
    
    func test_WhenAddNew_User() {
        // Given
        let persistenceController = PersistenceController(inMemory: false)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let mockRepository = MockUserRepository()
        let newUser = User(context: persistenceController.container.viewContext)
        
        newUser.firstName = "User_2"
        newUser.lastName = "Magic"
        try! persistenceController.container.viewContext.save()
        mockRepository.user = newUser // Simule un nouvel utilisateur
        let viewModel = UserDataViewModel(context: persistenceController.container.viewContext, repository: mockRepository)
        
        let firstNameExpectation = XCTestExpectation(description: "fetch first name")
        let lastNameExpectation = XCTestExpectation(description: "fetch last name")
        
        //When & Then
        viewModel.$firstName.sink { name in
            XCTAssertEqual(name, "User_2")
            firstNameExpectation.fulfill()
        }.store(in: &cancellable)
        
        
        viewModel.$lastName.sink { name in
            XCTAssertEqual(name, "Magic")
            lastNameExpectation.fulfill()
        }.store(in: &cancellable)
        wait(for: [firstNameExpectation, lastNameExpectation], timeout: 5)
        
    }
    
    
    func testFetchUserData_when_UserIsNil() {
        // Given: Créer un mock de UserRepository qui retourne nil
        class MockUserRepository: DataRepositoryProtocol {
            func getUser() throws -> User? {
                return nil
            }
        }
        let persistenceController = PersistenceController(inMemory: false)
        let mockRepository = MockUserRepository()
        
        
        emptyEntities(context: persistenceController.container.viewContext)
        
        let viewModel = UserDataViewModel(context: persistenceController.container.viewContext, repository: mockRepository)
        // When
        viewModel.fetchUserData()
        
        // Then
        XCTAssertEqual(viewModel.firstName, "")
        XCTAssertEqual(viewModel.lastName, "")
    }
    
    func test_WhenUserFirstNameIsNotNil_FirstNameIsAssignedCorrectly(){
        //Given
        let persistenceController = PersistenceController(inMemory: false)
        
        emptyEntities(context: persistenceController.container.viewContext)
        let mockRepository = MockUserRepository()
        
        let viewModel = UserDataViewModel(context: persistenceController.container.viewContext, repository: mockRepository)
        
        let user = User(context: persistenceController.container.viewContext)
        
        user.firstName = ""
        mockRepository.user = user
        
        try? persistenceController.container.viewContext.save()
        
        //When
        viewModel.fetchUserData()
        
        //Then
        XCTAssertEqual(user.firstName, "")
        
    }
    
    func test_WhenUserFirstNameIsNotNil_LastNameIsAssignedCorrectly(){
        //Given
        let persistenceController = PersistenceController(inMemory: false)
        
        emptyEntities(context: persistenceController.container.viewContext)
        let mockRepository = MockUserRepository()
        
        let viewModel = UserDataViewModel(context: persistenceController.container.viewContext, repository: mockRepository)
        
        let user = User(context: persistenceController.container.viewContext)
        
        user.lastName = ""
        mockRepository.user = user
        
        try? persistenceController.container.viewContext.save()
        
        //When
        viewModel.fetchUserData()
        //Then
        
        XCTAssertEqual(user.lastName, "")
    }
}



enum MockUserRepositoryError : Error {
    case ThrowError
}

class MockUserRepository : DataRepositoryProtocol{
    var user : User?
    
    func getUser() throws -> User?{
        if let user = user {
            return user
        }else {
            throw MockUserRepositoryError.ThrowError
        }
    }
}

private func emptyEntities(context: NSManagedObjectContext) {
    
    let fetchRequest = User.fetchRequest()
    
    let objects = try! context.fetch(fetchRequest)
    
    
    
    for user in objects {
        
        context.delete(user)
        
    }
    
    try! context.save()
    
}


