//
//  FavoritesViewController.swift
//  CoreData_Demo
//
//  Created by SMBA on 19.05.2022..
//

import UIKit
import CoreData
import PureLayout

class FavoritesViewController: BaseViewController<FavoritesViewModel>, NSFetchedResultsControllerDelegate, UITableViewDataSource {
    
    let viewModel = FavoritesViewModel()
    override var navigationItemTitle: String  { return "Favorites" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        viewModel.fetchedResultsController.delegate = self
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //MARK: - FRC Delegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        @unknown default:
            print("Error")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            print("Error")
        }
    }
    
    //MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        let wireFrame = MovieDetailsWireFrame(nsMovieDetails: viewModel.movieDetails(indexPath: indexPath), loaderType: .context)
        navigationController?.pushViewController(wireFrame.detailsViewController(), animated: true)
    }
}

extension FavoritesViewController {
    
    //MARK: - TableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withClass: MovieTableViewCell.self) else {
            return UITableViewCell()
        }
        
        let viewModel = MovieViewModel(nsMovie: viewModel.fetchedResultsController.object(at: indexPath))
        cell.bind(viewModel: viewModel)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(section: section)
    }
}

extension FavoritesViewController {
    
    //MARK: - TableViewRow Action
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Remove") { [weak self] (contextualAction, view, boolValue) in
            
            if let movieObject = self?.viewModel.fetchedResultsController.object(at: indexPath) {
                CoreDataManager.shared.deleteObject(object: movieObject)
            }
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
    
}
