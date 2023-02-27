//
//  ButtonView.swift
//  CompositionalLayoutTest
//
//  Created by Dumveloper on 2023/01/26.
//

import Foundation
import UIKit


final class ButtonView: UIView {
    
    let tvButton = CategoryButton(title: "TV")
    let movieButton = CategoryButton(title: "Movie")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        self.addSubview(tvButton)
        self.addSubview(movieButton)
        
        tvButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        movieButton.snp.makeConstraints { make in
            make.leading.equalTo(tvButton.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
