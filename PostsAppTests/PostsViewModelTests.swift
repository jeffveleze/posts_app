//
//  PostsViewModelTests.swift
//  PostsAppTests
//
//  Created by Jefferson Velez on 23/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import XCTest
@testable import PostsApp

class PostsViewModelTests: XCTestCase {
    func testLoadPostsLocally() {
        let apiClient = APIClient()
        let postsViewModel = PostsViewModel(apiClient: apiClient)
        
        postsViewModel.loadPostsVMsLocally()

        let waitExpectation = expectation(description: "Loading data locally")

        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            XCTAssertNotNil(postsViewModel.postVms.count, "No posts were loaded locally.")
            XCTAssertNotEqual(postsViewModel.postVms.count, 0, "No posts were loaded locally.")
            
            waitExpectation.fulfill()
        }

        waitForExpectations(timeout: 15)
    }
}
