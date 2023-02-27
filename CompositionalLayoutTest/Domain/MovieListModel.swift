//
//  NowPlayingModel.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/12/07.
//

import Foundation

struct MovieListModel: Decodable {
    let page: Int
    let results: [Movie]
    
    static var placeHolder: MovieListModel {
        return MovieListModel(page: 0, results: [])
    }
}
