//
//  SearchHeaderView.swift
//  CoreData_Demo
//
//  Created by SMBA on 24.05.2022..
//

import UIKit
import Combine

//MARK: - SearchHeaderView

class SearchHeaderView: UIView {
    
    let headerImageView: UIImageView = {
       return UIImageView(image: UIImage(named: "icSearchResults"))
    }()
    
    let headerTitleLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        return headerLabel
    }()
    
    var cancellables = Set<AnyCancellable>()
    @Published var headerTitle: SearchHeaderTitle = .preSearch
    @Published var isVisible: Bool = true

    enum SearchHeaderTitle: String {
        case noResults = "No results found."
        case preSearch = "Search for a movie..."
    }
    
    //MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        addSubview(headerImageView)
        headerImageView.autoSetDimensions(to: .init(width: 60.0, height: 60.0))
        headerImageView.autoCenterInSuperview()
        addSubview(headerTitleLabel)
        headerTitleLabel.text = headerTitle.rawValue
        headerTitleLabel.autoPinEdge(.top, to: .bottom, of: headerImageView, withOffset: Constants.paddingSmall)
        headerTitleLabel.autoAlignAxis(.vertical, toSameAxisOf: headerImageView)
        headerTitleLabel.autoSetDimension(.height, toSize: 20.0)
         
        $headerTitle.sink {[weak self] title in
            DispatchQueue.main.async {
                self?.headerTitleLabel.text = title.rawValue
            }
        }.store(in: &cancellables)
        
        $isVisible.sink {[weak self] isVisible in
            DispatchQueue.main.async {
                self?.alpha = isVisible ? 1 : 0
            }
        }.store(in: &cancellables)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
