@testable import FlickrImageSearchApp
import XCTest

final class URLSessionHTTPClientTests: XCTestCase {
    
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
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        
        let sut = URLSessionHTTPClient(session: session)
        
        sut.getRquest(from: anyURL(), completion: { _ in })
        
        wait(for: [exp], timeout: 1.0)
    }
}
