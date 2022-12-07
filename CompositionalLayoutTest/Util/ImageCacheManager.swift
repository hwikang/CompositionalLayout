//
//  ImageCacheManager.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/12/07.
//

import Foundation
import UIKit

struct ImageCacheManager {
    static let shared = NSCache<NSString,UIImage>()
}
