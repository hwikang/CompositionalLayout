//
//  CategoryButton.swift
//  CompositionalLayoutTest
//
//  Created by Dumveloper on 2023/01/26.
//

import Foundation
import UIKit


final class CategoryButton: UIButton {
    
    private let title: String
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setUI()

    }
    
    private func setUI() {
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        
        let config = UIButton.Configuration.bordered()
        configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
