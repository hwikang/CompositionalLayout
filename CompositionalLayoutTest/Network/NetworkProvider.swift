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
        self.endpoint = "https://api.themoviedb.org/3/"
    }
    
    func makeMovieNetwork() -> MovieNetwork {
        let network = Network<MovieListModel>(endpoint)
        return MovieNetwork(network: network)
    }
    
    func makeTVNetwork() -> TVNetwork {
        let network = Network<TVListModel>(endpoint)
        return TVNetwork(network: network)
    }
}

final class MovieNetwork {
    private let network: Network<MovieListModel>
    init(network: Network<MovieListModel>){
        self.network = network
    }
    
    func getNowPlayingList() -> Observable<MovieListModel>{
        return network.getItemList("movie/now_playing")
    }
    
    func getPopularList() -> Observable<MovieListModel> {
        return network.getItemList("movie/popular")
    }
    
    func getUpcomingList() -> Observable<MovieListModel> {
        return network.getItemList("movie/upcoming")
    }
}

final class TVNetwork {
    private let network: Network<TVListModel>
    init(network: Network<TVListModel>){
        self.network = network
    }
    
    func getTopRatedList() -> Observable<TVListModel> {
        return network.getItemList("tv/top_rated")
    }
    
    
}
