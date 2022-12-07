//
//  TypeOneCollectionViewCell.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/11/25.
//

import UIKit



class NowPlayingCollectionViewCell: UICollectionViewCell {
    static let id = "NowPlayingCell"

    let posterImage = UIImageView()
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
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
    let voteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.addSubview(posterImage)
        self.addSubview(stackView)
        
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(overviewLabel)
        stackView.addArrangedSubview(voteLabel)
        
        
       
        posterImage.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(CellLayout.NowPlayingCellImageHeight)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(posterImage.snp.bottom).offset(CellLayout.contentPadding)
            make.left.equalToSuperview().offset(CellLayout.contentPadding)
            make.right.bottom.equalToSuperview().offset(-CellLayout.contentPadding)
        }
    }
    
    public func configure(title:String, overview: String, vote:String, url:String){
        self.title.text = title
        overviewLabel.text = overview
        voteLabel.text = vote
        posterImage.load(url: url)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
