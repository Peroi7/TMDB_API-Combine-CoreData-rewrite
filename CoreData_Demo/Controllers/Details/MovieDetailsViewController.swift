//
//  MovieDetailsViewController.swift
//  CoreData_Demo
//
//  Created by SMBA on 19.05.2022..
//

import UIKit
import PureLayout
import Combine
import ProgressHUD
import SDWebImage

class MovieDetailsViewController: BaseViewController<MovieDetailsViewModel> {
    
    var containerView: UIView!
    var scrollView: UIScrollView!
    var backgroundImage: StretchyImageView!
    var movieImageView: UIImageView!
    var movieTitleLabel: UILabel!
    var favoriteButton: UIButton!
    var separatorView: UIView!
    var secondSeparatorView: UIView!
    var descriptionLabel: UILabel!
    var genreLabel: UILabel!
    var ratingLabel: UILabel!
    var ratingImage: UIImageView!
    var loadingView: UIView!
    var collectionView: UICollectionView!
    var castTitleLabel: UILabel!

    var viewModel: MovieDetailsViewModel
    let loaderType: LoaderType

    private lazy var dataSource = makeDataSource()
    
    
    //MARK: - Init
    
    init(viewModel: MovieDetailsViewModel, loaderType: LoaderType) {
        self.loaderType = loaderType
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        viewModel = MovieDetailsViewModel(details: .init())
        loaderType = .network
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = loaderType == .network ? .horizontal : .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        let containerView = UIView.newAutoLayout()
        containerView.backgroundColor = Colors.movieDetailsBackground
        view.backgroundColor = Colors.movieDetailsBackground
    
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .white
        
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.autoPinEdgesToSuperviewEdges()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        backgroundImage = StretchyImageView()
        containerView.addSubview(backgroundImage)
        backgroundImage.backgroundColor = Colors.separatorBackground
        backgroundImage.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        backgroundImage.imageView.sd_imageTransition = .fade
        backgroundImage.autoSetDimension(.height, toSize: 240.0)
        
        movieImageView = UIImageView()
        movieImageView.sd_imageTransition = .fade
        movieImageView.backgroundColor = .white
        movieImageView.layer.cornerRadius = 70.0
        movieImageView.contentMode = .scaleToFill
        movieImageView.layer.masksToBounds = true
        
        backgroundImage.addSubview(movieImageView)
        movieImageView.autoPinEdge(.top, to: .bottom, of: backgroundImage, withOffset: -70.0)
        movieImageView.autoAlignAxis(.vertical, toSameAxisOf: backgroundImage)
        movieImageView.autoSetDimensions(to: .init(width: 140.0, height: 140.0))

        movieTitleLabel = UILabel()
        movieTitleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        movieTitleLabel.numberOfLines = 0

        containerView.addSubview(movieTitleLabel)
        movieTitleLabel.autoPinEdge(.top, to: .bottom, of: movieImageView, withOffset: Constants.paddingDefault)
        movieTitleLabel.autoPinEdge(.left, to: .left, of: containerView, withOffset: Constants.paddingDefault)
        
        favoriteButton = UIButton(type: .custom)
        favoriteButton.layer.cornerRadius = 6.0
        favoriteButton.isUserInteractionEnabled = true
        favoriteButton.backgroundColor = Colors.primaryBackground.withAlphaComponent(0.08)
        
        if loaderType == .network {
            containerView.addSubview(favoriteButton)
            favoriteButton.autoPinEdge(.right, to: .right, of: containerView, withOffset: -Constants.paddingDefault)
            favoriteButton.autoAlignAxis(.horizontal, toSameAxisOf: movieTitleLabel, withOffset: -Constants.elementsPadding)
            favoriteButton.autoSetDimensions(to: .init(width: 48.0, height: 48.0))
            favoriteButton.addTarget(self, action: #selector(onFavorite), for: .touchUpInside)
        }
        
        movieTitleLabel.autoPinEdge(.right, to: loaderType == .network ? .left : .right, of: loaderType == .network ? favoriteButton : containerView, withOffset: -Constants.paddingSmall)
        
        genreLabel = UILabel()
        genreLabel.numberOfLines = 0
        genreLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        containerView.addSubview(genreLabel)
        genreLabel.autoPinEdge(.top, to: .bottom, of: movieTitleLabel)
        genreLabel.autoPinEdge(.left, to: .left, of: containerView, withOffset: Constants.paddingDefault)
        genreLabel.autoPinEdge(.right, to: .right, of: containerView, withOffset: -Constants.paddingDefault)
        genreLabel.autoSetDimension(.height, toSize: 30.0, relation: .greaterThanOrEqual)
        movieTitleLabel.autoPinEdge(.bottom, to: .top, of: genreLabel)

        ratingImage = UIImageView(image: UIImage(named: "icStar"))
        containerView.addSubview(ratingImage)
        ratingImage.autoPinEdge(.top, to: .bottom, of: genreLabel, withOffset: Constants.paddingSmall)
        ratingImage.autoPinEdge(.left, to: .left, of: containerView, withOffset: Constants.paddingDefault)
        ratingImage.autoSetDimensions(to: .init(width: 16.0, height: 16.0))

        ratingLabel = UILabel()
        containerView.addSubview(ratingLabel)
        ratingLabel.autoPinEdge(.left, to: .right, of: ratingImage, withOffset: 4.0)
        ratingLabel.autoPinEdge(.right, to: .right, of: containerView, withOffset: Constants.paddingDefault)
        ratingLabel.autoAlignAxis(.horizontal, toSameAxisOf: ratingImage)
        ratingLabel.autoSetDimension(.height, toSize: Constants.paddingDefault)

        separatorView = UIView()
        containerView.addSubview(separatorView)
        separatorView.autoPinEdge(.top, to: .bottom, of: ratingLabel, withOffset: Constants.paddingDefault)
        separatorView.autoPinEdge(.left, to: .left, of: containerView)
        separatorView.autoPinEdge(.right, to: .right, of: containerView)
        separatorView.autoSetDimension(.height, toSize: 4.0)
        separatorView.backgroundColor = Colors.separatorBackground

        descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        containerView.addSubview(descriptionLabel)
        descriptionLabel.autoPinEdge(.top, to: .top, of: separatorView, withOffset: Constants.paddingSmall)
        descriptionLabel.autoPinEdge(.left, to: .left, of: containerView, withOffset: Constants.paddingSmall)
        descriptionLabel.autoPinEdge(.right, to: .right, of: containerView, withOffset: -Constants.paddingSmall)
        
        secondSeparatorView = UIView()
        secondSeparatorView.backgroundColor = Colors.separatorBackground
        containerView.addSubview(secondSeparatorView)
        secondSeparatorView.autoPinEdge(.left, to: .left, of: containerView)
        secondSeparatorView.autoPinEdge(.right, to: .right, of: containerView)
        secondSeparatorView.autoSetDimension(.height, toSize: 4.0)
        descriptionLabel.autoPinEdge(.bottom, to: .top, of: secondSeparatorView, withOffset: -Constants.paddingSmall)
        
        castTitleLabel = UILabel()
        castTitleLabel.text = "Cast"
        
        castTitleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        containerView.addSubview(castTitleLabel)
        castTitleLabel.autoPinEdge(.top, to: .bottom, of: secondSeparatorView, withOffset: Constants.paddingSmall)
        castTitleLabel.autoPinEdge(.left, to: .left, of: containerView, withOffset: Constants.paddingSmall)
        castTitleLabel.autoPinEdge(.right, to: .right, of: containerView, withOffset: Constants.paddingSmall)

        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Colors.movieDetailsBackground
        containerView.addSubview(collectionView)
        collectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.cellIdentifier())
        collectionView.register(SavedCastCollectionViewCell.self, forCellWithReuseIdentifier: SavedCastCollectionViewCell.cellIdentifier())
        collectionView.autoPinEdge(.top, to: .bottom, of: castTitleLabel, withOffset: Constants.paddingSmall)
        collectionView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        collectionView.autoSetDimension(.height, toSize: loaderType == .network ? 130.0 : 240.0, relation: .greaterThanOrEqual)
        
        scrollView.addSubview(containerView)
        containerView.autoPinEdgesToSuperviewEdges()
        containerView.autoMatch(.width, to: .width, of: scrollView)
        containerView.autoPinEdge(.bottom, to: .bottom, of: collectionView)
        scrollView.contentInset.bottom = 60.0
        
        loadingView = UIView()
        view.addSubview(loadingView)
        loadingView.alpha = loaderType == .network ? 1 : 0
        loadingView.autoPinEdge(.top, to: .bottom, of: movieImageView)
        loadingView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        
        switch loaderType {
        case .network:
            bind(viewModel: viewModel)
        case .context:
            update(viewModel: viewModel)
            updateCast(with: viewModel.cast)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setFavoriteButtonImage(animated: animated)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        backgroundImage.scrollViewDidScroll(scrollView: scrollView)
    }
    
    func update(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        navigationItem.title = viewModel.tagline
        DispatchQueue.main.async { [self] in
            castTitleLabel.alpha = viewModel.cast.isEmpty ? 0 : 1
            movieTitleLabel.text = viewModel.title
            setFavoriteButtonImage(animated: false)
            genreLabel.text = loaderType == .network ? viewModel.subtitle: viewModel.savedSubtitle
            ratingLabel.text = "\(viewModel.rating)"
            descriptionLabel.text = viewModel.overview
            switch loaderType {
            case .network:
                if let poster = viewModel.posterPath {
                    movieImageView.sd_setImage(with: poster)
                    backgroundImage.imageView.sd_setImage(with: poster)
                }
            case .context:
                movieImageView.image = viewModel.savedImage
                backgroundImage.imageView.image = viewModel.savedImage
            }
        }
    }
    
    override func bind(viewModel: MovieDetailsViewModel) {
        viewModel.state.sink { _ in
        } receiveValue: {[weak self] state in
            guard let uSelf = self else { return }
            switch state {
            case .loading:
                uSelf.loadingView.alpha = 1
                uSelf.showHud()
            case .loaded(let details):
                uSelf.dismissHud()
                uSelf.loadingView.alpha = 0
                guard let details = details.first else { return }
                uSelf.update(viewModel: details)
                uSelf.updateCast(with: details.cast)
            case .error(let error):
                print(error.localizedDescription)
            }
        }.store(in: &cancellables)
    }
    
    func updateCast(with cast: [Cast], animate: Bool = false) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, Cast>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(cast, toSection: .cast)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
    
    //MARK: - Favorited
    
    func setFavoriteButtonImage(animated: Bool) {
        let animations = {
            if self.viewModel.isFavorite {
                self.favoriteButton.setImage(UIImage(named: "icAddedToFavorite"), for: .normal)
            }
            else {
                self.favoriteButton.setImage(UIImage(named: "icAddToFavorite"), for: .normal)
            }
        }
        
        if animated {
            UIView.transition(with: favoriteButton.imageView!,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: animations)
        }
        else {
            animations()
        }
    }
    
    @objc func onFavorite() {
        if viewModel.isFavorite {
            CoreDataManager.shared.deleteMovie(id: viewModel.id)
        } else {
            CoreDataManager.shared.saveMovie(info: viewModel, imageData: movieImageView.image?.pngData())
        }
        setFavoriteButtonImage(animated: viewModel.isFavorite)
    }
}

fileprivate extension MovieDetailsViewController {
    
    //MARK: - UICollectionViewDiffableDataSource
    
    enum Section: CaseIterable {
        case cast
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Cast> {
        return UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, cast in
                switch self?.loaderType {
                case .network:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.cellIdentifier(), for: indexPath) as! CastCollectionViewCell
                    cell.config(cast: cast)
                    return cell
                case .context:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedCastCollectionViewCell.cellIdentifier(), for: indexPath) as! SavedCastCollectionViewCell
                    cell.config(cast: cast)
                    return cell
                case .none:
                    break
                }
                
                return UICollectionViewCell()
            }
        )
    }
}

extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch loaderType {
        case .network:
            return .init(width: 70.0, height: 120.0)
        case .context:
            return .init(width: view.frame.width, height: 30.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}

