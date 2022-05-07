@testable import FlickrImageSearchApp
import XCTest

final class FlickrEndpointTests: XCTestCase {
    
    func test_searchPhotos_endpointURL() throws {
        let baseURL = URL(string: "https://any-url.com")!
        let key = Constants.apikey
        let searchTerm = "any"
        let perPage = Constants.perPage
        let page = 1
        let received = FlickrEndpoint.searchPhotos(searchTerm: searchTerm, page: page).url(baseURL: baseURL)
        
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "any-url.com", "host")
        XCTAssertEqual(received.path, "/services/rest", "path")
        XCTAssertEqual(received.query, "method=flickr.photos.search&api_key=\(key)&format=json&nojsoncallback=1&safe_search=1&per_page=\(perPage)&text=\(searchTerm)&page=\(page)", "query")
    }    
}
