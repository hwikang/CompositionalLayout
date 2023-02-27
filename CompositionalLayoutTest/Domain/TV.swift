//
//  TV.swift
//  CompositionalLayoutTest
//
//  Created by Dumveloper on 2023/01/26.
//

import Foundation

struct TV: Decodable, Hashable {
    let name: String
    let overview: String
    let posterUrl: String
    let vote: String
    let firstAirDate: String

    private enum CodingKeys: String, CodingKey {
        case name
        case overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case firstAirDate = "first_air_date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        overview = try container.decode(String.self, forKey: .overview)
        let path = try container.decode(String.self, forKey: .posterPath)
        posterUrl = "https://image.tmdb.org/t/p/w500/\(path)"
        let voteAvg = try container.decode(Float.self, forKey: .voteAverage)
        let voteCount = try container.decode(Int.self, forKey: .voteCount)

        vote = "\(voteAvg)(\(voteCount))"
        firstAirDate = try container.decode(String.self, forKey: .firstAirDate)

    }
}
