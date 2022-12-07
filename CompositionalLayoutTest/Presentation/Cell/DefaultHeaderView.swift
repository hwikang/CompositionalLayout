//
//  DefaultHeaderView.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/12/07.
//

import UIKit

class DefaultHeaderView: UICollectionReusableView {
    static let id = "DefaultHeaderView"
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20,weight: .bold)
        return label
    }()
    let descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14,weight: .light)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        self.addSubview(descLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(CellLayout.contentPadding)
            make.top.equalToSuperview()
        }
        descLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(CellLayout.contentPadding)
            make.bottom.equalToSuperview()
        }
    }
    
    public func configure(title:String,desc:String){
        titleLabel.text = title
        descLabel.text = desc
      }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
  
}
