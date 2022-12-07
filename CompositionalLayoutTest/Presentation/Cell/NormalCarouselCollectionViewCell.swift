//
//  TypeTwoCollectionViewCell.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/11/25.
//

import UIKit

class NormalCarouselCollectionViewCell: UICollectionViewCell {
    static let id = "NormalCarouselCell"
    let label = DefaultTitleLabel()
    let image: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    let voteLabel = DefaultLabel()
      
      override init(frame: CGRect) {
          super.init(frame: .zero)
          self.addSubview(image)
          self.addSubview(label)
          self.addSubview(voteLabel)
          image.snp.makeConstraints { make in
              make.top.left.right.equalToSuperview()
              make.height.equalToSuperview().multipliedBy(0.8)
          }
          label.snp.makeConstraints { make in
              make.top.equalTo(image.snp.bottom).offset(CellLayout.defaultMargin)
              make.leading.trailing.equalToSuperview()
          }
          voteLabel.snp.makeConstraints { make in
              make.top.equalTo(label.snp.bottom).offset(CellLayout.defaultMargin)
              make.leading.equalToSuperview()
          }
      }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.image.image = nil
    }
      
    public func configure(name:String, vote: String, url:String){
        label.text = name
        voteLabel.text = vote
        image.load(url: url)
    
    } 

      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}
