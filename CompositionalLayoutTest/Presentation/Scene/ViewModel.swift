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
        let nowPlayingList: Observable<MovieListModel>
        let popularList: Observable<MovieListModel>
    }
    init() {
        
        self.network = NetworkProvider().makeMovieNetwork()
    }
    
    func transform(input: Input) -> Output {
        let nowPlayingList = input.trigger.flatMapLatest { _ -> Observable<MovieListModel> in
            return self.network.getNowPlayingList()

                .catchError({ error in
                    print("Catch \(error)")
                    return .just(MovieListModel.placeHolder)
                })
                
        }
        
        let popularList = input.trigger.flatMapLatest { _ -> Observable<MovieListModel> in
            return self.network.getPopularList()
                .catchError({ error in
                    print("Catch \(error)")
                    return .just(MovieListModel.placeHolder)
                })
                
        }
        
        return Output(nowPlayingList: nowPlayingList, popularList: popularList)
    }
}
