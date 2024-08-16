//
//  ExerciceRepositoryTests.swift
//  AristaTests
//
//  Created by KEITA on 05/08/2024.
//
import XCTest
@testable import Arista
import CoreData

final class ExerciseRepositoryTests: XCTestCase {
    
    
    
    private func emptyEntities(context:NSManagedObjectContext) {
        let fetchRequest = Exercise.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        for exercise in objects {
            context.delete(exercise)
        }
        
    }
    
    private func EmptyExercise(context:NSManagedObjectContext){//Maj
        let fetchRequest  : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Exercise")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            XCTFail("Failed to clear entities: \(error.localizedDescription)")
        }
    }
    
    private func addExercises(context:NSManagedObjectContext,category:String,duration:Int,intensity:Int,startDate:Date, userFirstName: String,userLastName: String){
        let newUser = User(context: context)
        newUser.firstName = userFirstName
        newUser.lastName = userLastName
        
        try! context.save()
        
        let exercise = Exercise(context: context)
        exercise.intensity =  Int64(intensity)
        exercise.duration = Int64(duration)
        exercise.category = category
        exercise.startDate = startDate
        exercise.user = newUser
        
        try! context.save()
    }//*
    
    
    func test_WhenNoExerciseIsInDatabase_GetExercise_ReturnEmptyList()  {
        //Give
        let persistenceController = PersistenceController(inMemory: false)
        let mockDataManager = MockFailingDataManager()

        emptyEntities(context: persistenceController.container.viewContext)
        let data = ExerciseRepository(viewContext:  persistenceController.container.viewContext, dataManager: mockDataManager)
        //When
        let exercise = try! data.getExercise()
        //Then
        XCTAssert(exercise.isEmpty == true )
        
    }
    
    func test_WhenAddingOneExerciseInDatabase_GetExercise_ReturnAListContainingTheExercise()  {
        
        //Give
        let mockDataManager = MockFailingDataManager()

        let persistenceController = PersistenceController(inMemory:false)
        emptyEntities(context: persistenceController.container.viewContext)
        let date = Date()
        addExercises(context: persistenceController.container.viewContext,
                     category: "Football",
                     duration: 30,
                     intensity: 5,
                     startDate: date,
                     userFirstName: "Magic",
                     userLastName: "Bryan")
        let data = ExerciseRepository(viewContext:persistenceController.container.viewContext, dataManager:  mockDataManager)
        
        
        //When
        
        let exercise =  try! data.getExercise()
        //Then
        XCTAssert(exercise.isEmpty == false)
        XCTAssert(exercise.first?.duration == 30)
        XCTAssert(exercise.first?.intensity == 5)
        XCTAssert(exercise.first?.startDate == date)
        
    }
    
    func test_WhenAddingMultipleExerciseInDatabase_GetExercise_ReturnAListContainingTheExerciseInTheRightOrder(){
        //Give
        let persistenceController = PersistenceController(inMemory:false)
        emptyEntities(context: persistenceController.container.viewContext)
        let mockDataManager = MockFailingDataManager()

        let date = Date()
        let date_1 = Date(timeIntervalSinceNow: -(60 * 60 * 24))
        let date_2 = Date(timeIntervalSinceNow: -(60 * 60 * 24 * 2))
        
        addExercises(context: persistenceController.container.viewContext,
                     category: "Running",
                     duration: 120,
                     intensity: 1,
                     startDate: date,
                     userFirstName: "Bryan",
                     userLastName: "Magic")
        
        addExercises(context: persistenceController.container.viewContext,
                     category: "Football",
                     duration: 40,
                     intensity: 5,
                     startDate: date_1,
                     userFirstName: "Fréderic",
                     userLastName: "Marcus")
        
        
        addExercises(context: persistenceController.container.viewContext,
                     category: "Yoga",
                     duration: 30,
                     intensity: 5,
                     startDate: date_2,
                     userFirstName: "Erica",
                     userLastName: "Bryan")
        
        let data = ExerciseRepository(viewContext:persistenceController.container.viewContext, dataManager:  mockDataManager)
        
        //When
        let exercise = try! data.getExercise()
        
        
        //Then
        XCTAssert(exercise.count == 3)
        XCTAssert(exercise[0].duration == 120)
        XCTAssert(exercise[1].duration == 40)
        XCTAssert(exercise[2].duration == 30)
        
    }
    
    func test_addExercise(){
        //Give
        let date = Date()
        let persistenceController = PersistenceController(inMemory: false)
        let context : NSManagedObjectContext
        let mockDataManager = MockFailingDataManager()

        context = persistenceController.container.viewContext
        
        EmptyExercise(context: context)
        addExercises(context: context, category: "Yoga", duration: 23, intensity: 10, startDate: date, userFirstName: "Mickael", userLastName: "James")
        
        //When
        
        let data = ExerciseRepository(viewContext: context, dataManager:  mockDataManager)
        try! data.addExercise(category: "Yoga", duration: 22, intensity: 5, startDate: date)
        //Then
        let fetchRequest  : NSFetchRequest<Exercise> = Exercise.fetchRequest()
        let exercises = try! context.fetch(fetchRequest)
        XCTAssert(exercises.count == 2)
        XCTAssert(exercises.isEmpty == false)
        
        let addNewExercise = exercises.last!
        XCTAssertEqual(addNewExercise.category, "Yoga")
        XCTAssertEqual(addNewExercise.duration , 22)
        XCTAssertEqual(addNewExercise.intensity , 5)
        XCTAssertEqual(addNewExercise.startDate , date)
        
    }
    
    func test_ExerciseIsEmpty() throws {
        //Give
        let mockDataManager = MockFailingDataManager()

        let date = Date()
        let persistenceController = PersistenceController(inMemory: false)
        let context : NSManagedObjectContext!
        context = persistenceController.container.viewContext
        
        emptyEntities(context: context)
        
        //When
        let data = ExerciseRepository(viewContext: context, dataManager: mockDataManager)
        
        //Then
        let fetchRequest  : NSFetchRequest<Exercise> = Exercise.fetchRequest()
        let exercise = try! context.fetch(fetchRequest)
        XCTAssert(exercise.count == 0)
        XCTAssert(exercise.isEmpty == true)
        
    }
    func test_getExercise_throwsError() {
        // Given
        let mockDataManager = MockFailingDataManager()
        let PersistenceController = PersistenceController(inMemory: false)
        let repository = ExerciseRepository(viewContext:PersistenceController.container.viewContext,dataManager: mockDataManager )

        // When & Then
        XCTAssertThrowsError(try repository.getExercise()) { error in
            XCTAssertEqual((error as NSError).domain, "MockErrorDomain")
            XCTAssertEqual((error as NSError).code, 1)
            XCTAssertEqual((error as NSError).localizedDescription, "Simulated fetch error")
        }
    }

}
extension NSManagedObjectContext: DataManaging {
    public func fetch<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) throws -> [T] {
            return try self.fetch(request)
        }
        
    public func save() throws {
            try self.save()
        }
    
   
}
class MockFailingDataManager: DataManaging {
    func fetch<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) throws -> [T] {
        throw NSError(domain: "MockErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Simulated fetch error"])
    }
    
    func save() throws {
        // Simulez des comportements si nécessaire
    }
}
