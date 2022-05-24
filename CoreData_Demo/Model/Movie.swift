//
//  Movie.swift
//  CoreData_Demo
//
//  Created by SMBA on 09.05.2022..
//

import Foundation

//MARK: - Movie

struct Movie: Codable {
    
    let id: Int
    let title: String
    let poster: String?
    
    init() {
        id = 0
        title = ""
        poster = ""
    }
    
    init(id: Int, title: String, poster: String) {
        self.id = id
        self.title = title
        self.poster = poster
    }
    
    let imageBase = URL(string: Network.ImageBase.small.rawValue)!
    var posterPath: URL? { poster.map { imageBase.appendingPathComponent($0) }}
    
    private enum CodingKeys: String, CodingKey {
        case title = "original_title"
        case poster = "poster_path"
        case id
    }
}
