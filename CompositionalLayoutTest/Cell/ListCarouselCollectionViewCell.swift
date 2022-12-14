//
//  TypeTwoCollectionViewCell.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/11/25.
//

import UIKit

class ListCarouselCollectionViewCell: UICollectionViewCell {
    static let id = "ListCarouselCell"
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    private let subTitleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
      let image = UIImageView()
      
      override init(frame: CGRect) {
          super.init(frame: .zero)
          
          self.addSubview(image)
          self.addSubview(titleLabel)
          self.addSubview(subTitleLabel)
          image.snp.makeConstraints { make in
              make.top.left.bottom.equalToSuperview()
              make.width.equalToSuperview().multipliedBy(0.3)
          }
          titleLabel.snp.makeConstraints { make in
              make.left.equalTo(image.snp.right).offset(10)
              make.top.equalToSuperview().offset(4)
          }
          subTitleLabel.snp.makeConstraints { make in
              make.left.equalTo(image.snp.right).offset(10)
              make.top.equalTo(titleLabel.snp.bottom).offset(4)
          }
      }
      
    public func configure(title: String, subTitle:String, url:String){
          titleLabel.text = title
          subTitleLabel.text = subTitle
          image.load(url: url)
      }

      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}
