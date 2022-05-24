//
//  Cast.swift
//  CoreData_Demo
//
//  Created by SMBA on 19.05.2022..
//

import Foundation

//MARK: - Cast

struct Cast: Codable {
    
    let name: String
    let poster: String?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case poster = "profile_path"
    }
    
    //MARK: - Init
    
    init(name: String, poster: String) {
        self.name = name
        self.poster = poster
    }
    
    init(name: String) {
        self.name = name
        poster = nil
    }
    
    let imageBase = URL(string: Network.ImageBase.small.rawValue)!
    
    var posterPath: URL? { return poster.map { imageBase.appendingPathComponent($0) }}
}

//MARK: - Hashable

extension Cast: Hashable {
    
    static func == (lhs: Cast, rhs: Cast) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

