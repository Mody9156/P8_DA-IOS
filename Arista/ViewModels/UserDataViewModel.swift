//
//  UserDataViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class UserDataViewModel: ObservableObject {
    
    // MARK: - Propertie
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""

    private var viewContext: NSManagedObjectContext

    // MARK: - Init
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchUserData()
    }
    // MARK: - Private
    
    private func fetchUserData() {
        // TODO: fetch data in CoreData and replace dumb value below with appropriate information
        do{
            guard let user = try UserRepository().getUser() else {
                fatalError()
            }
            firstName = user.firstName ?? ""
            lastName = user.lastName ?? ""
        }catch{
            
        }
    }
}
