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
        collectionView.register(ListCarouselCollectionViewCell.self, forCellWithReuseIdentifier:ListCarouselCollectionViewCell.id)
        collectionView.register(SquareCarouselCollectionViewCell.self, forCellWithReuseIdentifier: "SqaureCarouselCell")
        collectionView.register(SqaureCarouselHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SqaureCarouselHeader")
        setDataSource()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout{
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 30
        return UICollectionViewCompositionalLayout(sectionProvider: {[weak self] sectionIndex, environment in
            
            switch sectionIndex {
            case 0:
                return self?.createBannerSection()
            case 1:
                return self?.createSqaureCarouselSection()
            case 2:
                return self?.createListCarouselSection()

            default:
                return self?.createBannerSection()
            }
            
        },configuration: config)
    }
    
    
    private func setDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { (collectionView, indexPath, item ) -> UICollectionViewCell? in
            print("item \(item)")
            switch item {
            case .banner(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as? BannerCollectionViewCell else {fatalError()}
                cell.configure(text: data.title, url: data.imageUrl)
                
                return cell
            
            case .squareCarousel(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SqaureCarouselCell", for: indexPath) as? SquareCarouselCollectionViewCell else {fatalError()}
                cell.configure(title: data.title, url: data.imageUrl, review: "\(data.reviewPoint)(\(data.reviewCount))")
                return cell
            case .listCarousel(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:ListCarouselCollectionViewCell.id, for: indexPath) as? ListCarouselCollectionViewCell else {fatalError()}
                
                
                let subTitle = data.subTitle ?? ""
                
                cell.configure(title: data.title, subTitle: subTitle, url: data.imageUrl)
                return cell
            }
      
        }
        
        dataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView in
        
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SqaureCarouselHeader", for: indexPath) as? SqaureCarouselHeaderView else { fatalError()}
            print("Section \(indexPath)")
            switch indexPath.section {
            case 1:
                header.configure(title: "주변 맛집", desc: "주변 맛집 목록 입니다")
            case 2:
                header.configure(title: "주변 인기 메뉴", desc: "주변 가장 인기 있는 메뉴 입니다.")
                
            default:
                return header

            }
            return header

        }
        
        snapshot()

    }
    
    private func snapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([Section(id: "banner")])
        snapshot.appendItems([
            Item.banner(HomeItem(title: "Banner One", imageUrl: placeHolderUrl)),
            Item.banner(HomeItem(title: "Banner Two", imageUrl: placeHolderUrl)),
            Item.banner(HomeItem(title: "Banner Three", imageUrl: placeHolderUrl))
            ])
        
    
        snapshot.appendSections([Section(id: "sqaureCarousel")])
        snapshot.appendItems([
            Item.squareCarousel(RestaurantItem(title: "버거슬럽", reviewPoint: 4.9, reviewCount: 235,imageUrl: placeHolderUrl)),
            Item.squareCarousel(RestaurantItem(title: "남도반주", reviewPoint: 4.7, reviewCount: 125,imageUrl: placeHolderUrl)),
            Item.squareCarousel(RestaurantItem(title: "아모르미오", reviewPoint: 5.0, reviewCount: 863,imageUrl: placeHolderUrl)),
            Item.squareCarousel(RestaurantItem(title: "두 셰프의 무회", reviewPoint: 4.9, reviewCount: 2637,imageUrl: placeHolderUrl)),
            Item.squareCarousel(RestaurantItem(title: "남성역골목시장 수라축산", reviewPoint: 4.9, reviewCount: 179,imageUrl: placeHolderUrl))
        ])
        
        
        snapshot.appendSections([Section(id: "listCarousel")])
        snapshot.appendItems([
            Item.listCarousel(HomeItem(title: "인하프", subTitle: "인하프 크림 라떼", imageUrl: placeHolderUrl)),
            Item.listCarousel(HomeItem(title: "그믐족발", subTitle: "그믐족발 앞다리", imageUrl: placeHolderUrl)),
            Item.listCarousel(HomeItem(title: "친목", subTitle: "친목 모둠 대", imageUrl: placeHolderUrl)),
            Item.listCarousel(HomeItem(title: "숯불 호랑", subTitle: "한우 채끝등심 1++", imageUrl: placeHolderUrl)),
            Item.listCarousel(HomeItem(title: "쥬벤쿠바", subTitle: "오리지널 쿠바 샌드위치", imageUrl: placeHolderUrl)),
            Item.listCarousel(HomeItem(title: "고기굽는 사람들", subTitle: "숯불양념구이", imageUrl: placeHolderUrl)),
            

                              
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
    
    private func createListCarouselSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 25)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(350))

        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
        let headerSize  = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.boundarySupplementaryItems = [header]

        section.orthogonalScrollingBehavior = .continuous
        return section
    }
//
    private func createSqaureCarouselSection() -> NSCollectionLayoutSection {
        let headerSize  = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.65), heightDimension: .estimated(200))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20)
        section.boundarySupplementaryItems = [header]
        
        section.orthogonalScrollingBehavior = .continuous
        return section

    }

}
