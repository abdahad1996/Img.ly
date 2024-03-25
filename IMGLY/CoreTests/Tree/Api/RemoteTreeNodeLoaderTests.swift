//
//  RemoteTreeNodeLoader.swift
//  CoreTests
//
//  Created by macbook abdul on 25/03/2024.
//

import Foundation
import XCTest
import Core

class RemoteTreeNodeLoaderTests:XCTestCase{
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requests.isEmpty)
    }
    
    func test_load_checksUrlConstruction() async {
        let url = URL(string: "https://ubique.img.ly/frontend-tha")!
        let (sut, client) = makeSUT(url: url)

        _ = try? await sut.load()

        XCTAssertEqual(client.requestedURLs[0].absoluteString, "https://ubique.img.ly/frontend-tha/data.json")
    }
    
    func test_loadTwice_requestsDataFromURLTwice() async {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        _ = try? await sut.load()
        _ = try? await sut.load()

        XCTAssertEqual(client.requestedURLs.count, 2)
    }
    
    func test_load_deliversConnectivityErrorOnClientError() async throws {
        let (sut, _) = makeSUT(error: .connectivity)
        do {
            let result = try await sut.load()
            XCTFail("Expected result \(RemoteTreeNodeLoader.Error.connectivity) got \(result) instead")
        } catch let error as RemoteTreeNodeLoader.Error {
            XCTAssertEqual(error, .connectivity)
        }
    }
    
    func test_load_deliversInvalidDataErrorOnNon200HTTPResponse() async throws {
        let samples = [199, 201, 300, 400, 500]

        for code in samples {
            let json = emptyJsonData
            let httpURLResponse = HTTPURLResponse(url: anyURL(), statusCode: code, httpVersion: nil, headerFields: nil)!

            let (sut, _) = makeSUT(result: (json, httpURLResponse))

            do {
                let result = try await sut.load()
                XCTFail("Expected result \(RemoteTreeNodeLoader.Error.invalidData) got \(result) instead")
            } catch let error as RemoteTreeNodeLoader.Error {
                XCTAssertEqual(error, .invalidData)
            }
        }
    }
    
    func test_load_deliversSuccessWithNoItemsOn200HTTPResponseWithEmptyJSONList() async throws {
        
        let emptyListJSON = emptyJsonData
        let httpURLResponse = HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!

        let (sut, _) = makeSUT(result: (emptyListJSON, httpURLResponse))

        do {
            let result = try await sut.load()
            XCTAssertEqual(result, [])
        } catch let error as RemoteTreeNodeLoader.Error {
            XCTFail("Expected result \([]) got \(error) instead")
        }
    }
    
    
    func test_load_deliversSuccessWithTreeNodesOn200HTTPResponseWithJSONItems() async throws {
        
        let json = jsonData
        let httpURLResponse = HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!

        let (sut, _) = makeSUT(result: (json, httpURLResponse))

        

        do {
            let result = try await sut.load()
            XCTAssertEqual(result[0].label, "img.ly")
            XCTAssertEqual(result[0].level, 1)
            XCTAssertEqual(result[0].children![0].label, "Workspace A")
            XCTAssertEqual(result[0].children![0].level, 2)
            XCTAssertEqual(result[0].children![0].children![0].label, "Entry 1")
            XCTAssertEqual(result[0].children![0].children![0].level, 3)


        } catch let error as RemoteTreeNodeLoader.Error {
            XCTFail("Expected result got \(error) instead")
        }
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

    

    // MARK: - JSON HELPERS
    let emptyJsonData = """
    []
    """.data(using: .utf8)!

    let jsonData = """
    [
        {
            "label": "img.ly",
            "children": [
                {
                    "label": "Workspace A",
                    "children": [
                        { "id": "imgly.A.1", "label": "Entry 1" },
                        { "id": "imgly.A.2", "label": "Entry 2" },
                        { "id": "imgly.A.3", "label": "Entry 3" }
                    ]
                },
                {
                    "label": "Workspace B",
                    "children": [
                        { "id": "imgly.B.1", "label": "Entry 1" },
                        { "id": "imgly.B.2", "label": "Entry 2" },
                        {
                            "label": "Entry 3",
                            "children": [
                                {
                                    "id": "imgly.B.3.1",
                                    "label": "Sub-Entry 1"
                                }
                            ]
                        }
                    ]
                }
            ]
        },
        {
            "label": "9elements",
            "children": [
                {
                    "label": "Workspace A",
                    "children": [
                        {
                            "id": "9e.A.1",
                            "label": "Entry 1"
                        },
                        {
                            "id": "9e.A.2",
                            "label": "Entry 2"
                        }
                    ]
                }
            ]
        }
    ]
    """.data(using: .utf8)!

}

