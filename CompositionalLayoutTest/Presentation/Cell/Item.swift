//
//  Item.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/11/25.
//

import Foundation

let placeHolderUrl = "https://edukoreas.com/wp-content/uploads/2022/01/placeholder-2.png"

struct Section: Hashable {
    let id: String
}

enum Item: Hashable {
    case banner(MovieItem)
    case normalCarousel(MovieItem)
    case listCarousel(MovieItem)
}

struct MovieItem: Hashable {
    let title: String
    let overView: String
    let posterUrl: String
    let vote: String
    let releaseDate: String
}
