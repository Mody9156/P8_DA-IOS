//
//  UserDataViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class UserDataViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""

    private var viewContext: NSManagedObjectContext
    private var userRepository: DataRepositoryProtocol

    // MARK: - Init
    
    init(context: NSManagedObjectContext,repository : DataRepositoryProtocol = UserRepository()) {
        self.viewContext = context
        self.userRepository = repository
       fetchUserData()
    }
    // MARK: - Enum
    
    enum UserError : Error {
        case InvalidUser
    }
    
    // MARK: - Private
    
     func fetchUserData()  {
       
        do{
            if let user = try UserRepository().getUser()  {
                
                firstName = user.firstName ?? ""
                lastName = user.lastName ?? ""
            }else{
                firstName = ""
                lastName = ""
            }
            
        }catch{
            UserError.InvalidUser
        }
    }
}

