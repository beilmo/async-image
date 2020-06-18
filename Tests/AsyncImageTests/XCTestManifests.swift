import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AsyncImageTests.allTests),
        testCase(ImageCacheTests.allTests),
        testCase(ImageLoaderTests.allTests)
    ]
}
#endif
