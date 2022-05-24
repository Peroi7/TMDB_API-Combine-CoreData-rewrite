
import Foundation

//MARK: - MovieDetails

struct MovieDetails {
    let id: Int?
    let title: String?
    let overview: String?
    let poster: String?
    let voteAverage: Float?
    let releaseDate: String?
    let tagline: String?
    let genres: [Genre]?
    
    init() {
        id = nil
        title = nil
        overview = ""
        poster = ""
        voteAverage = nil
        releaseDate = ""
        genres = nil
        tagline = ""
    }
    
    init(id: Int, title: String, overview: String, poster: String?, voteAverage: Float, releaseDate: String?, tagline: String?, genres: [Genre]?) {
        self.id = id
        self.title = title
        self.overview = overview
        self.poster = poster
        self.voteAverage = voteAverage
        self.releaseDate = releaseDate
        self.genres = genres
        self.tagline = tagline
    }
}

//MARK: - Decodable

extension MovieDetails: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case tagline
        case poster = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case genres = "genres"
    }
}

//MARK: - Hashable

extension MovieDetails: Hashable {
    static func == (lhs: MovieDetails, rhs: MovieDetails) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
