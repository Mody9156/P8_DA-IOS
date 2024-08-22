//
//  AddSleepViewModel.swift
//  Arista
//
//  Created by KEITA on 13/08/2024.
//

import Foundation
import CoreData

class AddSleepViewModel : ObservableObject{
    
    // MARK: - Properties
    
    @Published var quality: Int = 0
    @Published var startTime: Date = Date()
    @Published var duration: Int = 0
    @Published var errorMessage = ""
    
    private var viewContext: NSManagedObjectContext
    private var userRepository: DataSleepProtocol
    
    // MARK: - Init
    
    init(context: NSManagedObjectContext,repository : DataSleepProtocol = SleepRepository()) {
        self.viewContext = context
        self.userRepository = repository
    }
    
    // MARK: - Public
    
    @discardableResult
    
    func whenElementIsEmpty() -> Bool {
        if  duration <= 0  {
            errorMessage = "Erreur : Tous les champs doivent être remplis correctement."
            return true
        }
        errorMessage = ""
        return false
    }
    
    func addSleepSessions()  {
        
        whenElementIsEmpty()
        
        do{
            try SleepRepository(viewContext: viewContext).addSleepSessions(duration: duration, quality: quality, startDate: startTime)
            errorMessage = ""
            
        }catch{
            errorMessage = "Erreur : Les éléments entrés sont incorrects. Veuillez vérifier les informations saisies et réessayer. Assurez-vous que tous les champs obligatoires sont remplis correctement."
            
        }
    }
    
}
