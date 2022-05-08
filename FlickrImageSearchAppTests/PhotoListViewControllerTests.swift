@testable import FlickrImageSearchApp
import XCTest

final class PhotoListViewControllerTests: XCTestCase {
    
    func test_canInit() {
//        let sut = makeSUT()
//        sut.loadViewIfNeeded()
//        
//        XCTAssertNotNil(sut.collectionView)
    }
    
    // MARK: - Helpers
    
    func makeSUT() -> PhotoListViewController {
        let client = URLSessionHTTPClient(session: .shared)
        let remoteService = RemotePhotoService(client: client)
        let imageService = RemoteImageDataService(client: client)
        let localStoreURL = anyURL()
        
        let localStore = try! CoreDataSearchStore(storeURL: localStoreURL)
        let keywordsService = SearchKeywordService(store: localStore)
        
        let photoOperation = Operations()
        let viewModel = PhotoListViewModel(
            remoteService: remoteService,
            imageService: imageService,
            searchKeywordService: keywordsService,
            photoOperation: photoOperation)
        let vc = PhotoListViewController(viewModel: viewModel)
        return vc
    }
}
