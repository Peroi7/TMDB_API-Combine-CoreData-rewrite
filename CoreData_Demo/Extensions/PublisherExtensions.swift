//
//  PublisherExtensions.swift
//  CoreData_Demo
//
//  Created by SMBA on 24.05.2022..
//

import Combine

extension Publisher {
    
    static func fail(_ error: Failure) -> AnyPublisher<Output, Failure> {
        return Fail(error: error).eraseToAnyPublisher()
    }
}
