//
//  ExerciceRepositoryTests.swift
//  AristaTests
//
//  Created by KEITA on 05/08/2024.
//
import AppTests
import XCTest
import Arista
import CoreData
final class ExerciceRepositoryTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    private func emptyEntities(context:NSManagedObjectContext) {
        let fetchRequest = Exercise.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        for exercise in objects {
            context.delete(exercise)
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
        exercise.startDate = startDate
        exercise.user = newUser
        
        try! context.save()
    }
   
    
    func test_WhenNoExerciseIsInDatabase_GetExercise_ReturnEmptyList()  {
        //Give
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController)
        let data = ExerciseRepository(viewContext:  persistenceController.container.viewContext)
        //When
        let exercise = try! data.getExercise()
        //Then
        XCTAssert(exercise.isEmpty == true )
       
    }

    func test_WhenAddingOneExerciseInDatabase_GetExercise_ReturnAListContainingTheExercise()  {
        
       //Give
        let persistenceController = PersistenceController(inMemory:true)
        emptyEntities(context: persistenceController.container.viewContext)
        let date = Date()
        addExercises(context: persistenceController.container.viewContext,
                     category: "Football",
                     duration: 30,
                     intensity: 5,
                     startDate: date,
                     userFirstName: "Magic",
                     userLastName: "Bryan")
        let data = ExerciseRepository(viewContext:persistenceController.container.viewContext)
        
        
        //When
        let exercise =  try! data.getExercise()
        
        //Then
        XCTAssert(exercise.isEmpty == false)
        XCTAssert(exercise?.category == "Football")
        XCTAssert(exercise?.duration == 30)
        XCTAssert(exercise?.intensity == 5)
        XCTAssert(exercise.first?.startDate == date)
   

    }
    
    func test_WhenAddingMultipleExerciseInDatabase_GetExercise_ReturnAListContainingTheExerciseInTheRightOrder(){
        //Give
        let persistenceController = PersistenceController(inMemory:true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let date = Date()
        let date_1 = Date(timeIntervalSinceNow: -(60*60*24))
        let date_2 = Date(timeIntervalSinceNow: -(60*60*24*2))
        
        addExercises(context: persistenceController.container.viewContext,
                     category: "Running",
                     duration: 120,
                     intensity: 1,
                     startDate: date,
                     userFirstName: "Bryan",
                     userLastName: "Magic")
        
        addExercises(context: persistenceController.container.viewContext,
                     category: "Football",
                     duration: 30,
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
        
        let data = ExerciseRepository(viewContext:persistenceController.container.viewContext)
        
        //When
        let exercise = try! data.getExercise()

        
        //Then
        XCTAssert(exercise.count == 3)
        XCTAssert(exercise[0].category == "Running")
        XCTAssert(exercise[1].category == "Football")
        XCTAssert(exercise[2].category == "Yoga")
        
    }

}
