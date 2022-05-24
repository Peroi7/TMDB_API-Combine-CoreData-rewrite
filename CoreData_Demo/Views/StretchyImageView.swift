//
//  StretchyImageView.swift
//  CoreData_Demo
//
//  Created by SMBA on 19.05.2022..
//

import UIKit
import PureLayout

//MARK: - StretchyImageView

class StretchyImageView: UIView {
    
    var imageViewHeight: NSLayoutConstraint!
    var imageViewBottom: NSLayoutConstraint!
    var containerView: UIView!
    var imageView: UIImageView!
    var scrollView: UIScrollView!
    var blurEffect: UIBlurEffect!
    var visualEffectView: UIVisualEffectView!
    
    var containerViewHeight = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createViews()
        setViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createViews() {
        containerView = UIView()
        self.addSubview(containerView)
        imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        containerView.addSubview(imageView)
        
        blurEffect = UIBlurEffect(style: .light)
        visualEffectView =  UIVisualEffectView(effect: blurEffect)
        imageView.addSubview(visualEffectView)
        visualEffectView.autoPinEdgesToSuperviewEdges()
    }
    
    func setViewConstraints() {
        self.autoMatch(.width, to: .width, of: containerView)
        self.autoAlignAxis(.horizontal, toSameAxisOf: containerView)
        self.autoMatch(.height, to: .height, of: containerView)
        containerView.autoMatch(.width, to: .width, of: imageView)
        containerViewHeight = containerView.autoMatch(.height, to: .height, of: self)
        imageViewBottom = imageView.autoPinEdge(.bottom, to: .bottom, of: containerView)
        imageViewHeight = imageView.autoMatch(.height, to: .height, of: containerView)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeight.constant = max(offsetY, scrollView.contentInset.top)
    }
    
}
