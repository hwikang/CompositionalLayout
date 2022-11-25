//
//  TypeOneCollectionViewCell.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/11/25.
//

import UIKit



class BannerCollectionViewCell: UICollectionViewCell {
  
    let label = UILabel()

    let backgroundImage = UIImageView()

    
    override init(frame: CGRect) {
        super.init(frame: .zero)
//        self.backgroundColor = .red
        
        self.addSubview(backgroundImage)
        self.addSubview(label)

        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func configure(text:String, url:String){
        label.text = text
        backgroundImage.load(url: url)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
