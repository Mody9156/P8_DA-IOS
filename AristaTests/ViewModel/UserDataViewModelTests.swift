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
        
        // Then
        viewModel.$firstName.sink { name in
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
        
        // Then
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
    
    func test_fetchUserData_ShouldHandleError() {
        // Given
        let persistenceController = PersistenceController(inMemory: false)
        let mockRepository = MockUserRepository()
        mockRepository.user = nil // Simule l'absence d'utilisateur pour déclencher une erreur
        emptyEntities(context: persistenceController.container.viewContext)
        let viewModel = UserDataViewModel(context: persistenceController.container.viewContext, repository: mockRepository)
        
        // When
        viewModel.fetchUserData()
        
        // Then
        XCTAssertEqual(viewModel.firstName, "")
        XCTAssertEqual(viewModel.lastName, "")
        // Optionnel: Vérifier si l'état du ViewModel correspond aux attentes après l'erreur
    }
    
    
}


class MockUserRepository : DataRepositoryProtocol{
    var user : User?
    
    func getUser() throws -> User?{
        if let user = user {
            return user
        }else {
            throw UserDataViewModel.UserError.InvalidUser
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


