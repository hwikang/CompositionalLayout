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
    case banner(HomeItem)
    case squareCarousel(RestaurantItem)
    case listCarousel(HomeItem)
}

struct HomeItem: Hashable {
    var title: String
    var subTitle: String? = ""
    let imageUrl: String
}


struct RestaurantItem: Hashable {
    let title: String
    let reviewPoint: Float
    let reviewCount: Int
    let imageUrl: String

}
