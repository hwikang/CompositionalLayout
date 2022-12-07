//
//  Movie.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/11/27.
//

import Foundation



struct Movie: Codable{
    let title: String
    let overview: String
    let poster_path: String
    let vote_average: Float
    let vote_count: Int
    let release_date: String
}
