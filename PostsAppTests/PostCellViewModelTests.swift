//
//  PostCellViewModelTests.swift
//  PostsAppTests
//
//  Created by Jefferson Velez on 23/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import XCTest
@testable import PostsApp

class PostCellViewModelTests: XCTestCase {
    func testPostCellViewModel() {
        let post = Post(id: 1, userId: 10, title: "Title", body: "Body")
        let postVM = PostCellViewModel(post: post)
        
        postVM.isUnread = true
            
        XCTAssertEqual(postVM.makeImage(), UIImage(named: "Bluedot"), "Wrong image for unread post")
        
        postVM.isUnread = false
        
        XCTAssertEqual(postVM.makeImage(), nil, "Wrong image for read post")
        
        postVM.isFavorite = true
        
        XCTAssertEqual(postVM.makeImage(), UIImage(named: "Favorite"), "Wrong image for favorite post")
    }
}
