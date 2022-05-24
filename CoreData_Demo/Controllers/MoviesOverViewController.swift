//
//  ViewController.swift
//  CoreData_Demo
//
//  Created by SMBA on 05.05.2022..
//

import UIKit
import Combine
import PureLayout
import ProgressHUD

class MoviesOverViewViewController: BaseViewController<MovieViewModel> {
    
    let viewModel: MovieViewModel
    lazy private var dataSource = makeDataSource()
    override var navigationItemTitle: String { return "Movies" }
    
    //MARK: - Init
    
    init(viewModel: MovieViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        self.viewModel = .init(movie: .init())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        viewModel.fetch(pagging: false)
        bind(viewModel: viewModel)
        tableView.dataSource = makeDataSource()
    }
    
    //MARK: - Bind

    override func bind(viewModel: MovieViewModel) {
        viewModel.state.sink { _ in
        } receiveValue: {[weak self] state in
            guard let uSelf = self else { return }
            switch state {
            case .loading:
                uSelf.showHud()
            case .loaded(let items):
                uSelf.dismissHud()
                uSelf.update(with: items, animate: false)
                //seems like UI hangs when is animated
            case .paging(let newItems):
                var items = uSelf.dataSource.snapshot().itemIdentifiers
                items.append(contentsOf: newItems)
                uSelf.update(with: items, animate: false)
                uSelf.dismissHud()
            case .error(let error):
                print(error.localizedDescription)
            }
        }.store(in: &cancellables)
    }
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        let viewModel = MovieDetailsViewModel(id: dataSource.snapshot().itemIdentifiers[indexPath.row].id)
        let movieDetailsWireFrame = MovieDetailsWireFrame(viewModel: viewModel, loaderType: .network)
        navigationController?.pushViewController(movieDetailsWireFrame.detailsViewController(), animated: true)
    }
}

extension MoviesOverViewViewController {
    
    //MARK: - UITableViewDiffableDataSource
    
    enum Section: CaseIterable {
        case movies
    }
    
    func makeDataSource() -> UITableViewDiffableDataSource<Section, MovieViewModel> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { [weak self]  tableView, indexPath, movieViewModel in
                guard let cell = tableView.dequeueReusableCell(withClass: MovieTableViewCell.self) else {
                    return UITableViewCell()
                }
                cell.bind(viewModel: movieViewModel)
                if let uSelf = self {
                    let items = uSelf.dataSource.snapshot().itemIdentifiers
                    uSelf.viewModel.paginate(indexPath: indexPath, items: items)
                }
                return cell
            }
        )
    }
    
    func update(with items: [MovieViewModel], animate: Bool = false) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, MovieViewModel>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(items, toSection: .movies)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}
