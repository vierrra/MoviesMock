//

import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let posterPath: String?
    let backdropPath: String?
    let title: String
    let releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case title
        case releaseDate = "release_date"
    }
}

