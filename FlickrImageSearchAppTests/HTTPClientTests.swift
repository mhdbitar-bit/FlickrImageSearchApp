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
            return (HTTPURLResponse(), anyData())
        }
        
        makeSUT().getRquest(from: anyURL(), completion: { _ in })
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_performGETRequestWithURLWithSuccessResponse() {
        let data = anyData()
        let response = anyResponse()
        let exp = expectation(description: "Wait for request")
        
        URLProtocolStub.requestHandler = { _ in
            return (response, data)
        }
        
        makeSUT().getRquest(from: anyURL()) { result in
            switch result {
            case .success(let vales):
                XCTAssertEqual(vales.data, data)
                XCTAssertEqual(vales.response.url, response.url)
                XCTAssertEqual(vales.response.statusCode, response.statusCode)
                
            case .failure(let error):
                XCTFail("Error was not expected: \(error)")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> HTTPClient {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        return URLSessionHTTPClient(session: session)
    }
}
