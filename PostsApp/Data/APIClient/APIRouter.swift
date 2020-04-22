//
//  APIRouter.swift
//  PostsApp
//
//  Created by Jefferson Velez on 21/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import Alamofire
import Foundation

struct APIRouter {
    var url: URL!

    init(urlString: String) {
      self.url = URL(string: urlString)
    }
}

extension APIRouter: URLConvertible {
    func asURL() -> URL {
        return url
    }
}

enum APIRouterError: LocalizedError {
    case invalidURL

    var errorDescription: String? {
        switch self {
        case .invalidURL:
          return "URL isn't valid"
        }
    }
}

// MARK: - Routes

enum APIRoute {
    case posts
    case comments
    case user
    
    func path() -> String {
        let baseURL: String = "https://jsonplaceholder.typicode.com"

        switch self {
           case .posts:
             return "\(baseURL)/posts"
        case .comments:
            return "\(baseURL)/comments"
        case .user:
            return "\(baseURL)/user"
        }
    }
}
