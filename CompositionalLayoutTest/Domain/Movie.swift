//
//  Movie.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/11/27.
//

import Foundation

struct Movie: Hashable, Decodable {
    let title: String
    let overview: String
    let posterUrl: String
    let vote: String
    let releaseDate: String

    private enum CodingKeys: String, CodingKey {
        case title
        case overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case releaseDate = "release_date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        overview = try container.decode(String.self, forKey: .overview)
        let path = try container.decode(String.self, forKey: .posterPath)
        posterUrl = "https://image.tmdb.org/t/p/w500/\(path)"
        let voteAvg = try container.decode(Float.self, forKey: .voteAverage)
        let voteCount = try container.decode(Int.self, forKey: .voteCount)

        vote = "\(voteAvg)(\(voteCount))"
        releaseDate = try container.decode(String.self, forKey: .releaseDate)

    }

    
}

