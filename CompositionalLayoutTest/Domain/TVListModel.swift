//
//  TVListModel.swift
//  CompositionalLayoutTest
//
//  Created by Dumveloper on 2023/01/26.
//

import Foundation

struct TVListModel: Decodable {
    let page: Int
    let results: [TV]
    
    static var placeHolder: TVListModel {
        return TVListModel(page: 0, results: [])
    }
}
