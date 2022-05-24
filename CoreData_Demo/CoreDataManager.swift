//
//  CoreDataManager.swift
//  CoreData_Demo
//
//  Created by SMBA on 19.05.2022..
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    //MARK: - PersistentContainer

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MoviesPersistance")
        container.loadPersistentStores(completionHandler: { (store, error) in
            if let error = error {
                print(error)
            }
        })
        return container
    }()
    
    //MARK: - Movies
    
    func fetchMovies() -> [NSMovie] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSMovie>(entityName: "NSMovie")
        do {
            let movies = try context.fetch(fetchRequest)
            fetchRequest.includesSubentities = false
            return movies
            
        } catch let fetchErr {
            print(fetchErr)
            return []
        }
        
    }
    
    //MARK: - Deletion

    func deleteObject(object: NSManagedObject) {
        persistentContainer.viewContext.delete(object)
        do {
            try persistentContainer.viewContext.save()
        } catch let saveErr {
            print("Failed to save data", saveErr)
        }
    }
    
    func deleteMovie(id: Int) {
        let movieObjects = fetchMovies().filter({$0.id == id})
        movieObjects.forEach { movieObject in
            deleteObject(object: movieObject)
        }
    }
    
    //MARK: - Save
    
    func saveMovie(info: MovieDetailsViewModel, imageData: Data?) {
        let context = persistentContainer.viewContext
        let movie = NSEntityDescription.insert(context: context, entityName: Entities.NSMovie.rawValue) as! NSMovie
        
        movie.setValue(info.title, forKey: NSMovieEntityKeys.title.rawValue)
        movie.setValue(info.id, forKey: NSMovieEntityKeys.id.rawValue)
        if let imageData = imageData {
            movie.setValue(imageData, forKey: NSMovieEntityKeys.poster.rawValue)
        }
        
        let movieDetails = NSEntityDescription.insert(context: context, entityName: Entities.NSMovieDetails.rawValue) as! NSMovieDetails
        
        movieDetails.setValue(info.title, forKey: NSMovieDetailsEntityKeys.title.rawValue)
        movieDetails.setValue(info.id, forKey: NSMovieDetailsEntityKeys.id.rawValue)
        movieDetails.setValue(info.overview, forKey: NSMovieDetailsEntityKeys.overview.rawValue)
        movieDetails.setValue(info.subtitle, forKey: NSMovieDetailsEntityKeys.subtitle.rawValue)
        movieDetails.setValue(info.rating, forKey: NSMovieDetailsEntityKeys.rating.rawValue)
        movieDetails.setValue(imageData, forKey: NSMovieDetailsEntityKeys.poster.rawValue)
        movieDetails.setValue(info.tagline, forKey: NSMovieDetailsEntityKeys.tagline.rawValue)
        
        movie.movieDetails = movieDetails
        
        var castObjects: [NSCast] = []
        
        for item in info.cast {
            let cast = NSEntityDescription.insert(context: context, entityName: Entities.NSCast.rawValue) as! NSCast
            cast.setValue(item.name, forKey: NSCastEntityKeys.name.rawValue)
            castObjects.append(cast)
        }
        
        movieDetails.cast = NSSet(array: castObjects)
        
        do {
            try context.save()
            
        } catch let saveErr {
            print("Failed to save data", saveErr)
            
        }
    }
}

extension CoreDataManager {
    
    //MARK: - Entity Names
    
    private enum Entities: String {
        case NSMovie
        case NSMovieDetails
        case NSCast
    }
    
    private enum NSMovieEntityKeys: String {
        case title
        case id
        case poster
    }
    
    private enum NSMovieDetailsEntityKeys: String {
        case id
        case title
        case overview
        case tagline
        case poster
        case subtitle
        case rating
    }
    
    private enum NSCastEntityKeys: String {
        case name
        case poster
    }
}

extension NSEntityDescription {
    
    public static func insert(context: NSManagedObjectContext, entityName: String) -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
    }
}
