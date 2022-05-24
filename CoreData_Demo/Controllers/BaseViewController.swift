//
//  BaseViewController.swift
//  CoreData_Demo
//
//  Created by SMBA on 24.05.2022..
//

import UIKit
import PureLayout
import ProgressHUD
import Combine

class BaseViewController<Item: ViewModel>: UIViewController, UITableViewDelegate, UISearchControllerDelegate, UITextFieldDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    
    var cancellables = Set<AnyCancellable>()
    var navigationItemTitle: String { return "Movies" }
    var reuseIdentifier = "reuseIdentifier"
    weak private var searchController: UISearchController?
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.rowHeight = 120.0
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarAppearance()
        setupTableView()
    }
    
    func showHud() {
        ProgressHUD.show()
    }
    
    func dismissHud() {
        ProgressHUD.dismiss()
    }
    
    func bind(viewModel: Item) {
        
    }
    
    //MARK: - TableView
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
        tableView.registerNib(cellClass: MovieTableViewCell.self)
        tableView.delegate = self
        // in this case I use same cell for 3 viewcontrollers
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - SearchController
    
    func configSearchViewController(searchControlller: UISearchController) {
        self.searchController = searchControlller
        self.searchController?.obscuresBackgroundDuringPresentation = false
        self.searchController?.searchBar.searchTextField.backgroundColor = .white
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        self.searchController?.delegate = self
        self.searchController?.searchBar.searchTextField.delegate = self
        self.searchController?.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = navigationItemTitle
    }
    
    //MARK: - SearchBar/UITextfield Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    //MARK: - ScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
}

//MARK: - NavigationBar Appearance

extension BaseViewController {
    
    func setupNavigationBarAppearance() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Colors.primaryBackground
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.standardAppearance = appearance;
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        }
    }
}
