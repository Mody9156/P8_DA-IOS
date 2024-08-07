//
//  AddExerciseViewModelTests.swift
//  AristaTests
//
//  Created by KEITA on 07/08/2024.
//

import XCTest
@testable import Arista
import Combine
import CoreData

final class AddExerciseViewModelTests: XCTestCase {
    var cancellable = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddNewExercise() throws {
        
        //Given
        let persistence = PersistenceController(inMemory: false)
        let date = Date()
        emptyEntities(context: persistence.container.viewContext)
        addExercice(context:  persistence.container.viewContext, category: "Running", duration: 10, intensity: 5, startDate: date, userFirstName: "Han", userLastName: "Solo")
        
        let viewModel = AddExerciseViewModel(context: persistence.container.viewContext)
        
        let expectation = expectation(description: "fetch empty list of exercise")
        
        //Then
        viewModel.$category.sink { category in
            <#code#>
        }
        
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    private func emptyEntities(context: NSManagedObjectContext) {

    let fetchRequest = Exercise.fetchRequest()

    let objects = try! context.fetch(fetchRequest)

     

    for exercice in objects {

    context.delete(exercice)

    }

    try! context.save()

    }

    private func addExercice(context: NSManagedObjectContext, category: String, duration: Int, intensity: Int, startDate: Date, userFirstName: String, userLastName: String) {

    let newUser = User(context: context)

    newUser.firstName = userFirstName

    newUser.lastName = userLastName

    try! context.save()

     

    let newExercise = Exercise(context: context)

    newExercise.category = category

    newExercise.duration = Int64(duration)

    newExercise.intensity = Int64(intensity)

    newExercise.startDate = startDate

    newExercise.user = newUser

    try! context.save()

    }
}
