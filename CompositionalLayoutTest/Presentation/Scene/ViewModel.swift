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
    private let network: MovieNetwork
    
    struct Input {
        let trigger: Observable<Bool>
    }
    
    struct Output{
        let combinedList: Observable<MovieResult>
    }
    init() {
        
        self.network = NetworkProvider().makeMovieNetwork()
    }
    
    func transform(input: Input) -> Output {
        let combined = input.trigger.flatMapLatest { _ -> Observable<MovieResult> in
            return Observable.combineLatest(self.network.getUpcomingList(), self.network.getPopularList(), self.network.getNowPlayingList()) { upcoming,popular,nowplaying -> MovieResult in
                return MovieResult(upcoming: upcoming, popular: popular, nowPlaying: nowplaying)
                
            }
        }
        
        return Output(combinedList:combined)
    }
}
