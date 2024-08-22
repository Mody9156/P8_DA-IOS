//
//  SleepHistoryViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class SleepHistoryViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var sleepSessions = [Sleep]()
    
    var viewContext: NSManagedObjectContext
    private var sleepRepository: DataSleepProtocol
    
    // MARK: - Init
    
    init(context: NSManagedObjectContext,repository : DataSleepProtocol = SleepRepository()) {
        self.viewContext = context
        self.sleepRepository = repository
        
        fetchSleepSessions()
    }
    
    
    // MARK: - Public
    
    func fetchSleepSessions()    {
        
        do {
            sleepSessions = try sleepRepository.getSleepSessions()
            
          
        }catch{
            
            fatalError("Erreur : Les éléments entrés sont incorrects. Veuillez vérifier les informations saisies et réessayer. Assurez-vous que tous les champs obligatoires sont remplis correctement. Description : \(error.localizedDescription)")
            
        }
        
    }
    
    func reload() throws  {
      fetchSleepSessions()
        
    }
}
