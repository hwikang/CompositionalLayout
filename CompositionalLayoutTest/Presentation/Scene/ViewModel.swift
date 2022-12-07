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
        let list: Observable<NowPlayingModel>
    }
    init() {
        
        self.network = NetworkProvider().makeMovieNetwork()
    }
    
    func transform(input: Input) -> Output {
        let list = input.trigger.flatMapLatest { _ -> Observable<NowPlayingModel> in
            return self.network.getNowPlayingList()
                .catchError({ error in
                    print("Catch \(error)")
                    return .just(NowPlayingModel.placeHolder)
                })
                
        }
        
        return Output(list: list)
    }
}
