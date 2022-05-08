@testable import FlickrImageSearchApp
import XCTest

final class CoreDataImageSearchStoreTests: XCTestCase {

    func test_retrieve_deliversEmptyOnEmptyCache() {
        expectToRetrieve(makeSUT(), expectedResult: [])
    }
    
    func test_insert_searchTerm() {
        let sut = makeSUT()
        let term = "any"
        
        sut.insert(term) { [weak self] result in
            switch result {
            case .success:
                self?.expectToRetrieve(sut, expectedResult: [term])
            case .failure(let error):
                XCTFail("Expected to insert term, got \(error) instead")
            }
        }
    }
    
//    func test_retrieve_deliversValuesOnNonEmptyCache() {
//        let sut = makeSUT()
//        let terms = ["search tearm 1", "search term 2"]
//
//        sut.insert(<#T##keyword: String##String#>, completion: <#T##(Result<Void, Error>) -> Void#>)
//    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> SearchKeywoardStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataSearchStore(storeURL: storeURL)
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
}
