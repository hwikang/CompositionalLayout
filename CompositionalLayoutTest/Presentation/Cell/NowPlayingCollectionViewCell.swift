//
//  TypeOneCollectionViewCell.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/11/25.
//

import UIKit



class NowPlayingCollectionViewCell: UICollectionViewCell {
    static let id = "NowPlayingCell"

    let poseterImage = UIImageView()
   
    let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.addSubview(poseterImage)
        self.addSubview(title)
        self.addSubview(overviewLabel)
        
        
        title.snp.makeConstraints { make in
            make.top.equalTo(poseterImage.snp.bottom).offset(CellLayout.defaultMargin)
            make.centerX.equalToSuperview()
        }
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(CellLayout.defaultMargin)
            make.leading.trailing.equalToSuperview()
        }
        poseterImage.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(CellLayout.NowPlayingCellImageHeight)
        }
    }
    
    public func configure(title:String, overview: String, url:String){
        self.title.text = title
        overviewLabel.text = overview
        poseterImage.load(url: url)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
