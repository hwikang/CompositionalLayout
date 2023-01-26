//
//  ViewModel.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/11/28.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel {
    private let movieNetwork: MovieNetwork
    private let tvNetwork: TVNetwork
    struct Input {
        let tvTrigger: Observable<Void>
        let movieTrigger: Observable<Void>
    }
    
    struct Output{
        let tvList: Observable<[TV]>
        let movieList: Observable<MovieResult>
    }
    init() {
        let provider = NetworkProvider()
        self.movieNetwork = provider.makeMovieNetwork()
        self.tvNetwork = provider.makeTVNetwork()
    }
    
    func transform(input: Input) -> Output {
        
        let tvList = input.tvTrigger.flatMapLatest { _ -> Observable<[TV]> in
            return self.tvNetwork.getTopRatedList().map { model in
                return model.results
            }
        }
        
        let movieList = input.movieTrigger.flatMapLatest { _ -> Observable<MovieResult> in
            return Observable.combineLatest(self.movieNetwork.getUpcomingList(), self.movieNetwork.getPopularList(), self.movieNetwork.getNowPlayingList()) { upcoming,popular,nowplaying -> MovieResult in
                return MovieResult(upcoming: upcoming, popular: popular, nowPlaying: nowplaying)
                
            }
        }
        
        return Output(tvList:tvList, movieList:movieList)
    }
}
