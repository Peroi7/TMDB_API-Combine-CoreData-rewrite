//
//  MovieViewModel.swift
//  CoreData_Demo
//
//  Created by SMBA on 09.05.2022..
//

import UIKit
import Combine

public protocol ViewModel {}

class MovieViewModel: ViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    private (set) var state = PassthroughSubject<State, Never>()
    var currentPage: Int = 1
    
    //MARK: - State
    
    enum State {
        case loading
        case loaded([MovieViewModel])
        case paging([MovieViewModel])
        case error(Error)
    }
    
    let id: Int
    let title: String
    let poster: URL?
    var savedPoster: Data?
    
    //MARK: - Init
    
    init(nsMovie: NSMovie) {
        id = Int(nsMovie.id)
        title = nsMovie.title ?? ""
        savedPoster = nsMovie.poster
        poster = nil
    }
    
    init(movie: Movie) {
        id = movie.id
        title = movie.title
        poster = movie.posterPath
    }
        
    func paginate(indexPath: IndexPath, items: [MovieViewModel]) {
        let scrollIndex = Int(Constants.itemsPerPage - (Constants.itemsPerPage * 3/4))
        let lastScrollItem = items[items.count - scrollIndex]
        let item = items[indexPath.row]
        
        guard item != lastScrollItem && indexPath.item != items.count - scrollIndex else {
            fetch(pagging: true)
            return }
    }
    
    //MARK: - Fetch
    
    func fetch(pagging: Bool) {
        state.send(.loading)
        Network.fetchMovies(page: currentPage)
            .map{ $0.results.map(MovieViewModel.init) }
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] completion in
                guard let uSelf = self else { return }
                switch completion {
                case .failure(let error):
                    uSelf.state.send(.error(error))
                case .finished:
                    ()
                }
            } receiveValue: {[weak self] values in
                if pagging {
                    self?.currentPage += 1
                    self?.state.send(.paging(values))
                } else {
                    self?.state.send(.loaded(values))
                }
                
            }.store(in: &cancellables)
    }
}

//MARK: - Hashable

extension MovieViewModel: Hashable {
    static func == (lhs: MovieViewModel, rhs: MovieViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

