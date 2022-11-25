//
//  ViewController.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/11/25.
//

import UIKit
import SnapKit
class ViewController: UIViewController {

  
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        return collectionView
    }()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    private func setUI(){
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        configureCollectionView()
    }
 
    private func configureCollectionView() {
        collectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: "BannerCell")
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCell")
        setDataSource()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout{
        return UICollectionViewCompositionalLayout(sectionProvider: {[weak self] sectionIndex, environment in
            
            switch sectionIndex {
            case 0:
                return self?.createBannerSection()
            case 1:
                return self?.createCategorySection()

            default:
                return self?.createBannerSection()
            }
            
        })
    }
    
    
    private func setDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { (collectionView, indexPath, item ) -> UICollectionViewCell? in
            print("item \(item)")
            switch item {
            case .banner(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as? BannerCollectionViewCell else {fatalError()}
                if let text = data.text {
                    cell.configure(text: text, url: data.imageUrl)
                }
                return cell
            case .normalCarousel(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCollectionViewCell else {fatalError()}
                if let name = data.name {
                    cell.configure(name: name, url: data.imageUrl)
                }
                return cell
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as? BannerCollectionViewCell else {fatalError()}
                return cell
            }
        }
        
        snapshot()

    }
    
    private func snapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([Section(id: "banner")])
        snapshot.appendItems([
            Item.banner(HomeItem(text: "Banner One", imageUrl: placeHolderUrl)),
            Item.banner(HomeItem(text: "Banner Two", imageUrl: placeHolderUrl)),
            Item.banner(HomeItem(text: "Banner Three", imageUrl: placeHolderUrl))
            ])
        
        snapshot.appendSections([Section(id: "category")])
        snapshot.appendItems([
            Item.normalCarousel(HomeItem(name: "포장", imageUrl: placeHolderUrl)),
            Item.normalCarousel(HomeItem(name: "신규맛집", imageUrl: placeHolderUrl)),
            Item.normalCarousel(HomeItem(name: "1인분", imageUrl: placeHolderUrl)),
            Item.normalCarousel(HomeItem(name: "한식", imageUrl: placeHolderUrl)),
            Item.normalCarousel(HomeItem(name: "치킨", imageUrl: placeHolderUrl)),
            Item.normalCarousel(HomeItem(name: "분식", imageUrl: placeHolderUrl)),
            ])
        
        dataSource?.apply(snapshot)
    }
    
    private func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func createCategorySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }

}
