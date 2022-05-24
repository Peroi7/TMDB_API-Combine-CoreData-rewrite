//
//  MovieSearchViewModel.swift
//  CoreData_Demo
//
//  Created by SMBA on 23.05.2022..
//

import UIKit
import Combine

class MovieSearchViewModel: ViewModel {
    
    private (set) var state = PassthroughSubject<State, Never>()
    private (set) var searchInput = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    enum State {
        case loading([MovieViewModel])
        case loaded([MovieViewModel])
        case error(Error)
    }
    
    //MARK: - Search
    
    func search(query: String) {
        state.send(.loading([]))
        Network.searchMovies(query: query)
            .map{ $0.results.map(MovieViewModel.init) }
            .sink { [weak self] completion in
                guard let uSelf = self else { return }
                switch completion {
                case .failure(let error):
                    uSelf.state.send(.error(error))
                    print(error.localizedDescription)
                case .finished:
                    ()
                }
            } receiveValue: {[weak self] values in
                self?.state.send(.loaded(values))
            }.store(in: &cancellables)
    }
}
