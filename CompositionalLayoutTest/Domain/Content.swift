//
//  Content.swift
//  CompositionalLayoutTest
//
//  Created by Dumveloper on 2023/02/22.
//

import Foundation


struct Content : Hashable {
    let title: String
    let overview: String
    let posterUrl: String
    let vote: String
    let releaseDate: String
    
    init(movie: Movie) {
        self.title = movie.title
        self.overview = movie.overview
        self.posterUrl = movie.posterUrl
        self.vote = movie.vote
        self.releaseDate = movie.releaseDate
    }
    
    init(tv: TV) {
        self.title = tv.name
        self.overview = tv.overview
        self.posterUrl = tv.posterUrl
        self.vote = tv.vote
        self.releaseDate = tv.firstAirDate
    }
}
