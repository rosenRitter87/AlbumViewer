//
//  AlbumViewerTests.swift
//  AlbumViewerTests
//
//  Created by Hamza Nejjar on 22/01/2021.
//

import XCTest
import RxSwift
@testable import AlbumViewer

class AlbumViewerTests: XCTestCase {
    private let disposeBag = DisposeBag()
    let mockAlbumsServicesClient = MockAlbumsServicesClient()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_get_users() throws {
        let expectation = self.expectation(description: "")
        mockAlbumsServicesClient.getUsers()
            .subscribe(onNext: { users in
                XCTAssertTrue(users.count > 0)
                expectation.fulfill()
            }) { (error) in
                XCTFail(error.localizedDescription)
            }.disposed(by: disposeBag)
        
        self.waitForExpectations(timeout: 4, handler: nil)
    }

    func test_get_Albums() throws {
        let expectation = self.expectation(description: "")
        mockAlbumsServicesClient.getAlbums(userId: 1)
            .subscribe(onNext: { albums in
                XCTAssertTrue(albums.count > 0)
                expectation.fulfill()
            }) { (error) in
                XCTFail(error.localizedDescription)
            }.disposed(by: disposeBag)
        
        self.waitForExpectations(timeout: 4, handler: nil)
    }
    
    func test_get_Album_Details() throws {
        let expectation = self.expectation(description: "")
        mockAlbumsServicesClient.getAlbumDetails(userId: 1, albumId: 1)
            .subscribe(onNext: { albumDetails in
                XCTAssertTrue(albumDetails.count > 0)
                expectation.fulfill()
            }) { (error) in
                XCTFail(error.localizedDescription)
            }.disposed(by: disposeBag)
        
        self.waitForExpectations(timeout: 4, handler: nil)
    }

}
