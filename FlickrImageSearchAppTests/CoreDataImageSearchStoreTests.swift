@testable import FlickrImageSearchApp
import XCTest

final class CoreDataImageSearchStoreTests: XCTestCase {

    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        sut.retrieve { result in
            switch result {
            case .success(let terms):
                XCTAssertEqual(terms, [])
            case .failure(let error):
                XCTFail("Expected to retrieve empty terms, got \(error) instead")
            }
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> SearchKeywoardStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataSearchStore(storeURL: storeURL)
        return sut
    }
}
