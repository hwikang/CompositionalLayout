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
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

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
        
        output.nowPlayingList
            .observeOn(MainScheduler.instance)
            .bind { [unowned self] list in
                let itemList = list.results.map({ movie in
                    return Item.banner(MovieItem(title: movie.title, overView: movie.overview, posterUrl: movie.poster_path, vote: "\(movie.vote_average)(\(movie.vote_count))",releaseDate: movie.release_date))

                })
                self.snapshot.appendItems(itemList, toSection: Section(id: "Banner"))
                self.dataSource?.apply(self.snapshot)
            
            }.disposed(by: disposeBag)
        
        output.popularList
            .observeOn(MainScheduler.instance)
            .bind { [unowned self] list in
                let itemList = list.results.map({ movie in
                    return Item.normalCarousel(MovieItem(title: movie.title, overView: movie.overview, posterUrl: movie.poster_path, vote: "\(movie.vote_average)(\(movie.vote_count))",releaseDate: movie.release_date))

                })
                self.snapshot.appendItems(itemList, toSection: Section(id: "NormalCarousel"))
                self.dataSource?.apply(self.snapshot)
            
            }.disposed(by: disposeBag)
        
        output.upComingList
            .observeOn(MainScheduler.instance)
            .bind { [unowned self] list in
                let itemList = list.results.map({ movie in
                    return Item.listCarousel(MovieItem(title: movie.title, overView: movie.overview, posterUrl: movie.poster_path, vote: "\(movie.vote_average)(\(movie.vote_count))",releaseDate: movie.release_date))

                })
                self.snapshot.appendItems(itemList, toSection: Section(id: "ListCarousel"))
                self.dataSource?.apply(self.snapshot)
            
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
           collectionView.register(NowPlayingCollectionViewCell.self, forCellWithReuseIdentifier: NowPlayingCollectionViewCell.id)
           collectionView.register(NormalCarouselCollectionViewCell.self, forCellWithReuseIdentifier: NormalCarouselCollectionViewCell.id)
           collectionView.register(ListCarouselCollectionViewCell.self, forCellWithReuseIdentifier: ListCarouselCollectionViewCell.id)
           collectionView.register(DefaultHeaderView.self, forSupplementaryViewOfKind: DefaultHeaderView.id, withReuseIdentifier: DefaultHeaderView.id)
           self.snapshot.appendSections([Section(id: "Banner")])
           self.snapshot.appendSections([Section(id: "NormalCarousel")])
           self.snapshot.appendSections([Section(id: "ListCarousel")])

           setDataSource()
       }
       
       private func createLayout() -> UICollectionViewCompositionalLayout{
           let config = UICollectionViewCompositionalLayoutConfiguration()
           config.interSectionSpacing = Layout.sectionMargin
           return UICollectionViewCompositionalLayout(sectionProvider: {[weak self] sectionIndex, environment in
               switch sectionIndex {
               case 0:
                   return self?.createNowPlayingSection()
               case 1:
                   let section = self?.createNormalCarouselSection()
                   let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
                   let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: DefaultHeaderView.id, alignment: .topLeading)

                   section?.boundarySupplementaryItems = [header]
                   
                   return section
               case 2:
                   let section = self?.createListCarouselSection()
                   let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
                   let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: DefaultHeaderView.id, alignment: .topLeading)
                   section?.boundarySupplementaryItems = [header]

                   return section
               default:
                   return self?.createNowPlayingSection()
               }
               
           },configuration: config)
       }
       
       
       private func setDataSource() {
           
           dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { (collectionView, indexPath, item ) -> UICollectionViewCell? in
//               print("item \(item)")
               switch item {
               case .banner(let data):
                   guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NowPlayingCollectionViewCell.id, for: indexPath) as? NowPlayingCollectionViewCell else {fatalError()}
                   cell.configure(title: data.title, overview: data.overView,vote: data.vote, url: data.posterUrl)
                   return cell
               case .normalCarousel(let data):
                   guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NormalCarouselCollectionViewCell.id, for: indexPath) as? NormalCarouselCollectionViewCell else {fatalError()}
                   cell.configure(name: data.title, vote: data.vote, url: data.posterUrl)
                   return cell
               case .listCarousel(let data):
                   guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCarouselCollectionViewCell.id, for: indexPath) as? ListCarouselCollectionViewCell else {fatalError()}
                   cell.configure(name: data.title, date: data.releaseDate, url: data.posterUrl)

                   return cell
              
               }
           }
           
           dataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView in
               
               guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DefaultHeaderView.id, for: indexPath) as? DefaultHeaderView else { fatalError()}
               switch indexPath.section {
               case 1:
                   header.configure(title: "인기 있는 영화", desc: "최근 가장 인기 있는 영화목록입니다.")
               case 2:
                   header.configure(title: "개봉 예정 영화", desc: "개봉 예정인 영화목록입니다.")
               default:
                   print("Default Index Header")
               }
               return header
           }


       }
       
       private func createNowPlayingSection() -> NSCollectionLayoutSection {
           let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
           let item = NSCollectionLayoutItem(layoutSize: itemSize)

           let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(Layout.NowPlayingCellHeight))

           let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

           let section = NSCollectionLayoutSection(group: group)
           section.orthogonalScrollingBehavior = .groupPaging
           return section
       }
       
       private func createNormalCarouselSection() -> NSCollectionLayoutSection {
          
           let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
           let item = NSCollectionLayoutItem(layoutSize: itemSize)

           item.contentInsets = NSDirectionalEdgeInsets(top: CellLayout.contentPadding, leading: CellLayout.contentPadding, bottom: CellLayout.contentPadding, trailing: CellLayout.contentPadding)

           let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .estimated(Layout.NormalCarouselCellHeight))
           let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

           let section = NSCollectionLayoutSection(group: group)
           section.orthogonalScrollingBehavior = .continuous
           return section
       }
       
       private func createListCarouselSection() -> NSCollectionLayoutSection {
           let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
           let item = NSCollectionLayoutItem(layoutSize: itemSize)
           item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: CellLayout.contentPadding, bottom: Layout.defaultItemMargin, trailing: CellLayout.contentPadding)

           let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(Layout.ListCarouselCellHeight))

          let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)

           let section = NSCollectionLayoutSection(group: group)
           section.orthogonalScrollingBehavior = .continuous
           return section

       }
}
