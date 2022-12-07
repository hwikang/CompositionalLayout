//
//  ListCarouselCollectionViewCell.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/12/07.
//

import UIKit

class ListCarouselCollectionViewCell: UICollectionViewCell {
    static let id = "ListCarouselCell"
    let image: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    let label = DefaultTitleLabel()
    let dateLabel = DefaultLabel()
      
      override init(frame: CGRect) {
          super.init(frame: .zero)
          self.addSubview(image)
          self.addSubview(label)
          self.addSubview(dateLabel)
          image.snp.makeConstraints { make in
              make.top.left.bottom.equalToSuperview()
              make.width.equalToSuperview().multipliedBy(0.3)
          }
          label.snp.makeConstraints { make in
              make.leading.equalTo(image.snp.trailing).offset(CellLayout.defaultMargin)
              make.top.trailing.equalToSuperview()
          }
          dateLabel.snp.makeConstraints { make in
              make.leading.equalTo(image.snp.trailing).offset(CellLayout.defaultMargin)
              make.top.equalTo(label.snp.bottom).offset(CellLayout.defaultMargin)

          }
      }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.image.image = nil
    }
      
    public func configure(name:String, date: String, url:String){
        label.text = name
        dateLabel.text = "개봉일: \(date)"
        image.load(url: url)
    
    }

      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}
