//
//  Network.swift
//  CompositionalLayoutTest
//
//  Created by 강휘 on 2022/11/27.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

class Network<T:Decodable> {
    private let endpoint: String
    private let queue: ConcurrentDispatchQueueScheduler
    init(_ endpoint:String) {
        self.endpoint = endpoint
        self.queue = ConcurrentDispatchQueueScheduler(qos: .background)
    }
    
    func getItemList(_ path: String) -> Observable<T> {
        let absolutePath  = "\(endpoint)\(path)?api_key=\(APIKEY)&language=ko"
        return RxAlamofire.data(.get, absolutePath)
            .observeOn(queue)
            .debug()
            .map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }
        
    }
}
