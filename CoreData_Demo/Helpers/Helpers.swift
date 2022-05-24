//
//  Helpers.swift
//  CoreData_Demo
//
//  Created by SMBA on 19.05.2022..
//

import Foundation

struct Helpers {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
}
