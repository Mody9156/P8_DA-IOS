//
//  DataRepositoryProtocol.swift
//  Arista
//
//  Created by KEITA on 14/08/2024.
//
import Foundation
import CoreData

protocol DataRepositoryProtocol {
    func getUser() throws -> User?
}

protocol DataExerciseProtocol {
    func getExercise() throws -> [Exercise]
    func addExercise(category:String,duration:Int,intensity:Int,startDate:Date) throws
}

protocol DataSleepProtocol{
    func getSleepSessions() throws -> [Sleep]
    func addSleepSessions(duration:Int,quality:Int,startDate:Date) throws
    
}

