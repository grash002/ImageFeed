//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Иван Иван on 09.11.2024.
//

import XCTest
@testable import ImageFeed

final class ImagesListServiceTests: XCTestCase {

    func testExample() throws {
        let service = ImagesListService()
        
        let expectation = self.expectation(description: "Wait for Notification")
        
        NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification,
                                               object: nil,
                                               queue: .main) {_ in 
            expectation.fulfill()
        }
        
        service.fetchPhotosNextPage()
        
        wait(for: [expectation], timeout: 10)
        
        XCTAssertEqual(service.photos?.count, 10)
        
    }
    

}
