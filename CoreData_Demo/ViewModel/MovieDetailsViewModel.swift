//
//  MovieDetailsViewModel.swift
//  CoreData_Demo
//
//  Created by SMBA on 19.05.2022..
//

import Foundation
import Combine
import UIKit

class MovieDetailsViewModel: ViewModel {
    
    private (set) var state = PassthroughSubject<State, Never>()
    private var cancellables = Set<AnyCancellable>()
    let imageBase = URL(string: Network.ImageBase.normal.rawValue)!

    //MARK: - State
    
    enum State {
        case loading
        case loaded([MovieDetailsViewModel])
        case error(Error)
    }

    var fetchedDetails: MovieDetails? = nil
    var savedDetails: NSMovieDetails = .init()
    var cast: [Cast] = []
    
    //MARK: - Init
        
    init(details: MovieDetails, cast: [Cast] = []) {
        self.fetchedDetails = details
        self.cast = cast
    }
    
    init(nsMovieDetails: NSMovieDetails) {
        self.savedDetails = nsMovieDetails
        if let savedCast = savedDetails.cast?.allObjects as? [NSCast] {
            savedCast.forEach({cast.append(.init(name: $0.name ?? ""))})
        }
    }
    
    init(id: Int) {
        fetchDetails(id: id)
    }
    
    //MARK: - Publisher Zipped
    
    func zipNetworkPublishers(id: Int) -> AnyPublisher<(MovieDetails,CastResponse), Error> {
        let publisher = Publishers.Zip(Network.fetchDetails(id: id), Network.fetchMovieCast(id: id))
            .eraseToAnyPublisher()
        return publisher
    }
    
    //MARK: - Fetch
    
    func fetchDetails(id: Int) {
        zipNetworkPublishers(id: id)
            .map { MovieDetailsViewModel.init(details: $0, cast: $1.cast ?? []) }
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
            } receiveValue: {[weak self] details in
                self?.state.send(.loaded([details]))
            }.store(in: &cancellables)
    }
}

extension MovieDetailsViewModel {
    
    //MARK: - Properties
    
    var id: Int {
       return fetchedDetails?.id ?? Int(savedDetails.id)
    }
    
    var title: String {
        return fetchedDetails?.title ?? savedDetails.title ?? ""
    }
    
    var rating: Float {
        return fetchedDetails?.voteAverage ?? savedDetails.rating
    }
    
    var overview: String {
        return fetchedDetails?.overview ?? savedDetails.overview ?? ""
    }
    
    var tagline: String {
        return fetchedDetails?.tagline ?? savedDetails.tagline ?? ""
    }
    
    var savedImage: UIImage {
        if let imageData = savedDetails.poster {
            if let savedImage = UIImage(data: imageData) {
                return savedImage
            }
        }
        return .init()
    }
    
    var posterPath: URL? { return fetchedDetails?.poster.map { imageBase.appendingPathComponent($0) }}
    
    var genreNames: [String] {
        if let genres = fetchedDetails?.genres {
            return genres.map { $0.name }
        }
        return []
    }
    
    var savedSubtitle: String? {
        return savedDetails.subtitle
    }
    
    var subtitle: String? {
        let genresDescription = genreNames.joined(separator: ", ")
        return "\(releaseYear) | \(genresDescription)"
    }
    
    var releaseYear: Int {
        let date = fetchedDetails?.releaseDate.flatMap { Helpers.dateFormatter.date(from: $0) } ?? Date()
        return Calendar.current.component(.year, from: date)
    }
}

extension MovieDetailsViewModel: Hashable {
    
    //MARK: - Hashable

    static func == (lhs: MovieDetailsViewModel, rhs: MovieDetailsViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension MovieDetailsViewModel {
    
    //MARK: - Favorite
    
    var isFavorite: Bool {
        guard fetchedDetails != nil else { return false }
        let favorites = CoreDataManager.shared.fetchMovies()
        for item in favorites {
            if item.id == id  {
                return true
            }
        }
        return false
    }
}
