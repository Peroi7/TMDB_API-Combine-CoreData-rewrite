//
//  MoviesResponse.swift
//  CoreData_Demo
//
//  Created by SMBA on 09.05.2022..
//

import Foundation
import Combine

//MARK: - MoviesResponse

struct MoviesResponse<T: Codable>: Codable {
    let page: Int?
    let results: [T]
}
