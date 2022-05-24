//
//  MovieDetailsWireframe.swift
//  CoreData_Demo
//
//  Created by SMBA on 20.05.2022..
//

import Foundation
import UIKit

//MARK: - WireFrame

struct MovieDetailsWireFrame {
    
    let loaderType: LoaderType
    let viewModel: MovieDetailsViewModel?
    let nsMovieDetails: NSMovieDetails?

    init(nsMovieDetails: NSMovieDetails?, loaderType: LoaderType) {
        self.nsMovieDetails = nsMovieDetails
        self.loaderType = loaderType
        viewModel = MovieDetailsViewModel(nsMovieDetails: nsMovieDetails ?? .init())
    }
    
    init(viewModel: MovieDetailsViewModel, loaderType: LoaderType) {
        self.viewModel  = viewModel
        self.loaderType = loaderType
        nsMovieDetails = nil
    }
    
    func detailsViewController() -> MovieDetailsViewController  {
        if let viewModel = viewModel {
            return MovieDetailsViewController(viewModel: viewModel, loaderType: loaderType)
        } else {
            return .init()
        }
    }
}

