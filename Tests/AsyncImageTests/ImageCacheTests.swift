//
//  ImageCacheTests.swift
//  AsyncImageTests
//
//  Created by Dorin Danciu on 28/05/2020.
//  Copyright © 2020 Beilmo. All rights reserved.
//

import XCTest
@testable import AsyncImage

final class ImageCacheTests: XCTestCase {
    var sut: ImageCache!

    override func setUp() {
        sut = TemporaryImageCache()
    }

    override func tearDown() {
        sut = nil
    }

    func testTempImageStore() {
        let url = URL(string: "file:///test")!
        let image = Image()
        sut[url] = image

        XCTAssertEqual(sut[url], image)
    }

    func testTempImageRemoval() {
        let url = URL(string: "file:///test")!
        let image = Image()
        sut[url] = image

        XCTAssertNotNil(sut[url])

        sut[url] = nil
        XCTAssertNil(sut[url])
    }

    static var allTests = [
        ("testTempImageStore", testTempImageStore),
        ("testTempImageRemoval", testTempImageRemoval),
    ]
}
