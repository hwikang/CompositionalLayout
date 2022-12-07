//
//  DefaultLabel.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/12/07.
//

import Foundation
import UIKit
class DefaultTitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = .systemFont(ofSize: 20, weight: .bold)
        self.numberOfLines = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class DefaultLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = .systemFont(ofSize: 14, weight: .light)
        self.numberOfLines = 3
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

