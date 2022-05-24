//
//  Network.swift
//  CoreData_Demo
//
//  Created by SMBA on 09.05.2022..
//

import Foundation
import Combine

//MARK: - Network

enum Network {
    
    private static let base = URL(string: "https://api.themoviedb.org/3")!
    private static let apiKey =  "efb6cac7ab6a05e4522f6b4d1ad0fa43"
    
    //MARK: - Network calls
    
    static func fetchMovies(page: Int) -> AnyPublisher<MoviesResponse<Movie>, Error> {
        let request = URLComponents(url: Network.base.appendingPathComponent("trending/movie/week"), resolvingAgainstBaseURL: true)?
            .parameters(parameters: ["api_key" : apiKey, "page": page])
            .request
        if let request = request {
            return Network.fireRequest(request)
        }
        
        return .fail(URLError.badServerResponse as! Error)
    }
    
    static func fetchDetails(id: Int) -> AnyPublisher<MovieDetails, Error> {
        let request = URLComponents(url: Network.base.appendingPathComponent("movie/\(id)"), resolvingAgainstBaseURL: true)?
            .parameters(parameters: ["api_key" : apiKey])
            .request
        if let request = request {
            return Network.fireRequest(request)
        }
        
        return .fail(URLError.badServerResponse as! Error)
    }
    
    static func fetchMovieCast(id: Int) -> AnyPublisher<CastResponse, Error> {
        let request = URLComponents(url: Network.base.appendingPathComponent("movie/\(id)/credits"), resolvingAgainstBaseURL: true)?
            .parameters(parameters: ["api_key" : apiKey])
            .request
        if let request = request {
            return Network.fireRequest(request)
        }
        
        return .fail(URLError.badServerResponse as! Error)
    }
    
    static func searchMovies(query: String) -> AnyPublisher<MoviesResponse<Movie>, Error> {
        let request = URLComponents(url: Network.base.appendingPathComponent("/search/movie/"), resolvingAgainstBaseURL: true)?
            .parameters(parameters: ["api_key" : apiKey, "query" : query])
            .request
        if let request = request {
            return Network.fireRequest(request)
        }
        
        return .fail(URLError.badServerResponse as! Error)
    }
    
}

extension Network {
    
    //MARK: - Request
    
    private static func fireRequest<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

private extension URLComponents {
    
    //MARK: - Query
    
    func parameters(parameters: [String: CustomStringConvertible]) -> URLComponents {
        var copy = self
        copy.queryItems = parameters.keys.map { key in
            URLQueryItem(name: key, value: parameters[key]?.description)
        }
        return copy
    }
    
    var request: URLRequest? {
        url.map { URLRequest.init(url: $0) }
    }
}

extension Network {
    
    //MARK: - ImageBase
    
    enum ImageBase: String {
        case small = "https://image.tmdb.org/t/p/w92"
        case normal = "https://image.tmdb.org/t/p/w185"
    }
    
}
