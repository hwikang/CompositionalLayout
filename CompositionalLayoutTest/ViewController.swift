//
//  ViewController.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/11/25.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
class ViewController: UIViewController {

  
    let retryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Retry", for: .normal)
        button.backgroundColor = .red
        return button
    }()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        return collectionView
    }()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private let viewModel: ViewModel = ViewModel()
    private let disposeBag = DisposeBag()
    private let trigger = PublishSubject<Bool>()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
        bindView()
        trigger.onNext(true)

    }
    
    private func setUI(){
        self.view.addSubview(collectionView)
        self.view.addSubview(retryButton)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        retryButton.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview()
        }
        configureCollectionView()
    }
    
    private func bindViewModel() {
//        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
//            .map{_ in Void()}

//        let pull = collectionView.refreshControl?.rx
//            .controlEvent(.valueChanged)
//            .flatMapLatest{ Observable<Void>.of()}
        
        let input = ViewModel.Input(trigger: trigger.asObservable())
        let output = viewModel.transform(input: input)
        
        output.list.subscribe {[weak self] event in
            let movieList = event.element?.results
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

            snapshot.appendSections([Section(id: "Banner")])

            if let itemList = movieList?.map({ movie in
                return Item.banner(MovieItem(title: movie.title, overView: movie.overview, posterUrl: movie.poster_path))

            }) {
                print("itemList \(itemList)")
                snapshot.appendItems(itemList )

            }

            self?.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
        
    }
    
    private func bindView() {
        retryButton.rx.tap.bind{ [weak self] in
            self?.trigger.onNext(true)
        }.disposed(by: disposeBag)
    }
 

}


//Collection View
extension ViewController {
    
       private func configureCollectionView() {
           collectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: "BannerCell")
           collectionView.register(NormalCarouselCollectionViewCell.self, forCellWithReuseIdentifier: "NormalCarouselCell")
           collectionView.register(SquareCarouselCollectionViewCell.self, forCellWithReuseIdentifier: "SqaureCarouselCell")
           collectionView.register(SqaureCarouselHeaderView.self, forSupplementaryViewOfKind: "SqaureCarouselHeader", withReuseIdentifier: "SqaureCarouselHeader")
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
//               print("item \(item)")
               switch item {
               case .banner(let data):
                   guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as? BannerCollectionViewCell else {fatalError()}
                   print("data \(data)")
                   cell.configure(text: data.title, url: data.posterUrl)

//                   if let text = data.text {
//                       cell.configure(text: text, url: data.imageUrl)
//                   }
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
              
               }
           }
           
           dataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView in
               guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SqaureCarouselHeader", for: indexPath) as? SqaureCarouselHeaderView else { fatalError()}
               print("Section \(indexPath)")
               header.configure(title: "이츠 오리지널", desc: "쿠팡이츠에서 먼저 맛볼 수 있는 맛집입니다")
               return header
           }

//           snapshot()

       }
       
       private func snapshot() {
           var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
//           snapshot.appendSections([Section(id: "banner")])
//           snapshot.appendItems([
//               Item.banner(HomeItem(text: "Banner One", imageUrl: placeHolderUrl)),
//               Item.banner(HomeItem(text: "Banner Two", imageUrl: placeHolderUrl)),
//               Item.banner(HomeItem(text: "Banner Three", imageUrl: placeHolderUrl))
//               ])
           
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
           let headerSize  = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
           let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "SqaureCarouselHeader", alignment: .topLeading)
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
