//
//  APIClientTests.swift
//  PostsAppTests
//
//  Created by Jefferson Velez on 23/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import XCTest
@testable import PostsApp

class APIClientTests: XCTestCase {
    func testFetchPosts() {
        let apiClient = APIClient()
        
        let expectation = XCTestExpectation(description: "Loaded posts data")
        
        apiClient.fetchPosts().done { posts in
            XCTAssertNotNil(posts, "No posts were loaded.")
            XCTAssertNotEqual(posts.count, 0, "No videos were loaded.")

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20.0)
    }
    
    func testFetchUsers() {
        let apiClient = APIClient()
        
        let expectation = XCTestExpectation(description: "Loaded posts data")
        
        apiClient.fetchUsers().done { users in
            XCTAssertNotNil(users, "No users were loaded.")
            XCTAssertNotEqual(users.count, 0, "No users were loaded.")

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20.0)
    }
}
