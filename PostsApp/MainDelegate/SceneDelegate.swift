//
//  SceneDelegate.swift
//  PostsApp
//
//  Created by Jefferson Velez on 21/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityLogger

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var postsCoordinator: PostsCoordinator!
        
    lazy var apiClient: APIClientProtocol = self.makeAPIClient()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
                        
            // Creating starting coordinator and launching it
            postsCoordinator = PostsCoordinator(window: window,apiClient: apiClient)
            postsCoordinator.start()
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    private func makeAPIClient() -> APIClientProtocol {
        // Enable network activity logs for debug purposes
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
        
        return APIClient()
    }
}

