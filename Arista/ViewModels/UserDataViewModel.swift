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
        try? fetchUserData()
    }
    
    // MARK: - ENUM
    enum FetchUserDataError: Error {
        case userFetchFailed
    }
    
    // MARK: - Public
    
    func fetchUserData() throws {
        
        if let user = try? userRepository.getUser()  {
            
            let userFirstName: String? = user.firstName
            
            if let unwrappedFirstName = userFirstName {
                firstName = unwrappedFirstName
            } else {
                firstName = ""
            }
            
            let userLastName: String? = user.lastName
            
            if let unwrappedLastName = userLastName {
                lastName = unwrappedLastName
            } else {
                lastName = ""
            }
            
        }else{
            throw  FetchUserDataError.userFetchFailed
        }
        
    }
}

