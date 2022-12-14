//
//  UIImageView.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/11/25.
//

import UIKit

extension UIImageView {
    func load(url: String) {
        let nsString = NSString(string: url)
        if let image = ImageCacheManager.shared.object(forKey: nsString) {
            self.image = image
        }
        
        DispatchQueue.global().async { [weak self] in
        let path = "https://image.tmdb.org/t/p/w500\(url)"

            if let url = URL(string: path),
               let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    ImageCacheManager.shared.setObject(image, forKey: nsString)
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
