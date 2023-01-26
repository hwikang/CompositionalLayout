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

  
    let buttonView = ButtonView()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        return collectionView
    }()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?

    private let viewModel: ViewModel = ViewModel()
    private let disposeBag = DisposeBag()
    private let tvTrigger = PublishSubject<Void>()
    private let movieTrigger = PublishSubject<Void>()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
        bindView()
        movieTrigger.onNext(())
    }
    
    private func setUI(){
        self.view.addSubview(collectionView)
        self.view.addSubview(buttonView)
        
        buttonView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(buttonView.snp.bottom).offset(0)
            make.leading.trailing.bottom.equalToSuperview()
        }
        configureCollectionView()
    }
    
    private func bindViewModel() {
        let input = ViewModel.Input(tvTrigger: tvTrigger.asObservable(), movieTrigger: movieTrigger.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.movieList
            .observeOn(MainScheduler.instance)
            .bind {[unowned self] result in
                var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

                let bannerItems = result.nowPlaying.results.map {Item.bigImage($0) }
                snapshot.appendSections([Section.banner])
                snapshot.appendItems(bannerItems, toSection: Section.banner)

                let normalItems = result.popular.results.map {Item.normal($0) }
                let popularSetion = Section.horizontal("List of the current popular movies on TMDB. This list updates daily.")
                snapshot.appendSections([popularSetion])
                snapshot.appendItems(normalItems, toSection: popularSetion)

                
                let upcomingSection = Section.list("List of upcoming movies in theatres")
                let listItems = result.upcoming.results.map { Item.list($0) }
                snapshot.appendSections([upcomingSection])
                snapshot.appendItems(listItems, toSection: upcomingSection)

                self.dataSource?.apply(snapshot)

                
            }.disposed(by: disposeBag)
        
        

    }
    
    private func bindView() {
        buttonView.tvButton.rx.tap.bind {[weak self] _ in
            self?.tvTrigger.onNext(())
        }.disposed(by: disposeBag)
        
        buttonView.movieButton.rx.tap.bind {[weak self] _ in
            self?.movieTrigger.onNext(())
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
                   return CollectionViewSection.createNowPlayingSection()
            
               case .horizontal(_):
                   let section = CollectionViewSection.createNormalCarouselSection()
                   let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
                   let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: DefaultHeaderView.id, alignment: .topLeading)

                   section.boundarySupplementaryItems = [header]
                   
                   return section
               case .list(_):
                   let section = CollectionViewSection.createListCarouselSection()
                   let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
                   let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: DefaultHeaderView.id, alignment: .topLeading)

                   section.boundarySupplementaryItems = [header]
                   
                   return section
               default:
                   return CollectionViewSection.createNowPlayingSection()

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
       
     
}
