//
//  TypeTwoCollectionViewCell.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/11/25.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
      let label = UILabel()
      let image = UIImageView()
      
      override init(frame: CGRect) {
          super.init(frame: .zero)
          
          self.addSubview(image)
          self.addSubview(label)

//          self.backgroundColor = .red
          image.snp.makeConstraints { make in
              make.top.left.right.equalToSuperview()
              make.height.equalToSuperview().multipliedBy(0.6)
          }
          label.snp.makeConstraints { make in
//              make.top.equalTo(image.snp.height)
              make.centerX.bottom.equalToSuperview()
          }
      }
      
      public func configure(name:String, url:String){
          print(name)
          label.text = name
          image.load(url: url)
      }

      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}
