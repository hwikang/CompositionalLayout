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
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
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
          self.addSubview(overviewLabel)
          image.snp.makeConstraints { make in
              make.top.left.right.equalToSuperview()
              make.height.equalTo(CellLayout.normalImageHeight)
          }
          label.snp.makeConstraints { make in
              make.top.equalTo(image.snp.bottom).offset(CellLayout.defaultMargin)
              make.leading.trailing.equalToSuperview()
          }
          voteLabel.snp.makeConstraints { make in
              make.top.equalTo(label.snp.bottom).offset(CellLayout.defaultMargin)
              make.leading.equalToSuperview()
          }
          overviewLabel.snp.makeConstraints { make in
              make.top.equalTo(voteLabel.snp.bottom).offset(CellLayout.defaultMargin)
              make.leading.trailing.equalToSuperview()
          }
          
      }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.image.image = nil
    }
      
    public func configure(name:String, vote: String, url:String, overView:String){
        label.text = name
        voteLabel.text = vote
        overviewLabel.text = overView
        image.kf.setImage(with: URL(string: url))
    
    } 

      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}
