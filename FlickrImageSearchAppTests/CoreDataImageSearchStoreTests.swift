@testable import FlickrImageSearchApp
import XCTest

final class CoreDataImageSearchStoreTests: XCTestCase {

    func test_retrieve_deliversEmptyOnEmptyCache() {
        expectToRetrieve(makeSUT(), expectedResult: [])
    }
    
    func test_insert_searchTerm() {
        expectToInsert(makeSUT(), with: "any")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> SearchKeywoardStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataSearchStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expectToRetrieve(_ sut: SearchKeywoardStore, expectedResult: [String], file: StaticString = #filePath, line: UInt = #line) {
        sut.retrieve { retrieveResult in
            switch retrieveResult {
            case .success(let values):
                XCTAssertEqual(values.count, expectedResult.count)
            case .failure(let error):
                XCTFail("Expected to retrieve empty terms, got \(error) instead", file: file, line: line)
            }
        }
    }
    
    private func expectToInsert(_ sut: SearchKeywoardStore, with term: String, file: StaticString = #filePath, line: UInt = #line) {
        sut.insert(term) { result in
            switch result {
            case .failure(let error):
                XCTAssertNil(error, file: file, line: line)
            case .success:
                break
            }
        }
    }
}
