//
//  XCTestCase+PublisherResult.swift
//  AsyncImageTests
//
//  Created by Dorin Danciu on 28/05/2020.
//  Copyright © 2020 Beilmo. All rights reserved.
//

import XCTest
import Combine

extension XCTestCase {
    typealias CompetionResult = (expectation: XCTestExpectation, cancellable: AnyCancellable)

    func expectValue<T: Publisher>(of publisher: T,
                                   file: StaticString = #file,
                                   line: UInt = #line,
                                   equals: [(T.Output) -> Bool])
        -> CompetionResult {
            let exp = expectation(description: "Correct values of " + String(describing: publisher))
            var mutableEquals = equals
            let cancellable = publisher
                .sink(receiveCompletion: { _ in },
                      receiveValue: { value in
                        if mutableEquals.first?(value) ?? false {
                            _ = mutableEquals.remove(at: 0)
                            if mutableEquals.isEmpty {
                                exp.fulfill()
                            }
                        }
                })
            return (exp, cancellable)
    }
}
