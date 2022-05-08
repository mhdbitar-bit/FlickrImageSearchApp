@testable import FlickrImageSearchApp
import XCTest

final class HTTPClientTests: XCTestCase {
    
    var urlSession: URLSession!
    
    func test_performsGETRequestWithURL() {
        let url = anyURL()
        let exp = expectation(description: "Wait for request")
        
        URLProtocolStub.requestHandler = { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
            return (HTTPURLResponse(), Data("any data".utf8))
        }
        
        makeSUT().getRquest(from: anyURL(), completion: { _ in })
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makeSUT() -> HTTPClient {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        return URLSessionHTTPClient(session: session)
    }
}
