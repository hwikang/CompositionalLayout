//
//  Movie.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/11/27.
//

import Foundation


struct NowPlayingModel: Codable {
    let page: Int
    let results: [Movie]
    
    static var placeHolder: NowPlayingModel {
        return NowPlayingModel(page: 0, results: [])
    }
}


struct Movie: Codable{
    let title: String
    let overview: String
    let poster_path: String
    let vote_average: Float
    let vote_count: Int

}
