//
//  ExerciceRepositoryTests.swift
//  AristaTests
//
//  Created by KEITA on 05/08/2024.
//
import XCTest
@testable import Arista
import CoreData

final class ExerciceRepositoryTests: XCTestCase {
    
    var persistenceController: PersistenceController!
      var context: NSManagedObjectContext!
      var exerciseRepository: ExerciseRepository!

      override func setUp() {
          super.setUp()
          // Configure the PersistenceController and context
          persistenceController = PersistenceController()
          context = persistenceController.container.viewContext
          exerciseRepository = ExerciseRepository(viewContext: context)
          
         
      }

      override func tearDown() {
          context = nil
          persistenceController = nil
          exerciseRepository = nil
          super.tearDown()
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
        let persistenceController = PersistenceController(inMemory: false)
        emptyEntities(context: persistenceController.container.viewContext)
        let data = ExerciseRepository(viewContext:  persistenceController.container.viewContext)
        //When
        let exercise = try! data.getExercise()
        //Then
        XCTAssert(exercise.isEmpty == true )

    }

    func test_WhenAddingOneExerciseInDatabase_GetExercise_ReturnAListContainingTheExercise()  {

       //Give
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
        let data = ExerciseRepository(viewContext:persistenceController.container.viewContext)


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

        let data = ExerciseRepository(viewContext:persistenceController.container.viewContext)

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
        let data = ExerciseRepository(viewContext: context)
        
        //When
        try! data.addExercise(category: "Yoga", duration: 4, intensity: 5, startDate: date)

        //Then
        let fetchRequest  : NSFetchRequest<Exercise> = Exercise.fetchRequest()
        let exercise = try! context.fetch(fetchRequest)
        XCTAssert(exercise.count == 2)
        
        let addExercise = exercise.last!
        XCTAssertEqual(addExercise.category  ,"Yoga")
        
    }

}
