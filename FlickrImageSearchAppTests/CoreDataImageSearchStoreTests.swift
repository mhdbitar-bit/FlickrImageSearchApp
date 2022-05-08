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
    
    func test_insert_searchTerm() {
        let sut = makeSUT()
        let term = "any"
        
        sut.insert(term) { result in
            switch result {
            case .success:
                sut.retrieve { retrieveResult in
                    switch retrieveResult {
                    case .success(let values):
                        XCTAssertEqual(values.count, 1)
                    case .failure(let error):
                        XCTFail("Expected to retrieve empty terms, got \(error) instead")
                    }
                }
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
}
