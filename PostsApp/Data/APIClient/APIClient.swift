//
//  APIClient.swift
//  PostsApp
//
//  Created by Jefferson Velez on 21/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import Alamofire
import Foundation
import PromiseKit

protocol APIClientProtocol {
    func fetchPosts() -> Promise<[Post]>
}

// Interface to handle API calls
final class APIClient: APIClientProtocol {
    
    // Generic function to perform all requests
    @discardableResult
    private func performRequest<T:Decodable>(route: APIRouter) -> Promise<T> {
        return Promise { seal in
            AF.request(route.asURL()).responseDecodable(completionHandler: { (response: DataResponse<T, AFError>) in
                switch response.result {
                case let .success(val):
                    seal.fulfill(val)
                case let .failure(err):
                    seal.reject(err)
                }
            })
        }
    }
    
    func fetchPosts() -> Promise<[Post]> {
        let route = APIRouter(urlString: APIRoute.posts.path())
        return performRequest(route: route)
    }
}
