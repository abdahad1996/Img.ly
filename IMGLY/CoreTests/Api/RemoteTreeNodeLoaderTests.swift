//
//  RemoteTreeNodeLoader.swift
//  CoreTests
//
//  Created by macbook abdul on 25/03/2024.
//

import Foundation
import XCTest
import Core


public enum RemoteTreeMapper {
    struct RemoteTreeNode: Codable, Identifiable {
        
        let id: String
        let label: String
        var children: [RemoteTreeNode]? // Optional children

        // Custom initializer to set depth and parentId recursively
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
            label = try container.decode(String.self, forKey: .label)
            children = try container.decodeIfPresent([RemoteTreeNode].self, forKey: .children)
        }
        
        init(id: String, label: String, children: [RemoteTreeMapper.RemoteTreeNode]? = nil) {
            self.id = id
            self.label = label
            self.children = children
        }
    }

    static func mapToTreeNodes(nodes: [RemoteTreeNode], parentId: String? = nil, level: Int = 1) -> [TreeNode] {
        return nodes.flatMap { remoteNode -> [TreeNode] in
            let nodeId = remoteNode.id
            let nodeLabel = remoteNode.label
            let parentNodeId = parentId
            let nodeLevel = level

            var childrenNodes: [TreeNode]?
            if let remoteChildren = remoteNode.children {
                childrenNodes = mapToTreeNodes(nodes: remoteChildren, parentId: nodeId, level: nodeLevel + 1)
            }

            let treeNode =
                TreeNode(id: nodeId, label: nodeLabel, children: childrenNodes, parentId: parentNodeId, level: nodeLevel)
            var result: [TreeNode] = [treeNode]

            if let childrenNodes = childrenNodes {
                result.append(contentsOf: childrenNodes)
            }

            return result
        }
    }

    private static var OK_200: Int { return 200 }
    public static func mapToTreeNodes(from data: Data, response: HTTPURLResponse) throws -> [TreeNode] {
        guard response.statusCode == OK_200, let remoteTreeNodes = try? JSONDecoder().decode([RemoteTreeNode].self, from: data) else {
            throw RemoteTreeNodeLoader.Error.invalidData
        }
        let result = self.mapToTreeNodes(nodes: remoteTreeNodes)
        return result
    }
}
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
        let (data, response) = try await self.client.get(from: url)
        return try RemoteTreeMapper.mapToTreeNodes(from: data, response: response)
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
            let json = RemoteTreeMapper.convertNodeHierarchyToJSON(nodes: [])
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
        
        let emptyListJSON = RemoteTreeMapper.convertNodeHierarchyToJSON(nodes: [])
        let httpURLResponse = HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!

        let (sut, _) = makeSUT(result: (emptyListJSON, httpURLResponse))

        do {
            let result = try await sut.load()
            XCTAssertEqual(result, [])
        } catch let error as RemoteTreeNodeLoader.Error {
            XCTFail("Expected result \([]) got \(error) instead")
        }
    }
    
//    func test_load_deliversSuccessWithRemoteTreeNodesOn200HTTPResponseWithJSONItems() async throws {
//        
//        let items = buildNodeHierarchy()
//        let json = convertNodeHierarchyToJSON(nodes: items)
//        let httpURLResponse = HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
//
//        let (sut, _) = makeSUT(result: (json, httpURLResponse))
//
//        
//
//        do {
//            let result = try await sut.load()
//            XCTAssertEqual(result, items)
//        } catch let error as RemoteTreeNodeLoader.Error {
//            XCTFail("Expected result \(items) got \(error) instead")
//        }
//    }
    
    func test_load_deliversSuccessWithTreeNodesOn200HTTPResponseWithJSONItems() async throws {
        
        let json = RemoteTreeMapper.convertNodeHierarchyToJSON()
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
    
    private func anyValidResponse() -> (Data, HTTPURLResponse) {
        (Data(), HTTPURLResponse())
    }

    private func anyURL() -> URL {
        return URL(string: "https://a-url.com")!
    }
    
    

    // Method to build the node hierarchy
//    func buildNodeHierarchy() -> [TreeNode] {
//        let entry1 = TreeNode(id: "imgly.A.1", label: "Entry 1")
//        let entry2 = TreeNode(id: "imgly.A.2", label: "Entry 2")
//        let entry3 = TreeNode(id: "imgly.A.3", label: "Entry 3")
//
//        let subEntry1 = TreeNode(id: "imgly.B.3.1", label: "Sub-Entry 1")
//        let entry3Node = TreeNode(id: "", label: "Entry 3", children: [subEntry1])
//
//        let workspaceA = TreeNode(id: "", label: "Workspace A", children: [entry1, entry2, entry3])
//        let workspaceB = TreeNode(id: "", label: "Workspace B", children: [entry1, entry2, entry3Node])
//
//        let imgly = TreeNode(id: "", label: "img.ly", children: [workspaceA, workspaceB])
//
//        let entry1_9e = TreeNode(id: "9e.A.1", label: "Entry 1")
//        let entry2_9e = TreeNode(id: "9e.A.2", label: "Entry 2")
//        let workspaceA_9e = TreeNode(id: "", label: "Workspace A", children: [entry1_9e, entry2_9e])
//
//        let nineElements = TreeNode(id: "", label: "9elements", children: [workspaceA_9e])
//
//        return [imgly, nineElements]
//    }
    
//    func convertNodeHierarchyToJSON(nodes: [TreeNode]) -> Data {
//        
//            let nodes = buildNodeHierarchy()
//            let encoder = JSONEncoder()
//            encoder.outputFormatting = .prettyPrinted // For pretty printing
//            let jsonData = try! encoder.encode(nodes)
//            
//            if let jsonString = String(data: jsonData, encoding: .utf8) {
//                print(jsonString)
//            }
//            return jsonData
//         
//    }
}

extension RemoteTreeMapper{
   static func buildNodeHierarchy() -> [RemoteTreeNode] {
        let entry1 = RemoteTreeNode(id: "imgly.A.1", label: "Entry 1")
        let entry2 = RemoteTreeNode(id: "imgly.A.2", label: "Entry 2")
        let entry3 = RemoteTreeNode(id: "imgly.A.3", label: "Entry 3")

        let subEntry1 = RemoteTreeNode(id: "imgly.B.3.1", label: "Sub-Entry 1")
        let entry3Node = RemoteTreeNode(id: UUID().uuidString, label: "Entry 3", children: [subEntry1])

        let workspaceA = RemoteTreeNode(id: UUID().uuidString, label: "Workspace A", children: [entry1, entry2, entry3])
        let workspaceB = RemoteTreeNode(id: UUID().uuidString, label: "Workspace B", children: [entry1, entry2, entry3Node])

        let imgly = RemoteTreeNode(id: UUID().uuidString, label: "img.ly", children: [workspaceA, workspaceB])

        let entry1_9e = RemoteTreeNode(id: "9e.A.1", label: "Entry 1")
        let entry2_9e = RemoteTreeNode(id: "9e.A.2", label: "Entry 2")
        let workspaceA_9e = RemoteTreeNode(id: UUID().uuidString, label: "Workspace A", children: [entry1_9e, entry2_9e])

        let nineElements = RemoteTreeNode(id: UUID().uuidString, label: "9elements", children: [workspaceA_9e])

        return [imgly, nineElements]
    }
    
    static func convertNodeHierarchyToJSON(nodes: [RemoteTreeNode] = buildNodeHierarchy()) -> Data {
        
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted // For pretty printing
            let jsonData = try! encoder.encode(nodes)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
            return jsonData
         
    }
    
}
