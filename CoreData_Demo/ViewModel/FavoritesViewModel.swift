//
//  FavoritesViewModel.swift
//  CoreData_Demo
//
//  Created by SMBA on 20.05.2022..
//

import UIKit
import CoreData

class FavoritesViewModel: ViewModel {
    
    //MARK: - FRC
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSMovie> = {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request: NSFetchRequest<NSMovie> = NSMovie.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "title", ascending: true)
        ]
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "title", cacheName: nil)        
        do {
            try frc.performFetch()
        } catch let err {
            print(err)
        }
        return frc
    }()
    
    func movieDetails(indexPath: IndexPath) -> NSMovieDetails? {
        return fetchedResultsController.object(at: indexPath).movieDetails
    }
    
    func numberOfSections() -> Int  {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRows(section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
}
