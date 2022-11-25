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
    case normalCarousel(HomeItem)
    case circleCarousel(HomeItem)
}

struct HomeItem: Hashable {
    var text: String? = ""
    var name: String? = ""
    let imageUrl: String
}


//
//struct CategoryItem: Hashable {
//    let name: String
//    let imageUrl: String
//}
//
//struct RestaurantItem: Hashable {
//    let name: String
//    let imageUrl: String
//}
