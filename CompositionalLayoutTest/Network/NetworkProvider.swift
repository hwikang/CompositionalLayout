//
//  NetworkProvider.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/11/27.
//

import Foundation
import RxSwift

final class NetworkProvider {
    private let endpoint: String
    init() {
        self.endpoint = "https://api.themoviedb.org/3/movie/"
    }
    
    func makeMovieNetwork() -> MovieNetwork {
        let network = Network<NowPlayingModel>(endpoint)
        return MovieNetwork(network: network)

    }
}

final class MovieNetwork {
    private let network: Network<NowPlayingModel>
    init(network: Network<NowPlayingModel>){
        self.network = network
    }
    
    func getNowPlayingList() -> Observable<NowPlayingModel>{
        return network.getItemList("now_playing")
    }
}

