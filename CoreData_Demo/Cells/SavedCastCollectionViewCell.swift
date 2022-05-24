//
//  SavedCastCollectionViewCell.swift
//  CoreData_Demo
//
//  Created by SMBA on 24.05.2022..
//

import UIKit

class SavedCastCollectionViewCell: CastCollectionViewCell {
    
    class override func cellIdentifier() -> String {
        return "SavedCastCollectionViewCell"
    }
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        wrapperView.removeFromSuperview()
        contentView.addSubview(castNameLabel)
        castNameLabel.autoPinEdge(.left, to: .left, of: contentView, withOffset: Constants.paddingSmall)
        castNameLabel.autoAlignAxis(.horizontal, toSameAxisOf: contentView)
        castNameLabel.autoSetDimension(.height, toSize: 16.0)
    }
    
    override func config(cast: Cast) {
        castNameLabel.text = cast.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
