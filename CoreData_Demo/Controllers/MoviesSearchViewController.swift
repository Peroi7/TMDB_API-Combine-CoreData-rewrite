//
//  MoviesSearchViewController.swift
//  CoreData_Demo
//
//  Created by SMBA on 23.05.2022..
//

import UIKit
import Combine

class MovieSearchViewController: BaseViewController<MovieSearchViewModel> {
    
    override var navigationItemTitle: String { return "Search movies" }
    let viewModel = MovieSearchViewModel()
    let searchheaderView = SearchHeaderView()
    let searchController = UISearchController(searchResultsController: nil)
    lazy var dataSource = makeDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind(viewModel: viewModel)
        observeSearchInput()
        
        configSearchViewController(searchControlller: searchController)
        navigationItem.searchController = searchController
        
        view.addSubview(searchheaderView)
        searchheaderView.autoPinEdgesToSuperviewEdges()
    }
    
    //MARK: - Binding
    
    override func bind(viewModel: MovieSearchViewModel) {
        viewModel.state.sink { completion in
        } receiveValue: {[weak self] value in
            guard let uSelf = self else { return }
            switch value {
            case .loading:
                uSelf.showHud()
            case .loaded(let items):
                uSelf.dismissHud()
                if items.isEmpty {
                    uSelf.searchheaderView.isVisible = true
                    uSelf.searchheaderView.headerTitle = .noResults
                }
                uSelf.update(with: items)
            case .error(let error):
                print(error.localizedDescription)
            }
        }.store(in: &cancellables)
    }
    
    func observeSearchInput() {
        viewModel.searchInput
            .filter({!$0.isEmpty})
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { completion in
            } receiveValue: {[weak self] value in
                self?.viewModel.search(query: value)
            }.store(in: &cancellables)
    }
    
    //MARK: - SearchBar/UITextfield Delegate

    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            update(with: [])
        } else {
            viewModel.searchInput.send(searchText)
            searchheaderView.isVisible = false
        }
    }

    override func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        update(with: [])
        searchheaderView.isVisible = true
        searchheaderView.headerTitle = .preSearch
    }
}

extension MovieSearchViewController {
    
    //MARK: - UITableViewDiffableDataSource
    
    enum Section: CaseIterable {
        case movies
    }

    func makeDataSource() -> UITableViewDiffableDataSource<Section, MovieViewModel> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, movieViewModel in
                guard let cell = tableView.dequeueReusableCell(withClass: MovieTableViewCell.self) else {
                    return UITableViewCell()
                }
                cell.bind(viewModel: movieViewModel)
                return cell
            }
        )
    }
    
    func update(with movies: [MovieViewModel], animate: Bool = false) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, MovieViewModel>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(movies, toSection: .movies)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}
