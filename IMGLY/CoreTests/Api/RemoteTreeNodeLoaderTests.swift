//
//  RemoteTreeNodeLoader.swift
//  CoreTests
//
//  Created by macbook abdul on 25/03/2024.
//

import Foundation
import XCTest
import Core


public protocol HTTPClient {
    func get(from url: URL) async throws -> (Data, HTTPURLResponse)
}

class RemoteTreeNodeLoader:TreeNodeLoader {
    
    let url:URL
    let client:HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    func load() async throws -> [TreeNode] {
        
       try await client.get(from: url)
        throw Error.connectivity
    }
    
    
}
class RemoteTreeNodeLoaderTests:XCTestCase{
    
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requests.isEmpty)
    }
    
    func test_loadTwice_requestsDataFromURLTwice() async {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        _ = try? await sut.load()
        _ = try? await sut.load()

        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, result: (Data, HTTPURLResponse)? = nil, error: RemoteTreeNodeLoader.Error? = nil, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteTreeNodeLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy(result: result, error: error)
        let sut = RemoteTreeNodeLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    class HTTPClientSpy: HTTPClient {
        private(set) var requests = [URL]()
        private let result: (Data, HTTPURLResponse)?
        private let error: RemoteTreeNodeLoader.Error?

        var requestedURLs: [URL] {
            return requests
        }

        init(result: (Data, HTTPURLResponse)?, error: RemoteTreeNodeLoader.Error?) {
            self.result = result
            self.error = error
        }

        func get(from url: URL) async throws -> (Data, HTTPURLResponse) {
            self.requests.append(url)
            guard let result = result else {
                throw error ?? .connectivity
            }

            return result
        }
    }
}


