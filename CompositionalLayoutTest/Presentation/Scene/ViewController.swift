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
        
        let input = ViewModel.Input(trigger: trigger.asObservable())
        let output = viewModel.transform(input: input)
        
        output.combinedList
            .observeOn(MainScheduler.instance)
            .bind {[unowned self] result in
                let bannerItems = result.nowPlaying.results.map {Item.bigImage($0) }
                self.snapshot.appendSections([Section.banner])
                self.snapshot.appendItems(bannerItems, toSection: Section.banner)

                let normalItems = result.popular.results.map {Item.normal($0) }
                let popularSetion = Section.horizontal("List of the current popular movies on TMDB. This list updates daily.")
                self.snapshot.appendSections([popularSetion])
                self.snapshot.appendItems(normalItems, toSection: popularSetion)

                
                let upcomingSection = Section.list("List of upcoming movies in theatres")
                let listItems = result.upcoming.results.map { Item.list($0) }
                self.snapshot.appendSections([upcomingSection])
                self.snapshot.appendItems(listItems, toSection: upcomingSection)

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

           setDataSource()
       }
       
       private func createLayout() -> UICollectionViewCompositionalLayout{
           let config = UICollectionViewCompositionalLayoutConfiguration()
           config.interSectionSpacing = Layout.sectionMargin
           return UICollectionViewCompositionalLayout(sectionProvider: {[weak self] sectionIndex, environment in
               let section = self?.dataSource?.sectionIdentifier(for: sectionIndex)
              
               switch section {
               case .banner:
                   return self?.createNowPlayingSection()
            
               case .horizontal(_):
                   let section = self?.createNormalCarouselSection()
                   let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
                   let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: DefaultHeaderView.id, alignment: .topLeading)

                   section?.boundarySupplementaryItems = [header]
                   
                   return section
               case .list(_):
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
               case .bigImage(let data):
                   guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NowPlayingCollectionViewCell.id, for: indexPath) as? NowPlayingCollectionViewCell else {fatalError()}
                   cell.configure(title: data.title, overview: data.overview,vote: data.vote, url: data.posterUrl)
                   return cell
               case .normal(let data):
                   guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NormalCarouselCollectionViewCell.id, for: indexPath) as? NormalCarouselCollectionViewCell else {fatalError()}
                   cell.configure(name: data.title, vote: data.vote, url: data.posterUrl)
                   return cell
               case .list(let data):
                   guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCarouselCollectionViewCell.id, for: indexPath) as? ListCarouselCollectionViewCell else {fatalError()}
                   cell.configure(name: data.title, date: data.releaseDate, url: data.posterUrl)

                   return cell
              
               }
           }
           
           dataSource?.supplementaryViewProvider = {[unowned self] (collectionView, kind, indexPath) -> UICollectionReusableView in
               
               guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DefaultHeaderView.id, for: indexPath) as? DefaultHeaderView else { fatalError()}
               let section = self.dataSource?.sectionIdentifier(for: indexPath.section)
               switch section {
               case .horizontal(let title), .list(let title):
                   header.configure(title: title)

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
