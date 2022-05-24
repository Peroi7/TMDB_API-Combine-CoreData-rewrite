//
//  CastCollectionViewCell.swift
//  CoreData_Demo
//
//  Created by SMBA on 19.05.2022..
//

import Foundation
import UIKit
import PureLayout
import SDWebImage

class CastCollectionViewCell: UICollectionViewCell, NibProvidable, ReusableView {
    
    class func cellIdentifier() -> String {
        return "CastCollectionViewCell"
    }
    
    var castImageView: UIImageView!
    var castNameLabel: UILabel!
    var wrapperView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        wrapperView = UIView()
        contentView.addSubview(wrapperView)
        wrapperView.autoPinEdgesToSuperviewEdges()

        castImageView = UIImageView()
        castImageView.backgroundColor = Colors.movieDetailsBackground
        castImageView.contentMode = .scaleAspectFill
        wrapperView.addSubview(castImageView)
        castImageView.autoAlignAxis(.vertical, toSameAxisOf: wrapperView)
        castImageView.autoAlignAxis(.horizontal, toSameAxisOf: wrapperView, withOffset: -10.0)
        castImageView.autoSetDimensions(to: .init(width: 70.0, height: 70.0))
        castImageView.sd_imageTransition = .fade
        castImageView.layer.cornerRadius = 35.0
        castImageView.layer.masksToBounds = true

        castNameLabel = UILabel()
        castNameLabel.textAlignment = .center
        castNameLabel.numberOfLines = 0
        castNameLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        contentView.addSubview(castNameLabel)
        castNameLabel.autoPinEdge(.top, to: .bottom, of: castImageView, withOffset: 4.0)
        castNameLabel.autoPinEdge(.left, to: .left, of: wrapperView)
        castNameLabel.autoPinEdge(.right, to: .right, of: wrapperView)
        castNameLabel.autoSetDimension(.height, toSize: 20.0, relation: .greaterThanOrEqual)
    }
    
    func config(cast: Cast) {
        if let poster = cast.posterPath {
            castImageView.sd_setImage(with: poster)
        }
        castNameLabel.text = cast.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

