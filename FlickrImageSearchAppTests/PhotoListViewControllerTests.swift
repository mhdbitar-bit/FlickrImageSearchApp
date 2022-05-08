@testable import FlickrImageSearchApp
import XCTest

final class PhotoListViewControllerTests: XCTestCase {
    
    func test_canInit() {
        let sut = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut.collectionView)
    }
    
    func test_configureCollectionView() {
        let sut = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.collectionView.delegate, "Expeted CollectionViewDelegate to be not nil")
        XCTAssertNotNil(sut.collectionView.dataSource, "Expeted CollectionDataSrouce to be not nil")
    }
    
    func test_viewDidLoad_initialState() {
        let sut = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 0, "Expected number of items is equal to zero")
    }
    
    func test_displayingTitle() {
        let sut = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, "Photos")
    }
    
    // MARK: - Helpers
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> PhotoListViewController {
        let client = URLSessionHTTPClient(session: .shared)
        let remoteService = RemotePhotoService(client: client)
        let imageService = RemoteImageDataService(client: client)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let localStore = try! CoreDataSearchStore(storeURL: storeURL)
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
