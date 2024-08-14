//
//  DataRepositoryProtocol.swift
//  Arista
//
//  Created by KEITA on 14/08/2024.
//
import Foundation

protocol DataRepositoryProtocol {
    func getUser() throws -> User?
}

protocol DataExerciseProtocol {
    func getExercise() throws -> [Exercise]
    func addExercise(category:String,duration:Int,intensity:Int,startDate:Date) throws
}
