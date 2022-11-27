//
//  SquareCarouselCollectionViewCell.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/11/27.
//

import UIKit

class SquareCarouselCollectionViewCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20,weight: .bold)
        return label
    }()
    let reviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14,weight: .light)
        return label
    }()
    let image = UIImageView()
      
      override init(frame: CGRect) {
          super.init(frame: .zero)

          self.addSubview(image)
          self.addSubview(titleLabel)
          self.addSubview(reviewLabel)
          
          image.snp.makeConstraints { make in
              make.top.left.right.equalToSuperview()
              make.height.equalToSuperview().multipliedBy(0.7)
          }
          titleLabel.snp.makeConstraints { make in
              make.leading.equalToSuperview()
              make.top.equalTo(image.snp.bottom).offset(10)
          }
          reviewLabel.snp.makeConstraints { make in
              make.leading.equalToSuperview()
              make.top.equalTo(titleLabel.snp.bottom).offset(3)
          }
      }
      
    public func configure(title:String, url:String,review:String){
        titleLabel.text = title
        reviewLabel.text = review
        image.load(url: url)
      }

      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}
