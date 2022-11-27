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
        collectionView.register(NormalCarouselCollectionViewCell.self, forCellWithReuseIdentifier: "NormalCarouselCell")
        collectionView.register(SquareCarouselCollectionViewCell.self, forCellWithReuseIdentifier: "SqaureCarouselCell")

        setDataSource()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout{
        return UICollectionViewCompositionalLayout(sectionProvider: {[weak self] sectionIndex, environment in
            
            switch sectionIndex {
            case 0:
                return self?.createBannerSection()
            case 1:
                return self?.createNormalCarouselSection()
            case 2:
                return self?.createSqaureCarouselSection()
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
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NormalCarouselCell", for: indexPath) as? NormalCarouselCollectionViewCell else {fatalError()}
                if let name = data.name {
                    cell.configure(name: name, url: data.imageUrl)
                }
                return cell
            case .squareCarousel(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SqaureCarouselCell", for: indexPath) as? SquareCarouselCollectionViewCell else {fatalError()}
                cell.configure(title: data.name, url: data.imageUrl, review: "\(data.reviewPoint)(\(data.reviewCount))")
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
        
        snapshot.appendSections([Section(id: "normalCarousel")])
        snapshot.appendItems([
            Item.normalCarousel(HomeItem(name: "포장", imageUrl: placeHolderUrl)),
            Item.normalCarousel(HomeItem(name: "신규맛집", imageUrl: placeHolderUrl)),
            Item.normalCarousel(HomeItem(name: "1인분", imageUrl: placeHolderUrl)),
            Item.normalCarousel(HomeItem(name: "한식", imageUrl: placeHolderUrl)),
            Item.normalCarousel(HomeItem(name: "치킨", imageUrl: placeHolderUrl)),
            Item.normalCarousel(HomeItem(name: "분식", imageUrl: placeHolderUrl)),
            ])
    
        snapshot.appendSections([Section(id: "sqaureCarousel")])
        snapshot.appendItems([
            Item.squareCarousel(RestaurantItem(name: "버거슬럽", reviewPoint: 4.9, reviewCount: 235,imageUrl: placeHolderUrl)),
            Item.squareCarousel(RestaurantItem(name: "남도반주", reviewPoint: 4.7, reviewCount: 125,imageUrl: placeHolderUrl)),
            Item.squareCarousel(RestaurantItem(name: "아모르미오", reviewPoint: 5.0, reviewCount: 863,imageUrl: placeHolderUrl)),
            Item.squareCarousel(RestaurantItem(name: "두 셰프의 무회", reviewPoint: 4.9, reviewCount: 2637,imageUrl: placeHolderUrl)),
            Item.squareCarousel(RestaurantItem(name: "남성역골목시장 수라축산", reviewPoint: 4.9, reviewCount: 179,imageUrl: placeHolderUrl))
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
    
    private func createNormalCarouselSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    private func createSqaureCarouselSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.65), heightDimension: .estimated(200))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

        section.orthogonalScrollingBehavior = .continuous
        return section

    }

}
