//
//  MovieTableViewCell.swift
//  CoreData_Demo
//
//  Created by SMBA on 18.05.2022..
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell, ReusableView, NibProvidable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        movieImageView.sd_imageTransition = .fade
        // Initialization code
    }
    
    //MARK: - Bind
    
    func bind(viewModel: MovieViewModel) {
        titleLabel.text = viewModel.title
        if let poster = viewModel.poster {
            movieImageView.sd_setImage(with: poster)
        } else {
            if let imageData = viewModel.savedPoster {
                movieImageView.image = UIImage(data: imageData)
            }
        }
        
    }
}
