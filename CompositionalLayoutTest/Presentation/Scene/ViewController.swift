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
                    return Item.banner(MovieItem(title: movie.title, overView: movie.overview, posterUrl: movie.poster_path, vote: "\(movie.vote_average)(\(movie.vote_count))"))

                })
                self.snapshot.appendItems(itemList, toSection: Section(id: "Banner"))
                self.dataSource?.apply(self.snapshot)
            
            }.disposed(by: disposeBag)
        
        output.popularList
            .delay(.milliseconds(1000), scheduler: MainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .bind { [unowned self] list in
                let itemList = list.results.map({ movie in
                    return Item.normalCarousel(MovieItem(title: movie.title, overView: movie.overview, posterUrl: movie.poster_path, vote: "\(movie.vote_average)(\(movie.vote_count))"))

                })
                self.snapshot.appendItems(itemList, toSection: Section(id: "NormalCarousel"))
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
           collectionView.register(SquareCarouselCollectionViewCell.self, forCellWithReuseIdentifier: "SqaureCarouselCell")
           collectionView.register(SqaureCarouselHeaderView.self, forSupplementaryViewOfKind: "SqaureCarouselHeader", withReuseIdentifier: "SqaureCarouselHeader")
           self.snapshot.appendSections([Section(id: "Banner")])
           self.snapshot.appendSections([Section(id: "NormalCarousel")])

           setDataSource()
       }
       
       private func createLayout() -> UICollectionViewCompositionalLayout{
           return UICollectionViewCompositionalLayout(sectionProvider: {[weak self] sectionIndex, environment in
               switch sectionIndex {
               case 0:
                   return self?.createNowPlayingSection()
               case 1:
                   return self?.createNormalCarouselSection()
               case 2:
                   return self?.createSqaureCarouselSection()
               default:
                   return self?.createNowPlayingSection()
               }
               
           })
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
               case .squareCarousel(let data):
                   guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SqaureCarouselCell", for: indexPath) as? SquareCarouselCollectionViewCell else {fatalError()}
                   return cell
              
               }
           }
           
           dataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView in
               guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SqaureCarouselHeader", for: indexPath) as? SqaureCarouselHeaderView else { fatalError()}
               print("Section \(indexPath)")
               header.configure(title: "이츠 오리지널", desc: "쿠팡이츠에서 먼저 맛볼 수 있는 맛집입니다")
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
           item.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 0)

           let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .estimated(Layout.NormalCarouselCellHeight))

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
