//
//  Item.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/11/25.
//

import Foundation

enum Section: Hashable {
    case banner
    case horizontal(String)
    case list(String)
    case double(String)
}

enum Item: Hashable {
    case bigImage(Movie)
    case normal(Content)
    case list(Movie)
}

