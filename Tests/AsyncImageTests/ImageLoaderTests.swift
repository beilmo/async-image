//
//  ImageLoaderTests.swift
//  AsyncImageTests
//
//  Created by Dorin Danciu on 28/05/2020.
//  Copyright © 2020 Beilmo. All rights reserved.
//

import XCTest
@testable import AsyncImage

final class ImageLoaderTests: XCTestCase {
    var url: URL!
    var cache: ImageCache!
    var sut: ImageLoader!

    override func setUp() {
        url = URL(string: "http://cdn.sci-news.com/images/enlarge2/image_3274_1e-Pluto.jpg")
        cache = TemporaryImageCache()
        sut = ImageLoader(url: url, cache: cache)
    }

    override func tearDown() {
        url = nil
        cache = nil
        sut = nil
    }

    func testLoad() {
        cache[url] = nil
        XCTAssertNil(cache[url])
        XCTAssertNil(sut.image)
        XCTAssertEqual(sut.status, .unknown)

        let image = expectValue(of: sut.$image,
                                equals: [{ $0 == nil },
                                         { $0 != nil }])

        let status = expectValue(of: sut.$status,
                                 equals: [{ $0 == .unknown },
                                          { $0 == .waiting },
                                          { $0 == .loading },
                                          { $0 == .completed }])

        sut.load()
        sut.load()
        DispatchQueue.main.async {
            self.sut.load()
        }

        wait(for: [
            image.expectation,
            status.expectation
        ], timeout: 4)

        XCTAssertEqual(sut.status, .completed)
        XCTAssertNotNil(sut.image)
        XCTAssertNotNil(cache[url])
        XCTAssertEqual(cache[url], sut.image)
    }

    func testReload() {
        cache[url] = nil
        XCTAssertNil(cache[url])
        XCTAssertNil(sut.image)
        XCTAssertEqual(sut.status, .unknown)

        let image = expectValue(of: sut.$image,
                                equals: [{ $0 == nil },
                                         { $0 != nil }])

        let status = expectValue(of: sut.$status,
                                 equals: [{ $0 == .unknown },
                                          { $0 == .waiting },
                                          { $0 == .loading },
                                          { $0 == .completed }])

        sut.load()

        wait(for: [
            image.expectation,
            status.expectation
        ], timeout: 4)

        XCTAssertEqual(sut.status, .completed)
        XCTAssertNotNil(sut.image)
        XCTAssertNotNil(cache[url])
        XCTAssertEqual(cache[url], sut.image)

        sut.load()

        XCTAssertEqual(sut.status, .completed)
        XCTAssertNotNil(sut.image)
        XCTAssertNotNil(cache[url])
        XCTAssertEqual(cache[url], sut.image)
    }

    func testCancel() {
        cache[url] = nil
        XCTAssertNil(cache[url])
        XCTAssertNil(sut.image)
        XCTAssertEqual(sut.status, .unknown)

        let image = expectValue(of: sut.$image,
                                equals: [{ $0 == nil }])

        let status = expectValue(of: sut.$status,
                                 equals: [{ $0 == .unknown }])

        sut.cancel()

        wait(for: [
            image.expectation,
            status.expectation
        ], timeout: 4)

        XCTAssertEqual(sut.status, .unknown)
        XCTAssertNil(sut.image)
        XCTAssertEqual(cache[url], nil)
    }

    func testLoadThenCancel() {
        cache[url] = nil
        XCTAssertNil(cache[url])
        XCTAssertNil(sut.image)
        XCTAssertEqual(sut.status, .unknown)

        let image = expectValue(of: sut.$image,
                                equals: [{ $0 == nil }])

        let status = expectValue(of: sut.$status,
                                 equals: [{ $0 == .unknown },
                                          { $0 == .waiting },
                                          { $0 == .canceled }])

        sut.load()
        sut.cancel()

        wait(for: [
            image.expectation,
            status.expectation
        ], timeout: 4)

        XCTAssertEqual(sut.status, .canceled)
        XCTAssertNil(sut.image)
        XCTAssertEqual(cache[url], nil)
    }

    func testLoadWaitThenCancel() {
        cache[url] = nil
        XCTAssertNil(cache[url])
        XCTAssertNil(sut.image)
        XCTAssertEqual(sut.status, .unknown)

        let image = expectValue(of: sut.$image,
                                equals: [{ $0 == nil }])

        let status = expectValue(of: sut.$status,
                                 equals: [{ $0 == .unknown },
                                          { $0 == .waiting },
                                          { $0 == .loading },
                                          { $0 == .canceled }])

        sut.load()

        DispatchQueue.main.async {
            self.sut.cancel()
        }

        wait(for: [
            image.expectation,
            status.expectation
        ], timeout: 4)

        XCTAssertEqual(sut.status, .canceled)
        XCTAssertNil(sut.image)
        XCTAssertEqual(cache[url], nil)
    }

    func testFailedLoad() {
        sut = ImageLoader(url: URL(string: "file:///www.google.com")!)
        XCTAssertNil(sut.image)
        XCTAssertEqual(sut.status, .unknown)

        let image = expectValue(of: sut.$image,
                                equals: [{ $0 == nil }])

        let status = expectValue(of: sut.$status,
                                 equals: [{ $0 == .unknown },
                                          { $0 == .waiting },
                                          { $0 == .loading },
                                          { $0 == .failed }])

        sut.load()

        wait(for: [
            image.expectation,
            status.expectation
        ], timeout: 4)

        XCTAssertEqual(sut.status, .failed)
        XCTAssertNil(sut.image)
    }

    static var allTests = [
        ("testLoad", testLoad),
        ("testReload", testReload),
        ("testCancel", testCancel),
        ("testFailedLoad", testFailedLoad),
        ("testLoadThenCancel", testLoadThenCancel),
        ("testLoadWaitThenCancel", testLoadWaitThenCancel),
    ]
}
